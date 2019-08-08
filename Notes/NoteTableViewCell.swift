//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Анна Коптева on 20/07/2019.
//  Copyright © 2019 Anna Kopteva. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleNoteLabel: UILabel!
    @IBOutlet weak var contentNoteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
}
