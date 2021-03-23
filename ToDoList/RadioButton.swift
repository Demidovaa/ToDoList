//
//  RadioButton.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 23.03.2021.
//

import UIKit

@IBDesignable
class RadioButton: UIButton {
    
    //MARK: - Properties
    
    var outerCircleLayer = CAShapeLayer()
    var innerCircleLayer = CAShapeLayer()
 
    var setCircleRadius: CGFloat {
        let width = bounds.width
        let height = bounds.height
        
        let length = width > height ? height : width
        return (length - outerCircleLineWidth) / 2
    }
        
    //MARK: - IBInspectable
        
    @IBInspectable var outerCircleColor: UIColor = UIColor.black {
        didSet {
            outerCircleLayer.strokeColor = outerCircleColor.cgColor
        }
    }
    
    @IBInspectable var innerCircleColor: UIColor = UIColor.black {
        didSet {
            setFillState()
        }
    }
    
    @IBInspectable var outerCircleLineWidth: CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    @IBInspectable var innerCircleGap: CGFloat = 3.0 {
        didSet {
            setCircleLayouts()
        }
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInitialization()
    }
    
    //MARK: - Private Properties
    
    private var setCircleFrame: CGRect {
        let width = bounds.width
        let height = bounds.height
        
        let radius = setCircleRadius
        let x: CGFloat
        let y: CGFloat
        
        if width > height {
            y = outerCircleLineWidth / 2
            x = (width / 2) - radius
        } else {
            x = outerCircleLineWidth / 2
            y = (height / 2) - radius
        }
        
        let diameter = 2 * radius
        return CGRect(x: x, y: y, width: diameter, height: diameter)
    }
    
    private var circlePath: UIBezierPath {
        return UIBezierPath(roundedRect: setCircleFrame, cornerRadius: setCircleRadius)
    }
    
    private var fillCirclePath: UIBezierPath {
        let trueGap = innerCircleGap + (outerCircleLineWidth / 2)
        return UIBezierPath(roundedRect: setCircleFrame.insetBy(dx: trueGap, dy: trueGap), cornerRadius: setCircleRadius)
        
    }
    
    //MARK: Private Func
    
    private func customInitialization() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.fillColor = UIColor.clear.cgColor
        outerCircleLayer.strokeColor = outerCircleColor.cgColor
        layer.addSublayer(outerCircleLayer)
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.fillColor = UIColor.clear.cgColor
        innerCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(innerCircleLayer)
        
        setFillState()
    }
    
    private func setCircleLayouts() {
        outerCircleLayer.frame = bounds
        outerCircleLayer.lineWidth = outerCircleLineWidth
        outerCircleLayer.path = circlePath.cgPath
        
        innerCircleLayer.frame = bounds
        innerCircleLayer.lineWidth = outerCircleLineWidth
        innerCircleLayer.path = fillCirclePath.cgPath
    }
    
    private func setFillState() {
        if self.isSelected {
            innerCircleLayer.fillColor = outerCircleColor.cgColor
        } else {
            innerCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }
    
    //MARK: -  Overriden methods
    
    override func prepareForInterfaceBuilder() {
        customInitialization()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setCircleLayouts()
    }
    override var isSelected: Bool {
        didSet {
            setFillState()
        }
    }
}
