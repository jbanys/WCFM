//
//  ScheduleTests.swift
//  WCFMTests
//
//  Created by Matt Newman on 11/14/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import XCTest
@testable import WCFM

class ScheduleTests: XCTestCase {
    
    var schedule = Schedule(newRadioShows: [
        RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true),
        RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true),
        RadioShow(title: "Show C", hosts: "Host C", day: Day.Monday, startTime: 10, endTime: 11, description: "Description C", genres: "Genres C", board: true),
        RadioShow(title: "Show D", hosts: "Host D", day: Day.Saturday, startTime: 20, endTime: 21, description: "Description D", genres: "Genres D", board: true)
    ])
    
    func testInit() {
        let emptySchedule = Schedule()
        let expected : [Day : [RadioShow]] = [Day.Sunday : [], Day.Monday : [], Day.Tuesday : [], Day.Wednesday : [], Day.Thursday : [], Day.Friday : [], Day.Saturday : []]
        XCTAssertEqual(emptySchedule.schedule, expected)
    }
    
    func testGetRadioShow() {
        XCTAssertEqual(schedule.getRadioShow(on: 1, atIndex: 0), RadioShow(title: "Show C", hosts: "Host C", day: Day.Monday, startTime: 10, endTime: 11, description: "Description C", genres: "Genres C", board: true))
        XCTAssertEqual(schedule.getRadioShow(on: 1, atIndex: 1), nil)
        XCTAssertEqual(schedule.getRadioShow(on: 3, atIndex: 0), RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        XCTAssertEqual(schedule.getRadioShow(on: 3, atIndex: 1), RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true))
        XCTAssertEqual(schedule.getRadioShow(on: 3, atIndex: 2), nil)
        XCTAssertEqual(schedule.getRadioShow(on: 0, atIndex: 0), nil)

        XCTAssertEqual(schedule.getRadioShow(on: 1, atTime: 10), RadioShow(title: "Show C", hosts: "Host C", day: Day.Monday, startTime: 10, endTime: 11, description: "Description C", genres: "Genres C", board: true))
        XCTAssertEqual(schedule.getRadioShow(on: 3, atTime: 5), RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        XCTAssertEqual(schedule.getRadioShow(on: 2, atTime: 5), nil)
        XCTAssertEqual(schedule.getRadioShow(on: 3, atTime: 12), nil)
        
        XCTAssertEqual(schedule.getRadioShow(named: "Show B"), RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        XCTAssertEqual(schedule.getRadioShow(named: "Show D"), RadioShow(title: "Show D", hosts: "Host D", day: Day.Saturday, startTime: 20, endTime: 21, description: "Description D", genres: "Genres D", board: true))
        XCTAssertEqual(schedule.getRadioShow(named: "Show E"), nil)
    }
        
    func testNumberOfShows() {
        XCTAssertEqual(schedule.numberOfShows(on: Day.Wednesday), 2)
        XCTAssertEqual(schedule.numberOfShows(on: Day.Monday), 1)
        XCTAssertEqual(schedule.numberOfShows(on: Day.Tuesday), 0)
    }
    
    func testAddRadioShow() {
        let newSchedule = schedule
        newSchedule.addRadioShow(radioShow: RadioShow(title: "Show Z", hosts: "Host Z", day: Day.Wednesday, startTime: 8, endTime: 9, description: "Description Z", genres: "Genres Z", board: true))
        let expected = Schedule(newRadioShows: [
            RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true),
            RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true),
            RadioShow(title: "Show C", hosts: "Host C", day: Day.Monday, startTime: 10, endTime: 11, description: "Description C", genres: "Genres C", board: true),
            RadioShow(title: "Show D", hosts: "Host D", day: Day.Saturday, startTime: 20, endTime: 21, description: "Description D", genres: "Genres D", board: true),
            RadioShow(title: "Show Z", hosts: "Host Z", day: Day.Wednesday, startTime: 8, endTime: 9, description: "Description Z", genres: "Genres Z", board: true)
            ])
        XCTAssertEqual(newSchedule.schedule, expected.schedule)
        XCTAssertEqual(newSchedule.getRadioShow(on: 3, atIndex: 0), RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        XCTAssertEqual(newSchedule.getRadioShow(on: 3, atIndex: 1), RadioShow(title: "Show Z", hosts: "Host Z", day: Day.Wednesday, startTime: 8, endTime: 9, description: "Description Z", genres: "Genres Z", board: true))
        XCTAssertEqual(newSchedule.getRadioShow(on: 3, atIndex: 2), RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true))
        XCTAssertEqual(newSchedule.getRadioShow(on: 3, atIndex: 3), nil)
        XCTAssertEqual(newSchedule.getRadioShow(named: "Show Z"), RadioShow(title: "Show Z", hosts: "Host Z", day: Day.Wednesday, startTime: 8, endTime: 9, description: "Description Z", genres: "Genres Z", board: true))
        XCTAssertEqual(newSchedule.numberOfShows(on: Day.Wednesday), 3)
    }
    
    func testClear() {
        schedule.clear()
        let expected : [Day : [RadioShow]] = [Day.Sunday : [], Day.Monday : [], Day.Tuesday : [], Day.Wednesday : [], Day.Thursday : [], Day.Friday : [], Day.Saturday : []]
        XCTAssertEqual(schedule.schedule, expected)
    }

    // MARK: - filter tests
    
    func testFilterShowsSingle() {
        schedule.filterShows(keyword: "Show A")
        XCTAssertEqual(schedule.numberOfCategories(), 3)
        
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Title), 1)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Host), 0)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Genre), 0)
        
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 0, atIndex: 0),  RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true))
        
        schedule.clearFiltered()
        XCTAssertEqual(schedule.numberOfCategories(), 0)
        
        schedule.filterShows(keyword: "Host B")
        XCTAssertEqual(schedule.numberOfCategories(), 3)
        
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Title), 0)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Host), 1)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Genre), 0)
        
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 1, atIndex: 0),  RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        
        schedule.filterShows(keyword: "Genres D")
        XCTAssertEqual(schedule.numberOfCategories(), 3)
        
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Title), 0)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Host), 0)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Genre), 1)
        
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 2, atIndex: 0),  RadioShow(title: "Show D", hosts: "Host D", day: Day.Saturday, startTime: 20, endTime: 21, description: "Description D", genres: "Genres D", board: true))
    }
    
    func testFilteredShowsMultiple() {
        schedule.filterShows(keyword: "Show")
        XCTAssertEqual(schedule.numberOfCategories(), 3)
        
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Title), 4)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Host), 0)
        XCTAssertEqual(schedule.numberOfShows(category: Schedule.FilterCategory.Genre), 0)
        
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 0, atIndex: 0),  RadioShow(title: "Show B", hosts: "Host B", day: Day.Wednesday, startTime: 5, endTime: 6, description: "Description B", genres: "Genres B", board: true))
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 0, atIndex: 1),  RadioShow(title: "Show C", hosts: "Host C", day: Day.Monday, startTime: 10, endTime: 11, description: "Description C", genres: "Genres C", board: true))
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 0, atIndex: 2),  RadioShow(title: "Show A", hosts: "Host A", day: Day.Wednesday, startTime: 11, endTime: 12, description: "Description A", genres: "Genres A", board: true))
        XCTAssertEqual(schedule.getFilteredRadioShow(for: 0, atIndex: 3),  RadioShow(title: "Show D", hosts: "Host D", day: Day.Saturday, startTime: 20, endTime: 21, description: "Description D", genres: "Genres D", board: true))
        
        schedule.clearFiltered()
        XCTAssertEqual(schedule.numberOfCategories(), 0)
    }
}
