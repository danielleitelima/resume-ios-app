import UIKit

import BrandTheme

class SkillBadge: UIView {
    private let iconImageView = UIImageView()
    private let descriptionLabel = UILabel()
    var onClick: (() -> Void)?
    
    @discardableResult
    func setData(description: String, imageURL: URL?) -> SkillBadge {
        descriptionLabel.text = description
        
        setPlaceholderImage()
        
        if let imageURL {
            let placeholder = UIImage(systemName: "doc.text.fill") ?? UIImage()
            
            getRemoteImage(url: imageURL, placeholder: placeholder){ [weak self] image in
                self?.iconImageView.image = image
                self?.iconImageView.backgroundColor = .clear
                self?.iconImageView.contentMode = .scaleAspectFit
            }.resume()
        }
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
    
        backgroundColor = BrandColor.secondaryContainer.load()
        layer.cornerRadius = 8
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.backgroundColor = .systemGray5

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 1
   
        setupConstraints()
        setGestures()
    }
    
    private func setPlaceholderImage() {
        iconImageView.image = UIImage(systemName: "doc.text.fill")
        iconImageView.tintColor = .systemGray3
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.backgroundColor = .systemGray6
    }
    
    private func setGestures() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(internalOnClick))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func internalOnClick() {
        onClick?()
    }
    
    private func setupConstraints() {
        addSubview(iconImageView)
        addSubview(descriptionLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            
            // Label constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Badge height
            heightAnchor.constraint(greaterThanOrEqualToConstant: 34),
            
            // Top and bottom constraints to ensure proper vertical sizing
            topAnchor.constraint(lessThanOrEqualTo: iconImageView.topAnchor, constant: -8),
            bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: 8)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = descriptionLabel.intrinsicContentSize
        let width = 8 + 18 + 8 + labelSize.width + 12 // spacing + icon + spacing + label + right padding
        let height = max(34, labelSize.height + 16) // Ensure minimum height
        
        return CGSize(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
