//
//  InformativeCustomView.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 05.05.2021.
//

import UIKit

class InformativeCustomView: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "IconForEmptiList")
        
        return image
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.text = "Get a clear view of the day ahead \n\n All your tasks that are due today will show up here. Tap + to add a task."
    
        return label
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .purple
        button.setTitle("Add a habit", for: .normal)
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    
        return button
    }()
    
    private lazy var centreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(imageView)
        view.addSubview(textLabel)
        view.addSubview(infoButton)
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        self.addSubview(centreView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            centreView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centreView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centreView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            centreView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: centreView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: centreView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: centreView.trailingAnchor, constant: -20),
            textLabel.leadingAnchor.constraint(equalTo: centreView.leadingAnchor, constant: 20),
            textLabel.centerXAnchor.constraint(equalTo: centreView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            infoButton.centerXAnchor.constraint(equalTo: centreView.centerXAnchor),
            infoButton.widthAnchor.constraint(equalTo: centreView.widthAnchor, multiplier: 0.5),
            infoButton.bottomAnchor.constraint(equalTo: centreView.bottomAnchor, constant: -20)
        ])
    
        infoButton.roundCorners(type: .all, radius: 17)
    }
    
    @objc
    func tapButton() {
        
    }
}
