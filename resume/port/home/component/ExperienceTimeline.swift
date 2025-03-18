import UIKit

class ExperienceTimeline: UIView {
    private let contentStackView = UIStackView()
    let topBar = UIView()
    let topBarContainer = UIView()
    let yearBadge = UILabel()
    let badgeContainer = UIView()
    let middleBar = UIView()
    let middleBarContainer = UIView()
    let divider = UIView()
    
    @discardableResult
    func setData(isFirst: Bool, isLast: Bool, year: String) -> ExperienceTimeline {
        // Clear existing subviews in the stack
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create vertical bar
        
        topBar.backgroundColor = .primaryContainer
        topBar.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        if isFirst {
            topBar.layer.cornerRadius = 8
            topBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // Add vertical bar to a container to center it
        
        topBarContainer.addSubview(topBar)
        NSLayoutConstraint.activate([
            topBar.centerXAnchor.constraint(equalTo: topBarContainer.centerXAnchor),
            topBar.topAnchor.constraint(equalTo: topBarContainer.topAnchor),
            topBar.bottomAnchor.constraint(equalTo: topBarContainer.bottomAnchor)
        ])
        
        // Year badge
        
        yearBadge.text = year
        yearBadge.font = .labelSmall
        yearBadge.textAlignment = .center
        yearBadge.textColor = .onPrimary
        yearBadge.backgroundColor = .primary
        yearBadge.layer.cornerRadius = 8
        yearBadge.clipsToBounds = true
        yearBadge.translatesAutoresizingMaskIntoConstraints = false
        
        badgeContainer.addSubview(yearBadge)
        NSLayoutConstraint.activate([
            yearBadge.centerXAnchor.constraint(equalTo: badgeContainer.centerXAnchor),
            yearBadge.centerYAnchor.constraint(equalTo: badgeContainer.centerYAnchor),
            yearBadge.leadingAnchor.constraint(equalTo: badgeContainer.leadingAnchor),
            yearBadge.trailingAnchor.constraint(equalTo: badgeContainer.trailingAnchor),
            yearBadge.heightAnchor.constraint(equalToConstant: 32),
            badgeContainer.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Bar above the year badge (48pt height)
        
        middleBar.backgroundColor = .primaryContainer
        middleBar.translatesAutoresizingMaskIntoConstraints = false
        
        middleBarContainer.addSubview(middleBar)
        NSLayoutConstraint.activate([
            middleBar.centerXAnchor.constraint(equalTo: middleBarContainer.centerXAnchor),
            middleBar.topAnchor.constraint(equalTo: middleBarContainer.topAnchor),
            middleBar.bottomAnchor.constraint(equalTo: middleBarContainer.bottomAnchor),
            middleBar.widthAnchor.constraint(equalToConstant: 16),
            middleBarContainer.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Divider (3pt height)
        
        divider.backgroundColor = .primary
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let dividerContainer = UIView()
        dividerContainer.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 3),
            divider.topAnchor.constraint(equalTo: dividerContainer.topAnchor),
            divider.bottomAnchor.constraint(equalTo: dividerContainer.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: dividerContainer.trailingAnchor)
        ])
                
        contentStackView.addArrangedSubview(topBarContainer)
        contentStackView.addArrangedSubview(dividerContainer)
        contentStackView.addArrangedSubview(middleBarContainer)
        contentStackView.addArrangedSubview(badgeContainer)
        
        // Add elements to stack view from bottom to top (since it's a vertical stack)
        if isLast {
            // Bottom bar with rounded corners for the last item
            let bottomBar = UIView()
            bottomBar.backgroundColor = .primaryContainer
            bottomBar.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.layer.cornerRadius = 8
            bottomBar.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            let bottomBarContainer = UIView()
            bottomBarContainer.addSubview(bottomBar)
            NSLayoutConstraint.activate([
                bottomBar.centerXAnchor.constraint(equalTo: bottomBarContainer.centerXAnchor),
                bottomBar.topAnchor.constraint(equalTo: bottomBarContainer.topAnchor),
                bottomBar.bottomAnchor.constraint(equalTo: bottomBarContainer.bottomAnchor),
                bottomBar.widthAnchor.constraint(equalToConstant: 16),
                bottomBarContainer.heightAnchor.constraint(equalToConstant: 48)
            ])
            
            contentStackView.addArrangedSubview(bottomBarContainer)
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
