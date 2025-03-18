import UIKit
import BrandTheme

class PersonalDataSection: UIView {
    private let nameLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel = UILabel()
    private let introductionTitleLabel = UILabel()
    private let introductionDescriptionLabel = UILabel()
    
    @discardableResult
    func setData(
        name: String,
        title: String,
        description: String,
        location: String,
        introductionTitle: String,
        introductionDescription: String
    ) -> PersonalDataSection {
        nameLabel.text = name
        titleLabel.text = title
        descriptionLabel.text = description
        locationLabel.text = location
        introductionTitleLabel.text = introductionTitle
        introductionDescriptionLabel.text = introductionDescription
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .surfaceContainerLow
        layer.cornerRadius = 12
        
        nameLabel.font = .displaySmall(for: traitCollection)
        titleLabel.font = .titleMedium(for: traitCollection)
        descriptionLabel.font = .bodyLarge(for: traitCollection)
        locationLabel.font = .labelMedium(for: traitCollection)
        introductionTitleLabel.font = .headlineSmall(for: traitCollection)
        introductionDescriptionLabel.font = .bodyMedium(for: traitCollection)
        
        nameLabel.textColor = .onSurface
        titleLabel.textColor = .onSurface
        descriptionLabel.textColor = .onSurface
        locationIcon.tintColor = .onSurface
        locationLabel.textColor = .onSurface
        introductionTitleLabel.textColor = .onSurface
        introductionDescriptionLabel.textColor = .onSurface
        
        nameLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        introductionTitleLabel.numberOfLines = 0
        introductionDescriptionLabel.numberOfLines = 0
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(nameLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(introductionTitleLabel)
        addSubview(introductionDescriptionLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            locationIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            locationIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            locationLabel.topAnchor.constraint(
                equalTo: locationIcon.topAnchor
            ),
            locationLabel.bottomAnchor.constraint(
                equalTo: locationIcon.bottomAnchor
            ),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            introductionTitleLabel.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 32),
            introductionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            introductionTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            introductionDescriptionLabel.topAnchor.constraint(equalTo: introductionTitleLabel.bottomAnchor, constant: 8),
            introductionDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            introductionDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
           
            introductionDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
