//
//  Calculator.swift
//  cgtcalc
//
//  Created by Matt Galloway on 06/06/2020.
//

import Foundation

public class Calculator {
  private let input: CalculatorInput
  private let logger: Logger

  public init(input: CalculatorInput, logger: Logger) throws {
    self.input = input
    self.logger = logger
  }

  public func process() throws -> CalculatorResult {
    self.logger.info("Begin processing")
    try self.preprocessTransactions()
    let calculatorResult = try self.processTransactions()
    self.logger.info("Finished processing")
    return calculatorResult
  }

  private func preprocessTransactions() throws {
    for transaction in self.input.transactions {
      // 6th April 2008 is when new CGT rules came in. We only support those new rules.
      if transaction.date < Date(timeIntervalSince1970: 1207440000) {
        throw CalculatorError.TransactionDateNotSupported
      }
    }
  }

  private func processTransactions() throws -> CalculatorResult {
    let transactionsByAsset = Dictionary(grouping: self.input.transactions, by: \.asset)
    let assetEventsByAsset = Dictionary(grouping: self.input.assetEvents, by: \.asset)

    let allAssets = Set<String>(transactionsByAsset.keys).union(Set<String>(assetEventsByAsset.keys))

    let allDisposalMatches = try allAssets
      .map { asset -> AssetResult in
        let transactions = try self.groupSameDayTransactions(transactionsByAsset[asset, default: []])
        var acquisitions: [TransactionToMatch] = []
        var disposals: [TransactionToMatch] = []
        transactions.forEach { transaction in
          let transactionToMatch = TransactionToMatch(transaction: transaction)
          switch transaction.kind {
          case .Buy:
            acquisitions.append(transactionToMatch)
          case .Sell:
            disposals.append(transactionToMatch)
          }
        }
        let assetEvents = assetEventsByAsset[asset, default: []].sorted { $0.date < $1.date }
        let state = AssetProcessorState(
          asset: asset,
          acquisitions: acquisitions,
          disposals: disposals,
          assetEvents: assetEvents)
        try self.preprocessAsset(withState: state)
        return try processAsset(withState: state)
      }
      .reduce(into: [DisposalMatch]()) { disposalMatches, assetResult in
        disposalMatches.append(contentsOf: assetResult.disposalMatches)
      }

    return try CalculatorResult(input: self.input, disposalMatches: allDisposalMatches)
  }

  private func groupSameDayTransactions(_ transactions: [Transaction]) throws -> [Transaction] {
    let initial: ([Transaction], Transaction?) = ([], nil)
    return try transactions
      .sorted { $0.date < $1.date }
      .reduce(into: initial) { returnValue, transaction in
        guard let groupTransaction = returnValue.1 else {
          returnValue.0.append(transaction)
          returnValue.1 = transaction
          return
        }
        if groupTransaction.date == transaction.date, groupTransaction.kind == transaction.kind {
          try groupTransaction.groupWith(transaction: transaction)
        } else {
          returnValue.0.append(transaction)
          returnValue.1 = transaction
        }
      }.0
  }

  private func preprocessAsset(withState state: AssetProcessorState) throws {
    guard state.assetEvents.count > 0 else {
      self.logger.info("No pre-processing of transactions required for \(state.asset).")
      return
    }

    guard state.pendingAcquisitions.count > 0 else {
      throw CalculatorError.InvalidData("Had events but no acquisitions for \(state.asset).")
    }

    self.logger.info("Begin pre-processing transactions for \(state.asset).")

    // First go over all the capital returns and decrease the price paid for acquisitions.
    var acquisitionsIndex = state.pendingAcquisitions.startIndex
    var disposalsIndex = state.pendingDisposals.startIndex
    var assetEventsIndex = state.assetEvents.startIndex
    var runningTotal = Decimal.zero
    while assetEventsIndex < state.assetEvents.endIndex {
      let assetEvent = state.assetEvents[assetEventsIndex]

      let amount: Decimal
      let value: Decimal
      switch assetEvent.kind {
      case .CapitalReturn(let a, let v):
        amount = a
        value = v
      default:
        assetEventsIndex += 1
        continue
      }

      self.logger.debug(" - Processing capital return event: \(assetEvent).")

      guard acquisitionsIndex < state.pendingAcquisitions.endIndex else {
        throw CalculatorError
          .InvalidData(
            "Error pre-processing \(state.asset) while processing capital return events. Found a capital return event but there are no remaining acquisitions to match against.")
      }

      var transactionsBeforeEvent: [TransactionToMatch] = []
      while acquisitionsIndex < state.pendingAcquisitions.endIndex {
        let acquisition = state.pendingAcquisitions[acquisitionsIndex]
        if acquisition.date < assetEvent.date {
          transactionsBeforeEvent.append(acquisition)
          acquisitionsIndex += 1
        } else {
          break
        }
      }

      while disposalsIndex < state.pendingDisposals.endIndex {
        let disposal = state.pendingDisposals[disposalsIndex]
        if disposal.date < assetEvent.date {
          transactionsBeforeEvent.append(disposal)
          disposalsIndex += 1
        } else {
          break
        }
      }

      transactionsBeforeEvent.sort { $0.date < $1.date }

      var acquisitionsMatched: [TransactionToMatch] = []
      var totalAcquisitionsAmount = Decimal.zero
      try transactionsBeforeEvent.forEach { transaction in
        switch transaction.transaction.kind {
        case .Buy:
          acquisitionsMatched.append(transaction)
          totalAcquisitionsAmount += transaction.amount
        case .Sell:
          // We need to check this is selling ALL at this point, otherwise it's not supported
          guard transaction.amount == runningTotal + totalAcquisitionsAmount else {
            throw CalculatorError
              .InvalidData(
                "Error pre-processing \(state.asset) while processing capital return events. Had disposals but did not dispose of everything held at that point. This is currently un-supported.")
          }
          runningTotal = Decimal.zero
          totalAcquisitionsAmount = Decimal.zero
          acquisitionsMatched.removeAll()
        }
      }

      guard amount == totalAcquisitionsAmount else {
        throw CalculatorError
          .InvalidData("Error pre-processing \(state.asset). Capital return amount doesn't match acquisitions.")
      }

      acquisitionsMatched.forEach { acquisition in
        let apportionedValue = value * (acquisition.amount / amount)
        self.logger.debug("    - Matching to acquisition \(acquisition), apportioned value of \(apportionedValue).")
        acquisition.subtractOffset(amount: apportionedValue)
      }

      runningTotal += amount
      assetEventsIndex += 1
    }

    // Second go over all the dividends and increase the price paid for acquisitions.
    assetEventsIndex = state.assetEvents.startIndex
    while assetEventsIndex < state.assetEvents.endIndex {
      let assetEvent = state.assetEvents[assetEventsIndex]

      let amount: Decimal
      let value: Decimal
      switch assetEvent.kind {
      case .Dividend(let a, let v):
        amount = a
        value = v
      default:
        assetEventsIndex += 1
        continue
      }

      self.logger.debug(" - Processing dividend event: \(assetEvent).")

      var acquisitionsIndex = state.pendingAcquisitions.startIndex
      var disposalsIndex = state.pendingDisposals.startIndex

      var transactionsBeforeEvent: [TransactionToMatch] = []
      while acquisitionsIndex < state.pendingAcquisitions.endIndex {
        let acquisition = state.pendingAcquisitions[acquisitionsIndex]
        if acquisition.date < assetEvent.date {
          transactionsBeforeEvent.append(acquisition)
          acquisitionsIndex += 1
        } else {
          break
        }
      }

      while disposalsIndex < state.pendingDisposals.endIndex {
        let disposal = state.pendingDisposals[disposalsIndex]
        if disposal.date < assetEvent.date {
          transactionsBeforeEvent.append(disposal)
          disposalsIndex += 1
        } else {
          break
        }
      }

      transactionsBeforeEvent.sort { $0.date < $1.date }

      var acquisitionsMatched: [TransactionToMatch] = []
      var totalAcquisitionsAmount = Decimal.zero
      try transactionsBeforeEvent.forEach { transaction in
        switch transaction.transaction.kind {
        case .Buy:
          acquisitionsMatched.append(transaction)
          totalAcquisitionsAmount += transaction.amount
        case .Sell:
          // We need to check this is selling ALL at this point, otherwise it's not supported
          guard transaction.amount == totalAcquisitionsAmount else {
            throw CalculatorError
              .InvalidData(
                "Error pre-processing \(state.asset) while processing dividend events. Had disposals but did not dispose of everything held at that point. This is currently un-supported.")
          }
          totalAcquisitionsAmount = Decimal.zero
          acquisitionsMatched.removeAll()
        }
      }

      guard amount == totalAcquisitionsAmount else {
        throw CalculatorError
          .InvalidData("Error pre-processing \(state.asset). Dividend amount doesn't match acquisitions.")
      }

      acquisitionsMatched.forEach { acquisition in
        let apportionedValue = value * (acquisition.amount / amount)
        self.logger.debug("    - Matching to acquisition \(acquisition), apportioned value of \(apportionedValue).")
        acquisition.addOffset(amount: apportionedValue)
      }

      assetEventsIndex += 1
    }

    self.logger.info("Finished pre-processing transactions for \(state.asset).")
  }

  private func processAsset(withState state: AssetProcessorState) throws -> AssetResult {
    self.logger.info("Begin processing transactions for \(state.asset).")

    let matchingProcessor = MatchingProcessor(state: state, logger: self.logger)
    try matchingProcessor.process()

    let section104Processor = Section104Processor(state: state, logger: self.logger)
    try section104Processor.process()

    if !state.isComplete {
      throw CalculatorError.Incomplete
    }

    self.logger.debug("Tax events for \(state.asset)")
    state.disposalMatches.forEach { self.logger.debug("  \($0)") }
    self.logger
      .info("Finished processing transactions for \(state.asset). Created \(state.disposalMatches.count) tax events.")

    return AssetResult(asset: state.asset, disposalMatches: state.disposalMatches)
  }
}
