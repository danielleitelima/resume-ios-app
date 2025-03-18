import UIKit

class ExperienceSection: UIView {
    private let titleLabel = UILabel()
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        titleLabel.font = .displaySmall(for: traitCollection)
        titleLabel.textColor = .onSurface
        titleLabel.text = "Experience"
        titleLabel.numberOfLines = 0
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        addSubview(titleLabel)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setData(_ experiences: [Experience]) {
        // Remove any existing cards
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add each experience card to the stack
        for (index, experience) in experiences.enumerated() {
            let isFirst = index == 0
            let isLast = index == experiences.count - 1
            
            let card = ExperienceCard()
            
            card.setData(
                company: experience.company,
                roles: experience.roles,
                isFirst: isFirst,
                isLast: isLast
            )
            
            stackView.addArrangedSubview(card)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
