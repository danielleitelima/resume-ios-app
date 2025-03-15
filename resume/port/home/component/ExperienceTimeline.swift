import UIKit

class ExperienceTimeline: UIView {
    private let contentStackView = UIStackView()
    let topBar = UIView()
    let redBarContainer = UIView()
    let yearBadge = UILabel()
    let badgeContainer = UIView()
    let middleBar = UIView()
    let greenBarContainer = UIView()
    let divider = UIView()
    
    @discardableResult
    func setData(isFirst: Bool, isLast: Bool, year: String) -> ExperienceTimeline {
        // Clear existing subviews in the stack
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create vertical bar
        
        topBar.backgroundColor = .systemGray4
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        if isFirst {
            topBar.layer.cornerRadius = 8
            topBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // Add vertical bar to a container to center it
        
        redBarContainer.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.centerXAnchor.constraint(equalTo: redBarContainer.centerXAnchor),
            topBar.topAnchor.constraint(equalTo: redBarContainer.topAnchor),
            topBar.bottomAnchor.constraint(equalTo: redBarContainer.bottomAnchor)
        ])
        
        // Year badge
        
        yearBadge.text = year
        yearBadge.textAlignment = .center
        yearBadge.textColor = .label
        yearBadge.backgroundColor = .systemGray6
        yearBadge.layer.cornerRadius = 8
        yearBadge.clipsToBounds = true
        yearBadge.translatesAutoresizingMaskIntoConstraints = false
        
        
        badgeContainer.addSubview(yearBadge)
        NSLayoutConstraint.activate([
            yearBadge.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            yearBadge.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor),
            yearBadge.widthAnchor.constraint(equalToConstant: 60),
            yearBadge.heightAnchor.constraint(equalToConstant: 32),
            badgeContainer.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Bar above the year badge (48pt height)
        
        middleBar.backgroundColor = .systemGray4
        middleBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        greenBarContainer.addSubview(middleBar)
        NSLayoutConstraint.activate([
            middleBar.centerXAnchor.constraint(equalTo: greenBarContainer.centerXAnchor),
            middleBar.topAnchor.constraint(equalTo: greenBarContainer.topAnchor),
            middleBar.bottomAnchor.constraint(equalTo: greenBarContainer.bottomAnchor),
            middleBar.widthAnchor.constraint(equalToConstant: 16),
            greenBarContainer.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Divider (3pt height)
        
        divider.backgroundColor = .systemGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let dividerContainer = UIView()
        dividerContainer.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 3),
            divider.topAnchor.constraint(equalTo: dividerContainer.topAnchor),
            divider.bottomAnchor.constraint(equalTo: dividerContainer.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor, constant: 8),
            divider.trailingAnchor.constraint(equalTo: dividerContainer.trailingAnchor, constant: -8)
        ])
                
        contentStackView.addArrangedSubview(redBarContainer)
        contentStackView.addArrangedSubview(dividerContainer)
        contentStackView.addArrangedSubview(greenBarContainer)
        contentStackView.addArrangedSubview(badgeContainer)
        
        // Add elements to stack view from bottom to top (since it's a vertical stack)
        if isLast {
            // Bottom bar with rounded corners for the last item
            let bottomBar = UIView()
            bottomBar.backgroundColor = .systemGray4
            bottomBar.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.layer.cornerRadius = 8
            bottomBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            let blueBarContainer = UIView()
            blueBarContainer.addSubview(bottomBar)
            NSLayoutConstraint.activate([
                bottomBar.centerXAnchor.constraint(equalTo: blueBarContainer.centerXAnchor),
                bottomBar.topAnchor.constraint(equalTo: blueBarContainer.topAnchor),
                bottomBar.bottomAnchor.constraint(equalTo: blueBarContainer.bottomAnchor),
                bottomBar.widthAnchor.constraint(equalToConstant: 16),
                blueBarContainer.heightAnchor.constraint(equalToConstant: 48)
            ])
            
            contentStackView.addArrangedSubview(blueBarContainer)
        }
    
        return self
    }
    
    init() {
        super.init(frame: .zero)
    
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 6
        contentStackView.distribution = .fill
        
        
        setupConstraints()
    }

    private func setupConstraints() {
        addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 60),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
