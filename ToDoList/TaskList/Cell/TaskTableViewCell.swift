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
        
    enum StyleTextCell {
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
                
        fileprivate var config: TextStyle {
            switch self {
            case .standard:
                return TextStyle.text
            case .completed:
                return TextStyle.strikethroughText
            }
        }
    }
    
    func configureCell(text: String, styleCell: StyleTextCell, color: UIColor = .white, tapHandler: ((Bool) -> Void)? = nil) {
        let config = styleCell.config
        textTaskLabel.attributedText = text.styled(config)
        rearView.backgroundColor = color
        statusTaskButton.tintColor = color == .white ? .systemBlue : .white
        
        if color == .white {
            rearView.addBorder(borderColor: UIColor.separator.cgColor,
                                borderWith: Constants.borderWith,
                                borderCornerRadius: Constants.cellFlagRounding)
        }
        completedHandler = tapHandler
    }
    
    //MARK: - Private Func
    
    private func configureView() {
        self.selectionStyle = .none
        
        statusTaskButton.setImage(UIImage(systemName: "circle"), for: .normal)
        statusTaskButton.tintColor = .systemTeal
        
        rearView.roundCorners(type: .all, radius: Constants.cellRounding)
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
