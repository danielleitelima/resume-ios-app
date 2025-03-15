import UIKit

class PersonalDataSection: UIView {
    private let nameLabel = UILabel()
    private let shortDescriptionLabel = UILabel()
    let locationIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "location.fill"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    @discardableResult
    func setData(
        name: String,
        shortDescription: String,
        location: String,
        title: String,
        description: String
    ) -> PersonalDataSection {
       
        nameLabel.text = name
        shortDescriptionLabel.text = shortDescription
        locationLabel.text = location
        titleLabel.text = title
        descriptionLabel.text = description
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        
        nameLabel.font = .systemFont(ofSize: 36, weight: .regular)
        shortDescriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        locationLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.font = .systemFont(ofSize: 24, weight: .regular)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        nameLabel.textColor = .label
        shortDescriptionLabel.textColor = .label
        locationIcon.tintColor = .label
        locationLabel.textColor = .label
        titleLabel.textColor = .label
        descriptionLabel.textColor = .label
        
        nameLabel.numberOfLines = 0
        shortDescriptionLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        titleLabel.numberOfLines = 0
        descriptionLabel.numberOfLines = 0

        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(nameLabel)
        addSubview(shortDescriptionLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        shortDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            shortDescriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            shortDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            shortDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            locationIcon.topAnchor.constraint(equalTo: shortDescriptionLabel.bottomAnchor, constant: 16),
            locationIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            locationLabel.topAnchor.constraint(
                equalTo: locationIcon.topAnchor
            ),
            locationLabel.bottomAnchor.constraint(
                equalTo: locationIcon.bottomAnchor
            ),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 4),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            titleLabel.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
