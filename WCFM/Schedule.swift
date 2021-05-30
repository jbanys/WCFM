//
//  Schedule.swift
//  WCFM
//
//  Created by Matt Newman on 11/12/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation

/**
 An ADT for the schedule. A schedule consists of the days of the week,
 each day associated with a list of RadioShows that are on that day.
 */
public class Schedule {
    
    /**
     Abstract Function: AF(self) = Schedule = radioShows
     Rep Invariant:
        1. Schedule has 7 entries that are named the days of the week
        2. Each RadioShow associated with a Day is actually on that day
        3. All of the RadioShows are sorted within each day
        4. Each RadioShow in filteredShows must be in radioShows
    */
    
    // MARK: - Singleton
    
    // public singleton
    public static let instance = Schedule()
    
    // MARK: - Private Implementation
    
    /// mapping of Days to lists of RadioShows on that Day
    private var radioShows : [Day: [RadioShow]]
    
    /// filtered RadioShows by search term
    private var filteredShows : [FilterCategory: [RadioShow]]
    
    /// determines whether or not to run checkRep()
    private let debug : Bool = true
    
    /// indicator whether schedule search is being performed
    public var search : Bool = false
    
    // MARK: - Initializers
    
    /**
     Creates an empty Schedule (a mapping of days of
     the week to empty lists)
     */
    public init() {
        filteredShows = [:]
        radioShows = [:]
        for day in Day.allCases {
            radioShows[day] = []
        }
        checkRep()
    }
    
    /**
     Creates a Schedule based on a list of RadioShows
     (for testing purposes)
     */
    public init(newRadioShows: [RadioShow]) {
        filteredShows = [:]
        radioShows = [:]
        for day in Day.allCases {
            radioShows[day] = []
        }
        for radioShow in newRadioShows {
            addRadioShow(radioShow: radioShow)
        }
        checkRep()
    }

    // MARK: - Properties
    
    /// number of days in the Schedule
    public var numberOfDays : Int {
        checkRep()
        return radioShows.count
    }
    
    /// returns the schedule (for testing purposes)
    public var schedule : [Day: [RadioShow]] {
        checkRep()
        return radioShows
    }

    // MARK: - Methods
    
    /**
     Returns the RadioShow that is specified by a given
     Day (represented by an integer) and an index in the
     schedule, or nil if there is none
     
     **Requires**: on < self.days
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter on: represents the day of the week
     - parameter atIndex: represents which show in the given day
     
     - returns: the RadioShow found in the specified position,
     otherwise nil
     */
    public func getRadioShow(on day: Int, atIndex index: Int) -> RadioShow? {
        checkRep()
        if let array = radioShows[Day.getDay(numbered: day)!] {
            if index < array.count {
                return array[index]
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /**
     Returns the RadioShow that is specified by a given
     Day (represented by an integer) and an hour, or nil
     if there is none
     
     **Requires**: on < self.days
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter on: represents the day of the week
     - parameter atTime: the hour of the day
     
     - returns: the RadioShow at the specified time, otherwise
     nil
     */
    public func getRadioShow(on day: Int, atTime hour: Int) -> RadioShow? {
        checkRep()
        if let array = radioShows[Day.getDay(numbered: day)!] {
            for radioShow in array {
                if radioShow.startTime == hour {
                    return radioShow
                }
            }
            return nil
        } else {
            return nil
        }
    }
    
    /**
     Returns the RadioShow with the given name, or nil if
     no show with that name exists
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter named: the title of the RadioShow
     
     - returns: the RadioShow with the given name, nil otherwise
     */
    public func getRadioShow(named title: String) -> RadioShow? {
        checkRep()
        for day in Day.allCases {
            let array = radioShows[day]!
            for radioShow in array {
                if radioShow.title == title {
                    return radioShow
                }
            }
        }
        return nil
    }
    
    /**
     Returns the number of RadioShows on a given Day
     
     **Requires**: on < self.days
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter on: the day of the week
     
     - returns: the number of RadioShows on the given Day
     */
    public func numberOfShows(on day: Day) -> Int {
        checkRep()
        return radioShows[day]?.count ?? 0
    }
    
    /**
     Adds a RadioShow to the Schedule in the correct
     position.
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Adds the given RadioShow to the
     Schedule on the correct day, in the correct
     time position
     
     - parameter radioShow: the RadioShow to be added
     */
    public func addRadioShow(radioShow: RadioShow) {
        checkRep()
        radioShows[radioShow.day]?.append(radioShow)
        radioShows[radioShow.day]?.sort(by: {$0.startTime < $1.startTime})
        checkRep()
    }
    
    /**
     Clears the Schedule to be empty (a mapping of days of
     the week to empty lists)
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Resets the Schedule and filteredSchedule to be empty
     */
    public func clear() {
        filteredShows = [:]
        radioShows = [:]
        for day in Day.allCases {
            radioShows[day] = []
        }
        checkRep()
    }
    
    /**
     Returns the current RadioShow according to the schedule and
     internal clock, or nil if there is no current show
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - returns: the current RadioShow, otherwise nil
     */
    public func getCurrentRadioShow() -> RadioShow? {
        checkRep()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let dayIndex = calendar.component(.weekday, from: date) - 1 // Calendar treats Sunday as 1, Monday as 2...
        if let radioShow = Schedule.instance.getRadioShow(on: dayIndex, atTime: hour) {
            return radioShow
        } else {
            return nil
        }
    }
    
    /**
     Returns the next RadioShow according to the schedule and
     internal clock
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - returns: the next RadioShow
     */
    public func getNextRadioShow() -> RadioShow {
        checkRep()
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date) + 1
        var dayIndex = calendar.component(.weekday, from: date) - 1 // Calendar treats Sunday as 1, Monday as 2...
        while true {
            if hour < 24 {
                if let radioShow = Schedule.instance.getRadioShow(on: dayIndex, atTime: hour) {
                    return radioShow
                } else {
                    hour += 1
                }
            } else {
                dayIndex += 1
                if dayIndex >= 7 {
                    dayIndex = dayIndex % 7
                }
                hour = 0
            }
        }
    }
    
    // MARK: - Search Filter
    
    /// Enum for different search categories
    public enum FilterCategory: Int, CaseIterable {
        case Title
        case Host
        case Genre
        
        var string: String {
            return "\(self)"
        }
    }
    
    /**
     Filters RadioShow list by keyword. Filtering is done for titles, hosts, and genres
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: changes filteredShows list
     
     - parameter keyword: filter keyword
     */
    public func filterShows(keyword: String) {
        checkRep()
        var title = radioShows.values.joined().filter { $0.title.lowercased().contains(keyword.lowercased()) }
        var host = radioShows.values.joined().filter { $0.hosts.lowercased().contains(keyword.lowercased()) }
        var genre = radioShows.values.joined().filter { $0.genres.lowercased().contains(keyword.lowercased()) }
        title.sort(by: {$0.startTime < $1.startTime})
        host.sort(by: {$0.startTime < $1.startTime})
        genre.sort(by: {$0.startTime < $1.startTime})
        filteredShows[FilterCategory.Title] = title
        filteredShows[FilterCategory.Host] = host
        filteredShows[FilterCategory.Genre] = genre
        checkRep()
    }
    
    /**
     Returns the RadioShow that is specified by a given
     FilterCategory (represented by an integer) and an index in the
     schedule, or nil if there is none
     
     **Requires**: for < self.filterCategory
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter for: represents the filter category
     - parameter atIndex: represents a show for the given category
     
     - returns: the RadioShow found in the specified position,
     otherwise nil
     */
    public func getFilteredRadioShow(for category: Int, atIndex index: Int) -> RadioShow? {
        checkRep()
        if let name = FilterCategory(rawValue: category), let array = filteredShows[name] {
            if index < array.count {
                return array[index]
            }
        }
        return nil
    }
    
    /**
     Clears the filteredSchedule to be empty (a mapping of filter categories to empty lists)
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Resets the filteredShows to be empty
     */
    public func clearFiltered() {
        filteredShows = [:]
        checkRep()
    }
    
    /**
     Returns the number of existing filtering categories
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - returns: the number of filtering categories
     */
    public func numberOfCategories() -> Int {
        checkRep()
        return filteredShows.keys.count
    }
    
    /**
     Returns the number of RadioShows for a given filter category
     
     **Requires**: category < self.filterCategory
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter category: the filterCategory used for filtering shows
     
     - returns: the number of RadioShows for the given filter category
     */
    public func numberOfShows(category: FilterCategory) -> Int {
        checkRep()
        return filteredShows[category]?.count ?? 0
    }
    
    // MARK: - Check Rep
    
    private func checkRep() {
        if debug {
            // 1. Schedule has 7 entries that are named the days of the week
            for i in 0..<7 {
                assert(radioShows[Day.getDay(numbered: i)!] != nil)
            }
            for day in Day.allCases {
                let array = radioShows[day]!
                // 2. Each RadioShow associated with a Day is actually on that day
                for radioShow in array {
                    assert(radioShow.day == day)
                }
                // 3. All of the RadioShows are sorted within each day
                assert(array.isSorted(isOrderedBefore: {$0.startTime < $1.startTime}))
            }
            // 4. Each RadioShow in filteredShows must be in radioShowsss
            let fullSchedule = radioShows.values.joined()
            let filteredSchedule = filteredShows.values.joined()
            for show in filteredSchedule {
                assert(fullSchedule.contains(show))
            }
        }
    }
}

extension Array {
    
    /**
     Returns whether or not an array is sorted
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter isOrderedBefore: a function that takes
     2 elements of an array and compares their values
     
     - returns: whether or not the array is sorted
     */
    func isSorted(isOrderedBefore: (Element, Element) -> Bool) -> Bool {
        if self.count == 0 {
            return true
        } else {
            for i in 1..<self.count {
                if !isOrderedBefore(self[i-1], self[i]) {
                    return false
                }
            }
            return true
        }
    }
}
