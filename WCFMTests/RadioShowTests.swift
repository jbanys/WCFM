//
//  RadioShowTests.swift
//  WCFMTests
//
//  Created by Matt Newman on 11/30/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import XCTest
@testable import WCFM

class RadioShowTests: XCTestCase {

    func testDayTimeDescription() {
        let showA = RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 4, endTime: 5, description: "Description A", genres: "Genres A", board: true)
        XCTAssertEqual(showA.dayTimeDescription, "Wednesday 4:00 - 5:00 AM")
        let showB = RadioShow(title: "Show B", hosts: "Host B", day: Day.Saturday, startTime: 20, endTime: 22, description: "Description B", genres: "Genres B", board: true)
        XCTAssertEqual(showB.dayTimeDescription, "Saturday 8:00 - 10:00 PM")
        let showC = RadioShow(title: "Show C", hosts: "Host C", day: Day.Tuesday, startTime: 0, endTime: 1, description: "Description C", genres: "Genres C", board: true)
        XCTAssertEqual(showC.dayTimeDescription, "Tuesday 12:00 - 1:00 AM")
        let showD = RadioShow(title: "Show D", hosts: "Host D", day: Day.Monday, startTime: 11, endTime: 12, description: "Description D", genres: "Genres D", board: true)
        XCTAssertEqual(showD.dayTimeDescription, "Monday 11:00 AM - 12:00 PM")
        let showE = RadioShow(title: "Show E", hosts: "Host E", day: Day.Monday, startTime: 12, endTime: 13, description: "Description E", genres: "Genres E", board: true)
        XCTAssertEqual(showE.dayTimeDescription, "Monday 12:00 - 1:00 PM")
        let showF = RadioShow(title: "Show F", hosts: "Host F", day: Day.Thursday, startTime: 23, endTime: 0, description: "Description F", genres: "Genres F", board: true)
        XCTAssertEqual(showF.dayTimeDescription, "Thursday 11:00 PM - 12:00 AM")
        
        XCTAssertEqual(true, showA < showB)
        XCTAssertEqual(false, showA < showC)
        XCTAssertEqual(true, showC < showF)
        XCTAssertEqual(true, showD < showE)
        XCTAssertEqual(true, showF < showB)
    }
    
}
