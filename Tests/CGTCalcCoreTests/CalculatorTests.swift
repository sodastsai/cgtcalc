//
//  CalculatorTests.swift
//  CGTCalcCoreTests
//
//  Created by Matt Galloway on 09/06/2020.
//

import XCTest
@testable import CGTCalcCore

class CalculatorTests: XCTestCase {

  let logger = StubLogger()

  func testSamples() throws {
    SampleData.samples.forEach { sample in
      do {
        let calculator = try Calculator(transactions: sample.transactions, logger: self.logger)
        let result = try calculator.process()
        XCTAssertEqual(result.taxYearSummaries.count, sample.gains.count)
        result.taxYearSummaries.forEach { taxYearSummary in
          guard let gain = sample.gains[taxYearSummary.taxYear] else {
            XCTFail("Unexpected tax year found")
            return
          }
          XCTAssertEqual(gain, taxYearSummary.gain)
        }
      } catch {
        XCTFail("Failed to calculate \(sample.name): \(error)")
      }
    }
  }

  func testDateBefore20080406Throws() throws {
    let transaction = ModelCreation.transaction(1, .Buy, "05/04/2008", "Foo", "1", "1", "0")
    let calculator = try Calculator(transactions: [transaction], logger: self.logger)
    XCTAssertThrowsError(try calculator.process())
  }

}
