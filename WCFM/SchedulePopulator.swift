//
//  SchedulePopulator.swift
//  WCFM
//
//  Created by Matt Newman on 11/21/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation

/**
 
 */
public class SchedulePopulator {
    
    public static func loadSchedule() {
        let crawler = WCFMWebCrawler()
        let _ = crawler.updateInfo()
        if let data : Data = UserDefaults.standard.object(forKey: "WCFMSchedule") as? Data,
            let items = try? JSONDecoder().decode([RadioShow].self, from: data) {
            populateSchedule(radioShows: items)
        }
    }
    
    private static func populateSchedule(radioShows: [RadioShow]) {
        Schedule.instance.clear()
        for show in radioShows {
            Schedule.instance.addRadioShow(radioShow: show)
        }
    }
    
    public static func updateSubscriptions() {
        let radioShowTitles : [String] = UserDefaults.standard.array(forKey: Parser.titleKey) as? [String] ?? [String]()
        let subscribedTitles = Subscriptions.get()
        for subscription in subscribedTitles {
            if !radioShowTitles.contains(subscription) {
                Subscriptions.remove(title: subscription)
            }
        }
    }
    
}
