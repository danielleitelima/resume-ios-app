//
//  LogSection.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class LogSection: UIView {
    let contentLabel = UILabel()
    
    @discardableResult
    func setData(logs: [String]) -> LogSection {
        
        let content = logs
            .map { "• \($0)" }
            .joined(separator: "\n")
        
        contentLabel.text = content
        return self
    }
    
    init() {
        super.init(frame: .zero)
        contentLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        contentLabel.numberOfLines = 0
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(contentLabel)
       
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
         
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#Preview {
    LogSection().setData(logs: ["Started app", "Loaded user data", "Connected to server", "Completed initialization"])
}
