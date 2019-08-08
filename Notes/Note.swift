//
//  Note.swift
//  Notes
//
//  Created by Анна Коптева on 19/06/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import Foundation
import UIKit

struct Note{
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importantce: Priority
    let selfDestructDate: Date?
    
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = UIColor(red: 0.999887, green: 1.0, blue: 0.999875, alpha: 1.0),
         importantce: Priority,
         selfDestructDate: Date?) {
        
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importantce = importantce
        self.selfDestructDate = selfDestructDate
    }
}

enum Priority: String{
    case noImportant = "неважная"
    case ordinary = "обычная"
    case important = "важная"
}
