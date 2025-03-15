import UIKit

class CodeSampleCard: UIView {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    var onClick: (() -> Void)?
    
    @discardableResult
    func setData(title: String, description: String, imageURL: URL?) -> CodeSampleCard {
        
        titleLabel.text = title
        descriptionLabel.text = description
        
        setPlaceholderImage()
        
        if let imageURL {
            let placeholder = UIImage(systemName: "doc.text.fill") ?? UIImage()
            
            getRemoteImage(url: imageURL, placeholder: placeholder){ [weak self] image in
                self?.thumbnailImageView.image = image
            }.resume()
        }
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
    
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .systemGray5
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label

        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 3
   
        setupConstraints()
        setGestures()
    }
    
    private func setPlaceholderImage() {
        thumbnailImageView.image = UIImage(systemName: "doc.text.fill")
        thumbnailImageView.tintColor = .systemGray3
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.backgroundColor = .systemGray6
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
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 220),
            
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
