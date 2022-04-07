//
//  TestApp.swift
//
//  Created by Dan Hart on 3/20/22.
//

@testable import Her
import XCTest

class TestApp: XCTestCase {
    static func appTest() {
        let app = HerApp()
        XCTAssertNotNil(app)
    }
}
