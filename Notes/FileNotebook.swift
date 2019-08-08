//
//  FileNotebook.swift
//  Notes
//
//  Created by Анна Коптева on 23/06/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook{
    
    private(set) var notes: [Note] = []
    
    init(){
    }
    
    public func add(_ note: Note){
        if let index = notes.firstIndex(where: {$0.uid == note.uid}) {
            notes[index] = note
            DDLogInfo("Note was updated. UID = " + note.uid)
        } else {
            notes.append(note)
            DDLogInfo("Note was added to Notes. UID = " + note.uid)
        }
    }
    
    public func remove(with uid: String){
        notes.removeAll{$0.uid == uid}
        DDLogInfo("Note was remowed. UID = " + uid)
    }
    
    public func saveToFile(){
        let basePath = try? FileManager.default.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
        let path : URL = basePath!.appendingPathComponent("notesData.bin", isDirectory: false)
        
        var json : [Any] = []
        for note in notes {
            json.append(note.json)
        }
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        if FileManager.default.fileExists(atPath: path.path) {
            do {
                try data.write(to: path)
            } catch {
                DDLogError(error.localizedDescription)
                print(error.localizedDescription)
            }
        } else {
            let res = FileManager.default.createFile(atPath: path.path, contents: data, attributes: nil)
            DDLogInfo("file created: \(res)")
            print("file created: \(res)")
        }
    }
    
    public func loadFromFile(){
        let basePath = try? FileManager.default.url(for: .cachesDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
        let path : URL = basePath!.appendingPathComponent("notesData.bin", isDirectory: false)
        
        let data = try! Data(contentsOf: path, options: [])
        let json = try! JSONSerialization.jsonObject(with: data)
        
        notes.removeAll()
        
        if let array = json as? NSArray {
            for obj in array {
                if obj as? [String : Any] != nil {
                    add((Note.parse(json: obj as! [String : Any]) ?? nil)!)
                }
            }
        }
        
        DDLogInfo("Notes load from file.")
    }
}
