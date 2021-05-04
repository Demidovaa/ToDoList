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
    
    private var completedHandler: ((Bool) -> Void)?
    
    private var isClicked: Bool = false {
        didSet {
            statusTaskButton.setImage(UIImage(systemName: isClicked ? "checkmark" : "circle" ), for: .normal)
            textTaskLabel.attributedText = textTaskLabel.text?.styled(isClicked ? .strikethroughText : .text)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    enum StyleCell {
        case standard
        case completed
        
        init(rawValue: Bool) {
            switch rawValue {
            case false:
                self = .standard
            case true:
                self = .completed
            }
        }
        
        fileprivate struct ConfigStyle {
            let textStyle: TextStyle
            let isCompleted: Bool
        }
        
        fileprivate var config: ConfigStyle {
            switch self {
            case .standard:
                return ConfigStyle(textStyle: TextStyle.text, isCompleted: false)
            case .completed:
                return ConfigStyle(textStyle: TextStyle.strikethroughText, isCompleted: true)
            }
        }
    }
    
    func configureCell(text: String, styleCell: StyleCell, color: UIColor = .white, tapHandler: ((Bool) -> Void)? = nil) {
        let config = styleCell.config
        textTaskLabel.attributedText = text.styled(config.textStyle)
        statusTaskButton.setImage(UIImage(systemName: styleCell.config.isCompleted ? "checkmark" : "circle" ), for: .normal)
        
        rearView.backgroundColor = color
        statusTaskButton.tintColor = color == .white ? .systemBlue : .white
        
        if color == .white {
            rearView.addBorder(borderColor: UIColor.separator.cgColor,
                               borderWith: AppConstants.borderWith,
                               borderCornerRadius: AppConstants.cellFlagRounding)
        }
        completedHandler = tapHandler
    }
    
    //MARK: - Private Func
    
    private func configureView() {
        self.selectionStyle = .none
        
        rearView.roundCorners(type: .all, radius: AppConstants.cellRounding)
        rearView.backgroundColor = .systemYellow
        
        textTaskLabel.numberOfLines = 0
        textTaskLabel.lineBreakMode = .byWordWrapping
    }
    
    @IBAction private func tapButton(_ sender: Any) {
        statusTaskButton.isSelected = !statusTaskButton.isSelected
        isClicked = statusTaskButton.isSelected
        completedHandler?(isClicked)
    }
}
