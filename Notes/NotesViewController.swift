//
//  NotesViewController.swift
//  Notes
//
//  Created by Анна Коптева on 20/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import UIKit

class NotesViewController: UIViewController {
    
    var notes: [Note] = []
    var selectedNote: Note? = nil
    var notebook: FileNotebook = FileNotebook()
    
    var reuseIdentifier = "note cell"

    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBAction func addBarButtonClicked(_ sender: UIBarButtonItem) {
        let note = Note(title: "", content: "", importantce: .ordinary, selfDestructDate: nil)
        selectedNote = note
        notebook.add(note)
        notebook.saveToFile()
        self.performSegue(withIdentifier: "ShowEditNote", sender: self)
    }
    
    @IBAction func editBarButtonClicked(_ sender: UIBarButtonItem) {
        if(notesTableView.isEditing == true)
        {
            notesTableView.isEditing = false
            editBarButton.title = "Edit"
        }
        else
        {
            notesTableView.isEditing = true
            editBarButton.title = "Done"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? EditViewController,
            segue.identifier == "ShowEditNote"{
            controller.note = selectedNote
            controller.notebook = notebook
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Заметки"
        let note1 = Note(title: "Title1", content: "content", importantce: .important, selfDestructDate: Date(timeIntervalSince1970: 918247834))
        notebook.add(note1)
        let note2 = Note(uid: "233", title: "Title2", content: "Conten2", color: .red, importantce: .important, selfDestructDate: Date(timeIntervalSince1970: 747878784784))
        notebook.add(note2)
        //notebook.saveToFile()
        notebook.loadFromFile()
        notes = notebook.notes
        
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        notesTableView.isEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notebook.loadFromFile()
        notes = notebook.notes
        notesTableView.reloadData()
        print("viewWillAppear")
    }

}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NoteTableViewCell
        
        let note = notes[indexPath.row]
        cell.colorView.backgroundColor = note.color
        cell.titleNoteLabel.text = note.title
        cell.contentNoteLabel.text = note.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        selectedNote = notes[indexPath.row]
        self.performSegue(withIdentifier: "ShowEditNote", sender: self)
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let noteForDelete = notes[indexPath.row]
            notesTableView.beginUpdates()
            notes.remove(at: indexPath.row)
            notebook.remove(with: noteForDelete.uid)
            notesTableView.deleteRows(at: [indexPath], with: .left)
            notesTableView.endUpdates()
        }
    }
}
