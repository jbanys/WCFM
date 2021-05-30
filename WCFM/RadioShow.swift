//
//  RadioShow.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation
import UIKit

/**
 An ADT for a radio show. Each radio show has a title,
 hosts, day, start time, end time, description, genres,
 board, and optional image url.
 */
public struct RadioShow : Codable, Equatable {
   
    /**
     Abstract Function: AF(self) = Properties are as
     expeceted.
     
     Rep Invariant:
        1. 0 <= startTime < 24 &&  0 <= endTime < 24
     */
    
    /// determines whether or not to run checkRep()
    private let debug : Bool = true
    
    // MARK: - Properties
    
    /// title of the radio show
    public let title : String
    
    /// host(s) of the radio show
    public let hosts : String
    
    /// day of the week of the radio show
    public let day : Day
    
    /// start time of the radio show (in 24-hour time, EST)
    public let startTime : Int
    
    /// end time of the radio show (in 24-hour time, EST)
    public let endTime : Int
    
    /// description of the radio show
    public let description : String
    
    /// genre(s) of the radio show
    public let genres: String
    
    /// whether or not the radio show hosts are board members
    public let board : Bool
    
    /// cover art for the radio show
    public let imageURL : URL?
    
    // MARK: - Initializers
    
    /**
     Creates a new RadioShow
     */
    public init(title: String, hosts: String, day: Day, startTime: Int, endTime: Int, description: String, genres: String, board: Bool, imageURL : URL? = nil) {
        self.title = title
        self.hosts = hosts
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.genres = genres
        self.board = board
        self.imageURL = imageURL
        checkRep()
    }
    
    // MARK: - Computed Properties
    
    /**
     Returns a String representation of the time slot of
     the RadioShow (ex: 8:00 - 9:00 PM)
     */
    public var timeDescription : String {
        checkRep()
        if startTime < 12 && endTime < 12 {
            return "\(startTime == 0 ? 12 : startTime):00 - \(endTime == 0 ? 12 : endTime):00 AM"
        } else if startTime < 12 && endTime >= 12 {
            let newEndTime = endTime == 12 ? 12 : endTime % 12
            return "\(startTime == 0 ? 12 : startTime):00 AM - \(newEndTime):00 PM"
        } else if startTime >= 12 && endTime < 12 {
            let newStartTime = startTime == 12 ? 12 : startTime % 12
            return "\(newStartTime):00 PM - \(endTime == 0 ? 12 : endTime):00 AM"
        } else {
            let newStartTime = startTime == 12 ? 12 : startTime % 12
            let newEndTime = endTime == 12 ? 12 : endTime % 12
            return "\(newStartTime):00 - \(newEndTime):00 PM"
        }
    }
    
    /**
     Returns a String representation of the time slot
     of the RadioShow, including the day of the week
     (ex: Tuesday 8:00 - 9:00 PM)
     */
    public var dayTimeDescription : String {
        checkRep()
        return "\(day.string) \(timeDescription)"
    }
    
    // MARK: - Methods
    
    /**
     Returns whether or not lhs comes before rhs
     during the week
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter lhs: the first RadioShow
     - parameter rhs: the seconds RadioShow
     
     - returns: true if lhs is earlier than rhs
     */
    public static func <(lhs: RadioShow, rhs: RadioShow) -> Bool {
        if lhs.day.rawValue == rhs.day.rawValue {
            // same day
            return lhs.startTime < rhs.startTime
        } else {
           // different day
            return lhs.day.rawValue < rhs.day.rawValue
        }
    }
    
    // MARK: - Check Rep
    
    private func checkRep() {
        if debug {
            // 1. 0 <= startTime < 24 &&  0 <= endTime < 24
            assert(0 <= startTime && startTime < 24 && 0 <= endTime && endTime < 24)
        }
    }
}

// MARK: -

/**
 Enum for the days of the week
 */
public enum Day : Int, CaseIterable, Codable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var string: String {
        return "\(self)"
    }
    
    /**
     Returns the Day that corresponds to the string
     representation of a day, or nil if no Day
     with that name exists
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter named: the string representation of the day
     of the week
     
     - returns: the Day that matches the given string
     representation of the day, or nil otherwise
     */
    public static func getDay(named day: String) -> Day? {
        for i in 0..<Day.allCases.count {
            if Day(rawValue: i)?.string == day {
                return Day(rawValue: i)!
            }
        }
        return nil
    }
    
    /**
     Returns the Day that corresponds to the given
     index (0 = Sunday, 1 = Monday, etc.), or nil if no
     Day with that value exists
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter numbered: the number of the day of the week
     
     - returns: the Day that corresponds to the given
     number, or nil otherwise
     */
    public static func getDay(numbered index: Int) -> Day? {
        if let day = Day(rawValue: index) {
            return day
        } else {
            return nil
        }
    }
}

