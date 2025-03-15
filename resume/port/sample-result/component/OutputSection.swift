//
//  LogSection.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class OutputSection: UIView {
    let valueLabel = UILabel()
    let durationLabel = UILabel()
    let durationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "stopwatch"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @discardableResult
    func setData(value: String, duration: String) -> OutputSection {
        valueLabel.text = value
        durationLabel.text = "calculated in \(duration)"
        return self
    }
    
    init() {
        super.init(frame: .zero)
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        durationLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        durationLabel.textColor = .secondaryLabel

        durationIcon.tintColor = .secondaryLabel

        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(valueLabel)
        addSubview(durationLabel)
        addSubview(durationIcon)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            
            durationIcon.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 8),
            durationIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            durationIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: durationIcon.topAnchor),
            durationLabel.leadingAnchor.constraint(equalTo: durationIcon.trailingAnchor, constant: 4),
            durationLabel.bottomAnchor.constraint(equalTo: durationIcon.bottomAnchor)
         
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    OutputSection().setData(value: "Test", duration: "3ms")
}
