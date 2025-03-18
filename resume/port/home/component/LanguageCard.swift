import UIKit

class LanguageCard: UIView {
    private let flagImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let languageLevelView = LanguageLevel()
    
    @discardableResult
    func setData(
        name: String,
        description: String,
        imageURL: URL?,
        level: Int
    ) -> LanguageCard {
                
        nameLabel.text = name
        descriptionLabel.text = description
        
        setPlaceholderImage()
        
        if let imageURL {
            let placeholder = UIImage(systemName: "globe") ?? UIImage()
            
            getRemoteImage(url: imageURL, placeholder: placeholder){ [weak self] image in
                self?.flagImageView.image = image
            }.resume()
        }
        
        languageLevelView.setData(level: level)
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
    
        backgroundColor = .surfaceContainerLow
        layer.cornerRadius = 8
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        flagImageView.contentMode = .scaleAspectFill
        flagImageView.clipsToBounds = true
        flagImageView.backgroundColor = .clear
        
        nameLabel.font = .titleMedium
        nameLabel.textColor = .onSurface

        descriptionLabel.font = .bodyLarge
        descriptionLabel.textColor = .onSurfaceVariant

        setupConstraints()
    }
    
    private func setPlaceholderImage() {
        flagImageView.image = UIImage(systemName: "globe")
        flagImageView.tintColor = .onSurface
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        addSubview(flagImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(languageLevelView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        languageLevelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 24 + 36 + 24),
            
            flagImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            flagImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            flagImageView.heightAnchor.constraint(equalToConstant: 36),
            flagImageView.widthAnchor.constraint(equalToConstant: 48),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: languageLevelView.leadingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: languageLevelView.leadingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            
            languageLevelView.centerYAnchor.constraint(equalTo: centerYAnchor),
            languageLevelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
