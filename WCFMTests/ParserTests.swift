//
//  ParserTests.swift
//  WCFMTests
//
//  Created by Justinas Banys on 12/3/18.
//  Copyright © 2018 Matt Newman. All rights reserved.
//

import XCTest
@testable import WCFM

class ParserTests: XCTestCase {
    
    let urlsMap = ["https://sites.williams.edu/wcfm/water-signs-united/" : true,"https://sites.williams.edu/wcfm/happy-hour/" : true,"https://sites.williams.edu/wcfm/shows/songs-i-cant-play-at-home/" : false,"https://sites.williams.edu/wcfm/sad-boy-radio-show/" : false,"https://sites.williams.edu/wcfm/music-and-talk-no-one-asked-for/" : false,"https://sites.williams.edu/wcfm/the-sampler/" : false,"https://sites.williams.edu/wcfm/day-old-bagels/" : false,"https://sites.williams.edu/wcfm/the-dinosaur-revolution/" : false]
    
    func testBoardUrls() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMSchedulePage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        let showUrls = Parser.getBoardUrls(relevantSubstring: htmlPage! as String)
        XCTAssertEqual(showUrls, ["https://sites.williams.edu/wcfm/water-signs-united/","https://sites.williams.edu/wcfm/happy-hour/"])
    }
    
    func testBoardUrlsEmpty() {
        let htmlPage = "<a title=\"Songs I Can’t Play at Home\" href=\"http://sites.williams.edu/wcfm/shows/songs-i-cant-play-at-home/\">Songs I Can&#8217;t Play&nbsp;at Home</a></p>"
        let showUrls = Parser.getBoardUrls(relevantSubstring: htmlPage)
        XCTAssertEqual(showUrls, [])
    }
    
    func testShowUrls() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMSchedulePage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        let showUrls = Parser.getShowDescriptionURLs(html: htmlPage! as String)
        XCTAssertEqual(showUrls!, urlsMap)
    }
    
    func testShowUrlsInvalid() {
        let htmlPage = "https://cs.williams.edu"
        let showUrls = Parser.getShowDescriptionURLs(html: htmlPage)
        XCTAssertNil(showUrls)
    }
    
    func testTimeParser() {
        let timeString = "Monday 1:00pm - 2:00pm"
        let time = Parser.timeParser(dayTimeString: timeString)
        XCTAssertEqual(time.startTime, 13)
        XCTAssertEqual(time.endTime, 14)
        
        let timeString1 = "Sunday 1:00 pm - 2:00pm"
        let time1 = Parser.timeParser(dayTimeString: timeString1)
        XCTAssertEqual(time1.startTime, 13)
        XCTAssertEqual(time1.endTime, 14)
        
        let timeString2 = "Tuesday 5:00 AM - 6:00 AM"
        let time2 = Parser.timeParser(dayTimeString: timeString2)
        XCTAssertEqual(time2.startTime, 5)
        XCTAssertEqual(time2.endTime, 6)
        
        let timeString3 = "Tuesday 5:00AM - 6:00pm"
        let time3 = Parser.timeParser(dayTimeString: timeString3)
        XCTAssertEqual(time3.startTime, 5)
        XCTAssertEqual(time3.endTime, 18)
        
        let timeString4 = "Sundays 11:00am-noon"
        let time4 = Parser.timeParser(dayTimeString: timeString4)
        XCTAssertEqual(time4.startTime, 11)
        XCTAssertEqual(time4.endTime, 12)
        
        let timeString5 = "Mondays midnight-1:00am"
        let time5 = Parser.timeParser(dayTimeString: timeString5)
        XCTAssertEqual(time5.startTime, 0)
        XCTAssertEqual(time5.endTime, 1)
        
        let timeString6 = "Mondays 17:00-18:00"
        let time6 = Parser.timeParser(dayTimeString: timeString6)
        XCTAssertEqual(time6.startTime, 17)
        XCTAssertEqual(time6.endTime, 18)
        
        let timeString7 = "Mondays 1-2"
        let time7 = Parser.timeParser(dayTimeString: timeString7)
        XCTAssertEqual(time7.startTime, 1)
        XCTAssertEqual(time7.endTime, 1)
    }
    
    func testDayParser() {
        let dayTimeString = "Monday 1:00pm - 2:00pm"
        let day = Parser.dayParser(dayTimeString: dayTimeString)
        XCTAssertEqual(day, Day.Monday)
        
        let dayTimeString1 = "Sundays 1:00pm - 2:00pm"
        let day1 = Parser.dayParser(dayTimeString: dayTimeString1)
        XCTAssertEqual(day1, Day.Sunday)
        
        let dayTimeString2 = "1:00pm - 2:00pm"
        let day2 = Parser.dayParser(dayTimeString: dayTimeString2)
        XCTAssertNil(day2)
    }
    
    func testGetTitle() {
        let titleString = "<h1 class=\"entry-title\">Happy Hour</h1>\n<div class=\"entry-content\">"
        let title = Parser.getTitle(html: titleString)
        XCTAssertEqual(title, "Happy Hour")
        
        let titleString1 = "<h1 class=\"entry-title\"Happy Hour/h1>\n<div class=\"entry-content\">"
        let title1 = Parser.getTitle(html: titleString1)
        XCTAssertEqual(title1, "")
    }
    
    func testGetHosts() {
        let hostString = "<p>Good tunes, Good vibes, Good times</p>\n<p>Host: First Middle Last</p>"
        let host = Parser.getHosts(html: hostString)
        XCTAssertEqual(host, "First Middle Last")
        
        let hostString1 = "<p>Good tunes, Good vibes, Good times</p>\n<p>First Middle Last</p>"
        let host1 = Parser.getHosts(html: hostString1)
        XCTAssertEqual(host1, "")
    }
    
    func testGetDayTimeImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescription", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        let dayTime = Parser.getDayTime(html: htmlPage!)
        XCTAssertEqual(dayTime, "Sunday 3:00PM &#8211; 4:00PM")
        
        let htmlPage1 = "Sunday3:00pm"
        let dayTime1 = Parser.getDayTime(html: htmlPage1)
        XCTAssertEqual(dayTime1, "")
        
        let bundle2 = Bundle(for: type(of: self))
        let filepath2 = bundle2.path(forResource: "WCFMShowDescriptionImage", ofType: nil)
        XCTAssertNotNil(filepath2)
        let htmlPage2 = try? String(contentsOfFile: filepath2!, encoding: String.Encoding.utf8)
        let dayTime2 = Parser.getDayTime(html: htmlPage2!)
        XCTAssertEqual(dayTime2, "Tuesday 9:00PM&nbsp;&#8211; 10:00PM")
    }
    
    func testGetDayTimeNoImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionNoImage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let dayTime = Parser.getDayTime(html: htmlPage!)
        XCTAssertEqual(dayTime, "Sunday 3:00PM &#8211; 4:00PM")
        
        let bundle1 = Bundle(for: type(of: self))
        let filepath1 = bundle1.path(forResource: "WCFMShowDescriptionTest", ofType: nil)
        XCTAssertNotNil(filepath1)
        let htmlPage1 = try? String(contentsOfFile: filepath1!, encoding: String.Encoding.utf8)
        
        let dayTime1 = Parser.getDayTime(html: htmlPage1!)
        XCTAssertEqual(dayTime1, "Friday 11:00PM &#8211;&nbsp;midnight")
    }
    
    func testGetDayTimeMultiLine() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionMultiLine", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let dayTime = Parser.getDayTime(html: htmlPage!)
        XCTAssertEqual(dayTime, "Saturday 7:00PM &#8211; 8:00PM")
    }
    
    func testGetGenreImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescription", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        let genre = Parser.getGenre(html: htmlPage!)
        XCTAssertEqual(genre, "Hip Hop/Rap, Pop")
        
        let htmlPage1 = "Sunday3:00pm"
        let genre1 = Parser.getGenre(html: htmlPage1)
        XCTAssertEqual(genre1, "")
        
        let bundle2 = Bundle(for: type(of: self))
        let filepath2 = bundle2.path(forResource: "WCFMShowDescriptionImage", ofType: nil)
        XCTAssertNotNil(filepath2)
        let htmlPage2 = try? String(contentsOfFile: filepath2!, encoding: String.Encoding.utf8)
        let genre2 = Parser.getGenre(html: htmlPage2!)
        XCTAssertEqual(genre2, "Alternative/Indie, Mild")
    }
    
    func testGetGenreNoImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionNoImage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let genre = Parser.getGenre(html: htmlPage!)
        XCTAssertEqual(genre, "Hip Hop/Rap, Pop")
        
        let bundle1 = Bundle(for: type(of: self))
        let filepath1 = bundle1.path(forResource: "WCFMShowDescriptionTest", ofType: nil)
        XCTAssertNotNil(filepath1)
        let htmlPage1 = try? String(contentsOfFile: filepath1!, encoding: String.Encoding.utf8)
        
        let genre1 = Parser.getGenre(html: htmlPage1!)
        XCTAssertEqual(genre1, "Hip Hop/Rap, Jazz, R&B/Soul")
    }
    
    func testGetGenreMultiLine() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionMultiLine", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let genre = Parser.getGenre(html: htmlPage!)
        XCTAssertEqual(genre, "Pop, Country, Talk Show")
    }
    
    func testGetDescriptionImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescription", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        let description = Parser.getDescription(html: htmlPage!)
        XCTAssertEqual(description, "Welcome to the Dinosaur Revolution")
        
        let htmlPage1 = "Sunday3:00pm"
        let description1 = Parser.getDescription(html: htmlPage1)
        XCTAssertEqual(description1, "")
        
        let bundle2 = Bundle(for: type(of: self))
        let filepath2 = bundle2.path(forResource: "WCFMShowDescriptionImage", ofType: nil)
        XCTAssertNotNil(filepath2)
        let htmlPage2 = try? String(contentsOfFile: filepath2!, encoding: String.Encoding.utf8)
        let description2 = Parser.getDescription(html: htmlPage2!)
        XCTAssertEqual(description2, "Three guys espousing their political beliefs. Hot takes with hotter hosts. We like music and know how to use Google. The rest is pure luck.")
    }
    
    func testGetDescriptionNoImage() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionNoImage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let description = Parser.getDescription(html: htmlPage!)
        XCTAssertEqual(description, "Welcome to the Dinosaur Revolution")
        
        let bundle1 = Bundle(for: type(of: self))
        let filepath1 = bundle1.path(forResource: "WCFMShowDescriptionTest", ofType: nil)
        XCTAssertNotNil(filepath1)
        let htmlPage1 = try? String(contentsOfFile: filepath1!, encoding: String.Encoding.utf8)
        
        let description1 = Parser.getDescription(html: htmlPage1!)
        XCTAssertEqual(description1, "You’re now rocking with the world’s greatest. Not always your standard radio fare, but always a mood setter.")
    }
    
    func testGetDescriptionMultiLine() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescriptionMultiLine", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let description = Parser.getDescription(html: htmlPage!)
        let multiline = "Welcome to our country music / talk show…We bring the all-time-best country tunes to you (though good music in other genres are not off the table). Periodically, we invite people over to the studio to hang out and have a good time.\n\nCountry music is a way of life for us. Rowdy Saturday night? We have Toby Keith in the house. Spring Break? Luke Bryan has got you covered. Feeling in love? Listen to some old T-Swift. Whether you are a country fan, have only heard Wagon Wheel, or would never listen to country on your free will- give us a chance. Tune in to our show- we promise you will NOT regret it. Remember always- you’ve got friends in low places!"
        
        XCTAssertEqual(description.description, multiline)
    }
    
    func testGetImageUrl() {
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "WCFMShowDescription", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage = try? String(contentsOfFile: filepath!, encoding: String.Encoding.utf8)
        
        let imageUrl = Parser.getImageUrl(html: htmlPage!)
        XCTAssertEqual(imageUrl, "https://sites.williams.edu/wcfm/files/2018/09/Sick-Sad-World-poster-707x1024.jpg")
        
        let filepath1 = bundle.path(forResource: "WCFMShowDescriptionNoImage", ofType: nil)
        XCTAssertNotNil(filepath)
        let htmlPage1 = try? String(contentsOfFile: filepath1!, encoding: String.Encoding.utf8)
        
        let imageUrl1 = Parser.getImageUrl(html: htmlPage1!)
        XCTAssertNil(imageUrl1)
        
        let bundle2 = Bundle(for: type(of: self))
        let filepath2 = bundle2.path(forResource: "WCFMShowDescriptionImage", ofType: nil)
        XCTAssertNotNil(filepath2)
        let htmlPage2 = try? String(contentsOfFile: filepath2!, encoding: String.Encoding.utf8)
        
        let imageUrl2 = Parser.getImageUrl(html: htmlPage2!)
        XCTAssertEqual(imageUrl2, "https://sites.williams.edu/wcfm/files/2018/09/IMG_0248-1-300x300.jpg")
    }
}
