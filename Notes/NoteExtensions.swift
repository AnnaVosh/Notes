//
//  NoteExtensions.swift
//  Notes
//
//  Created by Анна Коптева on 22/06/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import Foundation
import UIKit
import CocoaLumberjack

extension Note{
    static func parse(json: [String: Any]) -> Note?{
        guard
            let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else{
                DDLogVerbose("Can't parse json")
                return nil
        }

        let colorJSON = json["color"] as? [String: CGFloat] ?? ["r": 0.999887, "g": 1.0, "b": 0.999875, "a": 1.0]
        let r = colorJSON["r"]!
        let g = colorJSON["g"]!
        let b = colorJSON["b"]!
        let a = colorJSON["a"]!
        let color = UIColor(red: r, green: g, blue: b, alpha: a)
        
        let importantceJSON = json["importantce"] as? String ?? "обычная"
        let importantce =  Priority(rawValue: importantceJSON) ?? Priority.ordinary
        
        let selfDestructDateJSON = json["selfDestructDate"] as? Double ?? nil
        let selfDestructDate = selfDestructDateJSON != nil ? Date(timeIntervalSince1970: selfDestructDateJSON!) : nil
        
        DDLogDebug("Note was parsed. UID = " + uid)
        return Note(uid: uid, title: title, content: content, color: color, importantce: importantce, selfDestructDate: selfDestructDate)
    }
    
    var json: [String: Any] {
        get{
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            var jsonDict: [String: Any] = [
                "uid": uid,
                "title": title,
                "content": content
            ]
            
            if selfDestructDate != nil{
                jsonDict["selfDestructDate"] = selfDestructDate!.timeIntervalSince1970
            }else{
                jsonDict["selfDestructDate"] = nil
            }
            
            if color != UIColor(red: 0.999887, green: 1.0, blue: 0.999875, alpha: 1.0) {
                jsonDict["color"] = [
                    "r": red,
                    "g": green,
                    "b": blue,
                    "a": alpha
                ]
            }
            
            if importantce != Priority.ordinary {
                jsonDict["importantce"] = importantce.rawValue
            }
            
            return jsonDict
        }
    }
}
