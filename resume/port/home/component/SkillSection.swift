import UIKit

class SkillSection: UIView {
    private let titleLabel = UILabel()
    private let carouselView = UIStackView()
    
    private var skills = [Skill]()
    
    @discardableResult
    func setData(
        skills: [Skill]
    ) -> SkillSection {
        self.skills = skills
        
        setupContainer()
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = .displaySmall(for: traitCollection)
        titleLabel.textColor = .onSurface
        titleLabel.text = "Skills"
        titleLabel.numberOfLines = 0
        
        setConstraints()
        setupContainer()
    }
    
    func setupContainer() {
        // Remove any existing skill badges
        carouselView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Configure the container
        carouselView.axis = .vertical
        carouselView.alignment = .fill
        carouselView.spacing = 12
        carouselView.distribution = .fill
        
        // Create a horizontal flow layout container
        let flowContainer = FlexboxLayout()
        flowContainer.spacing = 8
        flowContainer.padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Add each skill badge to the flow container
        for skill in skills {
            let badge = SkillBadge()
            badge.setData(description: skill.description, imageURL: URL(string: skill.imageUrl))
            flowContainer.addArrangedSubview(badge)
        }
        
        // Add the flow container to the carousel
        carouselView.addArrangedSubview(flowContainer)
        
        // Add the carousel to the view if it's not already added
        if carouselView.superview == nil {
            addSubview(carouselView)
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                carouselView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
                carouselView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                carouselView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                carouselView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
            ])
        }
        
        // Add width constraint to the flow container
        if let superview = flowContainer.superview {
            NSLayoutConstraint.activate([
                flowContainer.widthAnchor.constraint(equalTo: superview.widthAnchor)
            ])
        }
    }

    
    private func setConstraints() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
