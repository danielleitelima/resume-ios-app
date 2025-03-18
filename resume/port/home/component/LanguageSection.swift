import UIKit

class LanguageSection: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    private var languages = [Language]()
    
    @discardableResult
    func setData(
        languages: [Language]
    ) -> LanguageSection {
        self.languages = languages
        
        // Clear existing cards
        stackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        // Add a card for each language
        for language in languages {
            let card = LanguageCard()
            card.setData(
                name: language.name,
                description: language.description,
                imageURL: URL(string: language.imageUrl),
                level: language.level
            )
            stackView.addArrangedSubview(card)
        }
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .displaySmall(for: traitCollection)
        titleLabel.textColor = .onSurface
        titleLabel.text = "Languages"
        titleLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12
        stackView.distribution = .fill
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
