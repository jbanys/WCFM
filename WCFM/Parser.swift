//
//  Parser.swift
//  WCFM
//
//  Created by Matt Newman on 11/11/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import Foundation

/**
 Class that contains static methods required to parse html pages and strings
 in order to create RadioShow objects. This class also saves show titles and
 extracted radio shows to User Defaults.
 */
public class Parser {
    
    /// User Defaults key for show schedule description json
    public static let scheduleKey = "WCFMSchedule"
    
    /// User Defaults key for show titles
    public static let titleKey = "WCFMShowTitles"
    
    /**
     Returns urls found on the WCFM Schedule website and corresponding
     booleans indicating whether each url is associated with a show hosted
     by a board memeber.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: the html page of WCFM Schedule.
     
     - returns: a map between show urls and bools indicating whether the show
     is hosted by a board member. It returns nil if no shows are found.
     */
    static func getShowDescriptionURLs(html: String) -> [String:Bool]? {
        let startString = "<h3 id=\"monday\">Monday</h3>"
        let endString = "<p><em>Looking for the subrequest form?"
        if let startIndex = html.range(of: startString), let endIndex = html.range(of: endString) {
            let relevantSubstring = String(html[startIndex.upperBound..<endIndex.lowerBound])
            let boardUrls = getBoardUrls(relevantSubstring: relevantSubstring)
            
            let urlFormat = "(http|https)://sites.williams.edu/wcfm/[a-z0-9-:/]+"
            let regex = try? NSRegularExpression(pattern: urlFormat, options: [])
            let urls = regex?.matches(in: relevantSubstring, options: [], range: NSRange(relevantSubstring.startIndex..., in: relevantSubstring))
            var urlList = [String:Bool]()
            if let urls = urls {
                for url in urls {
                    if let range = Range(url.range, in: relevantSubstring) {
                        var unsafeUrl = String(relevantSubstring[range])
                        if !unsafeUrl.contains("https") {
                            unsafeUrl.insert("s", at: String.Index(encodedOffset: 4))
                        }
                        
                        urlList[unsafeUrl] = boardUrls.contains(unsafeUrl)
                    }
                }
            }
            
            return urlList
        }
        
        return nil
    }
    
    /**
     Returns urls found on the WCFM Schedule website that are associated with
     radio shows hosted by board memebers.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter relevantSubstring: the condensed html page of WCFM Schedule.
     
     - returns: a list of urls associated with shows that are hosted by board members.
     */
    static func getBoardUrls(relevantSubstring: String) -> [String] {
        let boardFormat = "(http|https)://sites.williams.edu/wcfm/[a-z0-9-:/]+(.*)(WCFM Board)"
        let regexBoard = try? NSRegularExpression(pattern: boardFormat, options: [])
        let urlsAndBoard = regexBoard?.matches(in: relevantSubstring, options: [], range: NSRange(relevantSubstring.startIndex..., in: relevantSubstring))
        var boardUrls = [String]()
        if let urlsAndBoard = urlsAndBoard {
            for url in urlsAndBoard {
                if let range = Range(url.range, in: relevantSubstring) {
                    var urlBoard = String(relevantSubstring[range])
                    if !urlBoard.contains("https") {
                        urlBoard.insert("s", at: String.Index(encodedOffset: 4))
                    }
                    
                    if let endIndex = urlBoard.range(of: "\">") {
                        urlBoard = String(urlBoard[..<endIndex.lowerBound])
                        boardUrls.append(urlBoard)
                    }
                }
            }
        }
        
        return boardUrls
    }
    
    /**
     Main parsing method that calls different parser methods and creates
     a list of RadioShow objects, where each represents a single radio show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter descriptionList: A list of html pages of show descriptions
     - parameter board: A list of booleans indicating whether a show at corresponding index
     in descriptionList is hosted by a board member.
     */
    static func parseShowDescriptions(descriptionList: [String], board: [Bool]) {
        assert(descriptionList.count == board.count)
        let startString = "<div id=\"content-container\">"
        let endString = "<div id=\"comments\">"
        var shows = [RadioShow]()
        var showTitles = [String]()
        for index in 0..<descriptionList.count {
            let description = descriptionList[index]
            if let startIndex = description.range(of: startString), let endIndex = description.range(of: endString) {
                let relevantSubstring = String(description[startIndex.upperBound..<endIndex.lowerBound])
                let title = getTitle(html: relevantSubstring)
                showTitles.append(title)
                let hosts = getHosts(html: relevantSubstring)
                let dayTime = getDayTime(html: relevantSubstring)
                let description = getDescription(html: relevantSubstring)
                let genre = getGenre(html: relevantSubstring)
                let day = dayParser(dayTimeString: dayTime)
                let (startTime, endTime) = timeParser(dayTimeString: dayTime)
                if let imageString = getImageUrl(html: relevantSubstring) {
                    let imageURL = URL(string: imageString)
                    let show = RadioShow(title: title, hosts: hosts, day: day ?? Day(rawValue: 1)!, startTime: startTime, endTime: endTime, description: description, genres: genre, board: board[index], imageURL: imageURL)
                    shows.append(show)
                } else {
                    let show = RadioShow(title: title, hosts: hosts, day: day ?? Day(rawValue: 1)!, startTime: startTime, endTime: endTime, description: description, genres: genre, board: board[index])
                    shows.append(show)
                }
            }
        }
        
        saveShowTitles(titles: showTitles)
        encodeToJSON(shows: shows)
    }
    
    /**
     Saves titles of radio shows to User Defaults.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: User Defaults
     
     - parameter titles: A list of radio show titles
     */
    private static func saveShowTitles(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: Parser.titleKey)
    }
    
    /**
     Encodes a list of RadioShow objects to JSON and saves it to User Defaults.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: User Defaults
     
     - parameter shows: A list of RadioShow objects to be saved.
     */
    private static func encodeToJSON(shows: [RadioShow]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = JSONEncoder.OutputFormatting.prettyPrinted
        if let encodedData = try? encoder.encode(shows) {
            UserDefaults.standard.set(encodedData, forKey: Parser.scheduleKey)
        }
    }
    
    /**
     Parses an HTML string including information on the day and time of a show;
     returns the start and end time of a show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter dayTimeString: a condenced html string that contains information on
     the day and time of a show.
     
     - returns: a 2-tuple, where the first element is the start time of the show and the
     second element is the end time of the show.
     */
    static func timeParser(dayTimeString: String) -> (startTime: Int, endTime: Int) {
        let timePattern = "([0-9]{1,2}:[0-9]{2}\\s*((AM|PM)|(am|pm))*|midnight|noon)"
        let regex = try? NSRegularExpression(pattern: timePattern, options: [])
        let matches = regex?.matches(in: dayTimeString, options: [], range: NSRange(dayTimeString.startIndex..., in: dayTimeString))
        var arr = [Int]()
        if let matches = matches {
            for match in matches {
                if let range = Range(match.range, in: dayTimeString) {
                    let timeString = String(dayTimeString[range])
                    if let index = timeString.range(of: ":") {
                        let hourString = String(timeString[..<index.lowerBound])
                        if timeString.lowercased().contains("am") {
                            arr.append(Int(hourString)!)
                        } else if timeString.lowercased().contains("12:00 pm")
                            || timeString.lowercased().contains("12:00pm") {
                            arr.append(12)
                        } else if (Int(hourString)! > 11) {
                            arr.append(Int(hourString)!)
                        } else {
                            arr.append(Int(hourString)! + 12)
                        }
                    } else if timeString.contains("midnight") {
                        arr.append(0)
                    } else if timeString.contains("noon") {
                        arr.append(12)
                    }
                }
            }
        }
        
        if (arr.count != 2) {
            print("Invalid regex in Time Parser")
            return (1,1)
        }
        return (arr[0], arr[1])
    }
    
    /**
     Parses an HTML string including information on the day and time of a show;
     returns the weekday, on which the show occurs.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter dayTimeString: a condenced html string that contains information on
     the day and time of a show.
     
     - returns: a weekday associated with a show. Otherwise, it returns nil.
     */
    static func dayParser(dayTimeString: String) -> Day? {
        if let endIndex = dayTimeString.range(of: " ") {
            var dayString = String(dayTimeString[..<endIndex.lowerBound])
            if dayString.suffix(1) == "s" {
                dayString = String(dayString.dropLast())
            }
            
            return Day.getDay(named: dayString)
        }
        
        return nil
    }
    
    /**
     Parses an HTML page of a show description and returns the title of the show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: the title of the radio show, whose description is given. Empty String is
     returned if the title is not found.
     */
    static func getTitle(html: String) -> String {
        let titlePattern = "entry-title\">(.*)<"
        let regex = try? NSRegularExpression(pattern: titlePattern, options: [])
        let matches = regex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        if let matches = matches, let title = matches.first {
            if let range = Range(title.range, in: html) {
                let title = String(html[range])
                if let startIndex = title.range(of: ">"), let endIndex = title.range(of: "<") {
                    return String(title[startIndex.upperBound..<endIndex.lowerBound]).htmlDecoded
                }
            }
        }
        
        return ""
    }
    
    /**
     Parses an HTML page of a show description and returns the hosts of the show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: the hosts of the radio show, whose description page is given. Empty String is
     returned if the host information is not found.
     */
    static func getHosts(html: String) -> String {
        let hostPattern = "Hosts?:(.*)<"
        let regex = try? NSRegularExpression(pattern: hostPattern, options: [])
        let matches = regex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        if let matches = matches, let hosts = matches.first {
            if let range = Range(hosts.range, in: html) {
                let hosts = String(html[range])
                if let startIndex = hosts.range(of: ":"), let endIndex = hosts.range(of: "<") {
                    return String(hosts[startIndex.upperBound..<endIndex.lowerBound]).htmlDecoded
                }
            }
        }
        
        return ""
    }
    
    /**
     Parses an HTML page of a show description and returns a String that contains
     day and time of the associated radio show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: a String that contains a day and time of the radio show. Empty String is
     returned if day and time are not found.
     */
    static func getDayTime(html: String) -> String {
        let dayTimePattern = "[A-Za-z]{6,10} ([0-9]{1,2}:[0-9]{2}\\s*((AM|PM)|(am|pm))*|midnight|noon)(.*)([0-9]{1,2}:[0-9]{2}\\s*((AM|PM)|(am|pm))|midnight|noon)"
        let regexTime = try? NSRegularExpression(pattern: dayTimePattern, options: [])
        if let dateTime = regexTime?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html)), let time = dateTime.first {
            if let range = Range(time.range, in: html) {
                return String(html[range])
            }
        }
        
        return ""
    }
    
    /**
     Parses an HTML page of a show description and returns genres associated with the show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: Genres associated with the show as a String, where each genre is separated by commas.
     Empty String is returned if genres are not found.
     */
    static func getGenre(html: String) -> String {
        let regexGenre = try? NSRegularExpression(pattern: "<p (.*)>(.*)</p>", options: [])
        let genreMatch = regexGenre?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        if let genreMatch = genreMatch {
            for genre in genreMatch {
                if let range = Range(genre.range, in: html) {
                    let toString = String(html[range])
                    if !toString.contains("http") {
                        return String(toString.htmlDecoded.dropLast())
                    }
                }
            }
        }
        
        return ""
    }
    
    /**
     Parses an HTML page of a show description and returns the description of the show.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: the description of the radio show. Empty String is
     returned if the description is not found.
     */
    static func getDescription(html: String) -> String {
        var paragraphs = [String]()
        let regex = try? NSRegularExpression(pattern: "<p>(.*)</p>", options: [])
        let matches = regex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        if let matches = matches {
            for match in matches {
                if let range = Range(match.range, in: html) {
                    let toString = String(html[range])
                    if toString.range(of: "Host") == nil && toString.range(of: "http") == nil {
                        paragraphs.append(String(toString.htmlDecoded.dropLast()))
                    }
                }
            }
            
            return paragraphs.joined(separator: "\n\n")
        }
        
        return ""
    }
    
    /**
     Parses an HTML page of a show description, finds a url of an image associated with the
     radio show and returns it as String.
     
     **Requires**: none
     
     **Modifies**: none
     
     **Effects**: none
     
     - parameter html: html page of a show description as String.
     
     - returns: the url of an image associated with the radio show. Nil is returned if no image
     is found.
     */
    public static func getImageUrl(html: String) -> String? {
        let regex = try? NSRegularExpression(pattern: "<img class=(.*)https://sites.williams.edu/wcfm/files/(.*)\" alt", options: [])
        let matches = regex?.matches(in: html, options: [], range: NSRange(html.startIndex..., in: html))
        if let matches = matches, let imageUrl = matches.first {
            if let range = Range(imageUrl.range, in: html) {
                let url = String(html[range])
                if let startIndex = url.range(of: "https:"), let endIndex = url.range(of: "\" alt") {
                    return String(url[startIndex.lowerBound..<endIndex.lowerBound])
                }
            }
        }
        
        return nil
    }
}


/**
 An extension of String class that allows to decode a String containing HTML code to a regular string.
 Source: https://stackoverflow.com/questions/25607247/how-do-i-decode-html-entities-in-swift
 */
extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
