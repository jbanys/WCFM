//
//  Subscriptions.swift
//  WCFM
//
//  Created by Matt Newman on 11/21/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation

/**
 An ADT to store the user's subscribed radio shows. The
 abstract state is a sequence of titles of radio shows sorted
 in order of start time during the week. The subscriptions are
 stored in UserDefaults to make it persistent.
 */
public class Subscriptions {
    
    /**
     Abstract Function: AF(self) = The sequences is the
     array stored in UserDefaults with the key
     "Subscribed-RadioShows"
     
     Rep Invariant:
        1. There are no duplicate RadioShow titles in subscriptions
        2. Each subscribed RadioShow exists in the schedule
     */
    
    // MARK: - Private Implementation
    
    /// internal pointer to user defaults
    private static let defaults = UserDefaults.standard
    
    /// the key we use to store our data
    private static let key = "Subscribed-RadioShows"
    
    /// determines whether or not to run checkRep()
    private static let debug : Bool = true
    
    // MARK: - Properties
    
    /// the number of titles we are storing
    public static var count : Int {
        checkRep()
        return get().count
    }
    
    // MARK: - Methods
    
    /**
     Returns the list of subscribed RadioShow titles stored in
     UserDefaults, or an empty array if no subscriptions exist
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - returns: a list of subscribed RadioShow titles, or nil
     */
    public static func get() -> [String] {
        return defaults.array(forKey: Subscriptions.key) as? [String] ?? [String]()
    }
    
    /**
     Returns the RadioShow title at the given index in the list
     of subscriptions
     
     **Requires**: 0 <= index < self.count
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter at: the index in the list of subscriptions
     
     - returns: the RadioShow title at the given index
     */
    public static func get(at index : Int) -> String {
        assert(0 <= index && index < count)
        checkRep()
        return get()[index]
    }    
    
    /**
     Removes all subscriptions
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: none
     
     **Effects**: Subscriptions becomes empty
     */
    public static func clear() {
        defaults.removeObject(forKey: Subscriptions.key)
        checkRep()
    }
    
    /**
     Adds a new RadioShow title to the subcriptions
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Adds title to the list of subscriptions
     
     - parameter title: the title of the RadioShow to be added
     */
    public static func add(title : String) {
        checkRep()
        var terms = get()
        terms.append(title)
        // sort by time
        terms.sort(by: { Schedule.instance.getRadioShow(named: $0)! < Schedule.instance.getRadioShow(named: $1)! })
        defaults.set(terms, forKey: Subscriptions.key)
        checkRep()
    }
    
    /**
     Removes a RadioShow title from the subcriptions with a
     given title
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: Removes a  title from the list of subscriptions
     
     - parameter title: the title of the RadioShow to be removed
     */
    public static func remove(title: String) {
        let terms = get()
        if terms.contains(title) {
            deleteAtIndex(index: terms.firstIndex(of: title)!)
        }
        checkRep()
    }
    
    /**
     Removes the RadioShow title from subscriptions at a given
     index
     
     **Requires**: 0 <= index < self.count
     
     **Modifies**: self
     
     **Effects**: Removes a  title from the list of subscriptions
     
     - parameter at: the index in the list of subscriptions
     */
    public static func deleteAtIndex(index : Int) {
        assert(0 <= index && index < count)
        checkRep()
        var terms = get()
        terms.remove(at: index)
        defaults.set(terms, forKey: Subscriptions.key)
        checkRep()
    }
    
    /**
     Returns whether or not the user is subscribed to a given
     RadioShow title
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: none
     
     - parameter title: the title of the RadioShow
     
     - returns: whether or not the user is subscribed to the
     RadioShow
     */
    public static func contains(title: String) -> Bool {
        checkRep()
        let terms = get()
        if terms.contains(title) {
            return true
        } else {
            return false
        }
    }
    
    
    // MARK: - Check Rep
    
    private static func checkRep() {
        if debug {
            let terms = get()
            // 1. There are no duplicate RadioShow titles in subscriptions
            for i in 0..<terms.count {
                assert(terms.index { $0.lowercased() == terms[i].lowercased() } == i, "Duplicates in History")
            }
            // 2. Each subscribed RadioShow exists in the schedule
            for title in terms {
                assert(Schedule.instance.getRadioShow(named: title) != nil)
            }
        }
    }
}
