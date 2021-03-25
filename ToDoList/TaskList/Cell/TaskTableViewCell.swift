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
    @IBOutlet private weak var statusTaskButton: UIButton!
    
    //MARK: - Properties
    
    var completedHandler: ((Bool) -> Void)?
    
    private var isClicked: Bool = false {
        didSet {
            statusTaskButton.setImage(UIImage(systemName: isClicked ? "checkmark" : "circle" ), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureCell(text: String, color: UIColor = .white) {
        textTaskLabel.text = text
        rearView.backgroundColor = color
        statusTaskButton.tintColor = color == .white ? .systemBlue : .white
    }
    
    //MARK: - Private Func
    
    private func configureView() {
        self.selectionStyle = .none
        
        statusTaskButton.setImage(UIImage(systemName: "circle"), for: .normal)
        statusTaskButton.tintColor = .systemTeal
        
        rearView.roundCorners(type: .all, radius: 8)
        rearView.backgroundColor = .systemYellow
        
        textTaskLabel.numberOfLines = 0
        textTaskLabel.lineBreakMode = .byWordWrapping
    }
    
    
    @IBAction private func tapButton(_ sender: Any) {
        statusTaskButton.isSelected = !statusTaskButton.isSelected
        isClicked = statusTaskButton.isSelected
        completedHandler?(isClicked ? true : false)
    }
}
