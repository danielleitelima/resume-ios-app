//
//  MaterialTextField.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class MaterialTextField: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.outline.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false  // Disable user interaction
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .onSurfaceVariant
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .none
        textField.textColor = .onSurface
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var titleCenterYConstraint: NSLayoutConstraint?
    private var titleTopConstraint: NSLayoutConstraint?
    private var titleLeadingConstraint: NSLayoutConstraint?
    private var titleFontSize: CGFloat = 16
    private var isEditing: Bool = false
    
    
    var text: String? {
        get { return textField.text }
        set { 
            textField.text = newValue
            updateLabelPosition(animated: false)
        }
    }
    
    var placeholder: String? {
        didSet {
            textField.placeholder = nil
            updateLabelPosition(animated: false)
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }
        
    init(title: String, placeholder: String? = nil) {
        super.init(frame: .zero)
        self.title = title
        self.placeholder = placeholder
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(textField)
        titleContainer.addSubview(titleLabel)
        addSubview(titleContainer)

        titleLabel.text = title

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            
            titleContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -7),
            titleContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            
            titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        titleCenterYConstraint = titleContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        titleTopConstraint = titleContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
        
        titleCenterYConstraint?.isActive = true
        titleTopConstraint?.isActive = false
        
        textField.delegate = self
        
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        updateLabelPosition(animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if titleTopConstraint?.isActive == true {
            titleContainer.backgroundColor = backgroundColor
            let padding: CGFloat = 4
            titleContainer.layoutMargins = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            titleLabel.textColor = .onSurface
        } else {
            titleContainer.backgroundColor = .clear
            titleLabel.textColor = .onSurfaceVariant
        }
    }
        
    private func updateLabelPosition(animated: Bool = true) {
        let hasText = !(textField.text?.isEmpty ?? true)
        let shouldShowTitleAtTop = hasText || isEditing
        
        let animations = { [weak self] in
            guard let self = self else { return }
            
            self.titleCenterYConstraint?.isActive = !shouldShowTitleAtTop
            self.titleTopConstraint?.isActive = shouldShowTitleAtTop
            
            if shouldShowTitleAtTop {
                titleContainer.backgroundColor = backgroundColor
                self.titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
                self.titleLabel.textColor = self.isEditing ? .primary : .outline
                self.textField.placeholder = self.isEditing ? self.placeholder : nil
            } else {
                titleContainer.backgroundColor = .clear
                self.titleLabel.font = UIFont.systemFont(ofSize: 16)
                self.titleLabel.textColor = .onSurface
                self.textField.placeholder = nil
            }
            
            self.containerView.layer.borderWidth = self.isEditing ? 3 : 1
            self.containerView.layer.borderColor = self.isEditing ?
            UIColor.primary.cgColor : UIColor.outline.cgColor
            
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.2) {
                animations()
            }
        } else {
            animations()
        }
    }
    
    @objc private func textFieldDidChange() {
        updateLabelPosition()
    }
        
    func setError(_ error: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.containerView.layer.borderColor = error ? 
                UIColor.systemRed.cgColor : (self.isEditing ? 
                    UIColor.systemBlue.cgColor : UIColor.systemGray4.cgColor)
            self.titleLabel.textColor = error ? 
                .systemRed : (self.isEditing ? .systemBlue : .secondaryLabel)
        }
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        textField.addTarget(target, action: action, for: controlEvents)
    }
}

extension MaterialTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditing = true
        updateLabelPosition()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditing = false
        updateLabelPosition()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // If we need custom validation, we can add it here
        return true
    }
} 
