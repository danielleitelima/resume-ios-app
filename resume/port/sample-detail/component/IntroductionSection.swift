//
//  LogSection.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class IntroductionSection: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
   
    @discardableResult
    func setData(title: String, description: String) -> IntroductionSection {
        titleLabel.text = title
        descriptionLabel.text = description
        return self
    }
    
    init() {
        super.init(frame: .zero)
        titleLabel.font = .headlineSmall
        titleLabel.numberOfLines = 0
        
        descriptionLabel.font = .bodyMedium
        descriptionLabel.numberOfLines = 0

        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
