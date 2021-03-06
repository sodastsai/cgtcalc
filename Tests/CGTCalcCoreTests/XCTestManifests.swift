#if !canImport(ObjectiveC)
  import XCTest

  extension AssetEventTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AssetEventTests = [
      ("testEquality", testEquality),
      ("testHashable", testHashable)
    ]
  }

  extension CalculatorResultTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CalculatorResultTests = [
      ("testFailsWhenTaxYearHasNoRates", testFailsWhenTaxYearHasNoRates)
    ]
  }

  extension CalculatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CalculatorTests = [
      ("testAssetEventCapitalReturnTooLarge", testAssetEventCapitalReturnTooLarge),
      ("testAssetEventCapitalReturnTooSmall", testAssetEventCapitalReturnTooSmall),
      ("testAssetEventDividendNotMatchingAmount", testAssetEventDividendNotMatchingAmount),
      ("testAssetEventDividendTooLarge", testAssetEventDividendTooLarge),
      ("testAssetEventDividendTooSmall", testAssetEventDividendTooSmall),
      ("testAssetEventWithNoAcquisition", testAssetEventWithNoAcquisition),
      ("testBasicSingleAsset", testBasicSingleAsset),
      ("testBedAndBreakfastEdges", testBedAndBreakfastEdges),
      ("testCapitalReturnNotEnoughAcquisitionsThrows", testCapitalReturnNotEnoughAcquisitionsThrows),
      ("testDateBefore20080406Throws", testDateBefore20080406Throws),
      ("testSection104DisposeTooMuch", testSection104DisposeTooMuch),
      ("testSoldNotAllBeforeCapitalReturnThrows", testSoldNotAllBeforeCapitalReturnThrows),
      ("testSoldNotAllBeforeDividendThrows", testSoldNotAllBeforeDividendThrows)
    ]
  }

  extension DefaultParserTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DefaultParserTests = [
      ("testParseAllowsMultipleWhitespace", testParseAllowsMultipleWhitespace),
      ("testParseAssetEventIncorrectKindFails", testParseAssetEventIncorrectKindFails),
      ("testParseBuyTransactionSuccess", testParseBuyTransactionSuccess),
      (
        "testParseCapitalReturnAssetEventIncorrectDateFormatFails",
        testParseCapitalReturnAssetEventIncorrectDateFormatFails),
      ("testParseCapitalReturnEventIncorrectAmountFormatFails", testParseCapitalReturnEventIncorrectAmountFormatFails),
      (
        "testParseCapitalReturnEventIncorrectNumberOfFieldsFails",
        testParseCapitalReturnEventIncorrectNumberOfFieldsFails),
      ("testParseCapitalReturnEventIncorrectValueFormatFails", testParseCapitalReturnEventIncorrectValueFormatFails),
      ("testParseCapitalReturnEventSuccess", testParseCapitalReturnEventSuccess),
      ("testParseCommentSuccess", testParseCommentSuccess),
      ("testParseDividendAssetEventIncorrectAmountFormatFails", testParseDividendAssetEventIncorrectAmountFormatFails),
      ("testParseDividendAssetEventIncorrectDateFormatFails", testParseDividendAssetEventIncorrectDateFormatFails),
      (
        "testParseDividendAssetEventIncorrectNumberOfFieldsFails",
        testParseDividendAssetEventIncorrectNumberOfFieldsFails),
      ("testParseDividendAssetEventIncorrectValueFormatFails", testParseDividendAssetEventIncorrectValueFormatFails),
      ("testParseDividendEventSuccess", testParseDividendEventSuccess),
      ("testParseSellTransactionSuccess", testParseSellTransactionSuccess),
      ("testParseSplitAssetEventIncorrectDateFormatFails", testParseSplitAssetEventIncorrectDateFormatFails),
      ("testParseSplitEventIncorrectAmountFormatFails", testParseSplitEventIncorrectAmountFormatFails),
      ("testParseSplitEventIncorrectNumberOfFieldsFails", testParseSplitEventIncorrectNumberOfFieldsFails),
      ("testParseSplitEventSuccess", testParseSplitEventSuccess),
      ("testParseStripsTrailingWhitespace", testParseStripsTrailingWhitespace),
      ("testParseTransactionIncorrectAmountFormatFails", testParseTransactionIncorrectAmountFormatFails),
      ("testParseTransactionIncorrectDateFormatFails", testParseTransactionIncorrectDateFormatFails),
      ("testParseTransactionIncorrectExpensesFormatFails", testParseTransactionIncorrectExpensesFormatFails),
      ("testParseTransactionIncorrectKindFails", testParseTransactionIncorrectKindFails),
      ("testParseTransactionIncorrectNumberOfFieldsFails", testParseTransactionIncorrectNumberOfFieldsFails),
      ("testParseTransactionIncorrectPriceFormatFails", testParseTransactionIncorrectPriceFormatFails),
      ("testParseUnsplitAssetEventIncorrectDateFormatFails", testParseUnsplitAssetEventIncorrectDateFormatFails),
      ("testParseUnsplitEventIncorrectAmountFormatFails", testParseUnsplitEventIncorrectAmountFormatFails),
      ("testParseUnsplitEventIncorrectNumberOfFieldsFails", testParseUnsplitEventIncorrectNumberOfFieldsFails),
      ("testParseUnsplitEventSuccess", testParseUnsplitEventSuccess)
    ]
  }

  extension DescriptionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DescriptionTests = [
      ("testAssetResult", testAssetResult),
      ("testDisposalMatch", testDisposalMatch),
      ("testSection104HoldingState", testSection104HoldingState),
      ("testTaxYear", testTaxYear),
      ("testTransaction", testTransaction),
      ("testTransactionToMatch", testTransactionToMatch)
    ]
  }

  extension DisposalMatchTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DisposalMatchTests = [
      ("testMatchingDisposal", testMatchingDisposal),
      ("testSection104Disposal", testSection104Disposal)
    ]
  }

  extension ExamplesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ExamplesTests = [
      ("testExamples", testExamples)
    ]
  }

  extension MatchingProcessorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MatchingProcessorTests = [
      ("testSimple", testSimple),
      ("testWithAssetEvents", testWithAssetEvents)
    ]
  }

  extension Section104HoldingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__Section104HoldingTests = [
      ("testProcessesAcquisitionsCorrectly", testProcessesAcquisitionsCorrectly),
      ("testProcessesDisposalsCorrectly", testProcessesDisposalsCorrectly),
      ("testProcessesDisposalsWithSplitsCorrectly", testProcessesDisposalsWithSplitsCorrectly),
      ("testProcessesManyDisposalsCorrectly", testProcessesManyDisposalsCorrectly),
      ("testProcessesTooBigDisposalCorrectly", testProcessesTooBigDisposalCorrectly)
    ]
  }

  extension TaxYearTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TaxYearTests = [
      ("testDatesToTaxYearCorrect", testDatesToTaxYearCorrect),
      ("testTaxYearCompare", testTaxYearCompare),
      ("testTaxYearRatesAvailable", testTaxYearRatesAvailable),
      ("testTaxYearStringCorrect", testTaxYearStringCorrect)
    ]
  }

  extension TransactionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TransactionTests = [
      ("testEquality", testEquality),
      ("testGrouped", testGrouped),
      ("testGroupedDifferentAsset", testGroupedDifferentAsset),
      ("testGroupedDifferentDate", testGroupedDifferentDate),
      ("testGroupedDifferentKind", testGroupedDifferentKind),
      ("testGroupedMultiple", testGroupedMultiple),
      ("testHashable", testHashable)
    ]
  }

  extension TransactionToMatchTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__TransactionToMatchTests = [
      ("testOffsetAndSplitWorks", testOffsetAndSplitWorks),
      ("testOffsetWorks", testOffsetWorks),
      ("testSplitSuccess", testSplitSuccess),
      ("testSplitTooMuchFails", testSplitTooMuchFails),
      ("testSplitTwiceSuccess", testSplitTwiceSuccess)
    ]
  }

  public func __allTests() -> [XCTestCaseEntry] {
    return [
      testCase(AssetEventTests.__allTests__AssetEventTests),
      testCase(CalculatorResultTests.__allTests__CalculatorResultTests),
      testCase(CalculatorTests.__allTests__CalculatorTests),
      testCase(DefaultParserTests.__allTests__DefaultParserTests),
      testCase(DescriptionTests.__allTests__DescriptionTests),
      testCase(DisposalMatchTests.__allTests__DisposalMatchTests),
      testCase(ExamplesTests.__allTests__ExamplesTests),
      testCase(MatchingProcessorTests.__allTests__MatchingProcessorTests),
      testCase(Section104HoldingTests.__allTests__Section104HoldingTests),
      testCase(TaxYearTests.__allTests__TaxYearTests),
      testCase(TransactionTests.__allTests__TransactionTests),
      testCase(TransactionToMatchTests.__allTests__TransactionToMatchTests)
    ]
  }
#endif
