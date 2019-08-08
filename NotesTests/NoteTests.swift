//
//  NoteTests.swift
//  NotesTests
//
//  Created by Анна Коптева on 27/06/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import XCTest
@testable import Notes

class NoteTests: XCTestCase {
    
    func getJSONfromNote() {
        let note = Note(title: "Title", content: "Content", importantce: Priority.ordinary, selfDestructDate: nil)
        let json = note.json
        let jsonDict:[String : Any] = ["Title": "Title", "Content": "Content"]
        XCTAssertTrue(json.isEqualToDictionary(jsonDict))
        //XCTAssertEqual("", "Title")
    }
}
