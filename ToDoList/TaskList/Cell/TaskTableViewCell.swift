//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 17.03.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet private weak var textTaskLabel: UILabel!
    @IBOutlet private weak var rearView: UIView!
    @IBOutlet private weak var statusTaskButton: RadioButton!
    
    //MARK: - Properties
    
    var completedHandler: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(text: String) {
        textTaskLabel.text = text
    }
    
    //MARK: - Private Func
    
    private func configureView() {
        self.selectionStyle = .none
        
        statusTaskButton.innerCircleGap = 2
        statusTaskButton.outerCircleLineWidth = 2
  
        rearView.roundCorners(type: .all, radius: 8)
        rearView.backgroundColor = .systemYellow
        
        textTaskLabel.numberOfLines = 0
        textTaskLabel.lineBreakMode = .byWordWrapping
    }
    
    @IBAction private func tapRadioButton(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        completedHandler?(sender.isSelected ? true : false)
    }
}
