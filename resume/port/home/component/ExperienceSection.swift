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
        // Configure title label
        titleLabel.text = "Experience"
        titleLabel.font = .systemFont(ofSize: 36, weight: .regular)
        titleLabel.textColor = .label
        
        // Configure stack view for experience cards
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
            
            // For each role in the experience, create a card
            for (roleIndex, role) in experience.roles.enumerated() {
                let card = ExperienceCard()
                card.setData(
                    companyName: experience.company.name,
                    period: role.period,
                    role: role.name,
                    location: experience.company.location,
                    description: role.description,
                    isFirst: isFirst && roleIndex == 0,
                    isLast: isLast && roleIndex == experience.roles.count - 1
                )
                
                stackView.addArrangedSubview(card)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
