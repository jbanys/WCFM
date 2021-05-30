//
//  WCFMWebCrawler.swift
//  WCFM
//
//  Created by Justinas Banys on 11/28/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation

/**
 This class crawls the WCFM website and fetches HTML pages of show
 schedule and descriptions. It also refreshes the data when changes to
 it occur on the website.
 */
public class WCFMWebCrawler {
    
    /// An set that stores urls of show description pages
    private var descriptionURLs : Set<String>
    
    /// User Defaults key for show description urls
    private static let urlKey = "WCFMShows"
    
    /// Creates a new WCFM website crawler
    public init() {
        descriptionURLs = Set<String>()
        // Optional lines for testing purposes
        // Subscriptions.clear()
        // UserDefaults.standard.set(nil, forKey: WCFMWebCrawler.urlKey)
        if let urls = UserDefaults.standard.array(forKey: WCFMWebCrawler.urlKey) as? [String] {
            for url in urls {
                descriptionURLs.insert(url)
            }
        }
    }
    
    /**
     Crawls the WCFM website and updates UserDefaults with new show
     descriptions if neccessary.
     
     **Requires**: none
     
     **Modifies**: self
     
     **Effects**: descriptionURLs
     
     */
    public func updateInfo() -> Bool {
        if let scheduleHTML = fetchSchedule() {
            if let urls = Parser.getShowDescriptionURLs(html: scheduleHTML) {
                if checkRefresh(currentURLs: Set<String>(urls.keys)) {
                    let showDescriptions = fetchShowDescriptions(urlList: Array(urls.keys))
                    Parser.parseShowDescriptions(descriptionList: showDescriptions, board: Array(urls.values))
                    UserDefaults.standard.set(Array(urls.keys), forKey: WCFMWebCrawler.urlKey)
                    return true
                }
            }
        }
        
        sleep(1)
        return false
    }
    
    public func updateInfoBackground() -> Bool {
        if let scheduleHTML = fetchSchedule() {
            if let urls = Parser.getShowDescriptionURLs(html: scheduleHTML) {
                let showDescriptions = fetchShowDescriptions(urlList: Array(urls.keys))
                Parser.parseShowDescriptions(descriptionList: showDescriptions, board: Array(urls.values))
                UserDefaults.standard.set(Array(urls.keys), forKey: WCFMWebCrawler.urlKey)
                return true
            }
        }
        
        return false
    }
    
    // MARK: - Private Implementations
    
    /**
     Returns the HTML page of the WCFM schedule website, and nil if
     it cannot be accessed.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - returns: the schedule HTML page as String, nil otherwise
     */
    private func fetchSchedule() -> String? {
        let URLString = "https://sites.williams.edu/wcfm/schedule/"
        if let content = fetchContentFromURL(URLString: URLString) {
            return content
        }
        
        return nil
    }
    
    /**
     Returns contents of an HTML page given its url string or
     nil if the website cannot be accessed or its contents cannot
     be retreived.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter URLString: the url String of a website
     
     - returns: the HTML page as String for the provided URL, nil otherwise
     */
    private func fetchContentFromURL(URLString: String) -> String? {
        if let url = URL(string: URLString), let HTMLString = try? String(contentsOf: url) {
            return HTMLString
        }
        
        return nil
    }
    
    /**
     Returns a list of HTML pages that contain descriptions of
     the WCFM radio shows.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter urlList: a list of URLs that lead to show description
     web pages
     
     - returns: a list of HTML pages as String for given urls
     */
    private func fetchShowDescriptions(urlList: [String]) -> [String] {
        var descriptionList = [String]()
        for url in urlList {
            if let content = fetchContentFromURL(URLString: url) {   
                descriptionList.append(content)
            }
        }
        
        return descriptionList
    }
    
    /**
     Checks whether the crawler needs to be activated and crawl the
     WCFM website.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter currentURLs: a list of URLs that lead to show description
     web pages.
     
     - returns: true if the list of urls currently on the website is not
     the same as the one from the previous crawl, false otherwise
     */
    private func checkRefresh(currentURLs: Set<String>) -> Bool {
        return currentURLs != descriptionURLs
    }
}
