//
//  PopoverTableViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 06.05.2021.
//

import UIKit

enum StylePopover {
    case informational
}

class PopoverTableViewCell: UITableViewCell {
        
    //MARK: IBOutlet

    @IBOutlet private weak var mark: UIImageView!
    @IBOutlet private weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ style: StylePopover, text: String) {
        switch style {
        case .informational:
            mark.tintColor = .systemYellow
            mark.image = UIImage(systemName: "star")
    
            infoLabel.text = text
            infoLabel.numberOfLines = 0
            infoLabel.textColor = .systemGray
            infoLabel.lineBreakMode = .byWordWrapping
        }
    }
}
