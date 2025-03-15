import UIKit

class ExperienceCard: UIView {
    private let timeline = ExperienceTimeline()
    private let contentContainer = UIView()
    
    private let durationContainer = UIView()
    private let calendarIcon = UIImageView()
    private let durationLabel = UILabel()
    
    private let titleContainer = UIView()
    private let companyNameLabel = UILabel()
    private let yearCountLabel = UILabel()
    
    private let roleLabel = UILabel()
    
    private let locationContainer = UIView()
    private let locationIcon = UIImageView()
    private let locationLabel = UILabel()
    
    private let descriptionLabel = UILabel()
    
    private var startYear: String = ""
    private var isFirst: Bool = false
    private var isLast: Bool = false
    
    @discardableResult
    func setData(
        companyName: String,
        period: String,
        role: String,
        location: String,
        description: String,
        isFirst: Bool,
        isLast: Bool
    ) -> ExperienceCard {
        self.isFirst = isFirst
        self.isLast = isLast
        
        // Set the duration
        durationLabel.text = "From \(period)"
        
        // Extract the start year from period
        startYear = extractStartYear(from: period)
        
        // Configure timeline
        timeline.setData(isFirst: isFirst, isLast: isLast, year: startYear)
        
        // Set company name
        companyNameLabel.text = companyName
        
        // Calculate and set year count
        yearCountLabel.text = calculateYearCount(from: period)
        
        // Set role and location
        roleLabel.text = role
        locationLabel.text = location
        
        // Set description
        descriptionLabel.text = description
        
        return self
    }
    
    private func extractStartYear(from period: String) -> String {
        // Extract the first part of the period which should be the start year
        let components = period.components(separatedBy: " ")
        if components.count > 0 {
            return components[0]
        }
        return ""
    }
    
    init() {
        super.init(frame: .zero)
        
        // Remove background color and corner radius from main view
        backgroundColor = .clear
        
        // Apply styling to content container instead
        contentContainer.backgroundColor = UIColor.systemGray6
        contentContainer.layer.cornerRadius = 10
        
        // Setup calendar icon
        calendarIcon.image = UIImage(systemName: "calendar")
        calendarIcon.tintColor = .systemTeal
        
        // Setup duration label
        durationLabel.textColor = .systemTeal
        durationLabel.font = .systemFont(ofSize: 16)
        
        // Setup company name label
        companyNameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        companyNameLabel.numberOfLines = 0
        
        // Setup year count label
        yearCountLabel.textColor = .secondaryLabel
        yearCountLabel.font = .systemFont(ofSize: 16)
        yearCountLabel.textAlignment = .right
        
        // Setup role label
        roleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        roleLabel.textColor = .label
        
        // Setup location icon
        locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        locationIcon.tintColor = .label
        
        // Setup location label
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .label
        
        // Setup description label
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0
        
        setupConstraints()
    }
    
    private func calculateYearCount(from period: String) -> String {
        // Assuming period format is like "2018 to 2021"
        let components = period.components(separatedBy: " ")
        if components.count >= 3, let startYear = Int(components[0]), let endYear = Int(components[2]) {
            let years = endYear - startYear
            return years == 1 ? "1 year" : "\(years) years"
        }
        return "1 year" // Default value
    }
    
    private func setupConstraints() {
        // Add timeline and content container directly to main view
        addSubview(timeline)
        addSubview(contentContainer)
        
        // Add subviews to content container
        contentContainer.addSubview(durationContainer)
        durationContainer.addSubview(calendarIcon)
        durationContainer.addSubview(durationLabel)
        
        contentContainer.addSubview(titleContainer)
        titleContainer.addSubview(companyNameLabel)
        titleContainer.addSubview(yearCountLabel)
        
        contentContainer.addSubview(roleLabel)
        
        contentContainer.addSubview(locationContainer)
        locationContainer.addSubview(locationIcon)
        locationContainer.addSubview(locationLabel)
        
        contentContainer.addSubview(descriptionLabel)
        
        // Set constraints
        timeline.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        durationContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        yearCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationContainer.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Timeline constraints - keep it on the left side
            timeline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timeline.topAnchor.constraint(equalTo: topAnchor),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content container - now positioned with 48pt top margin
            contentContainer.leadingAnchor.constraint(equalTo: timeline.trailingAnchor, constant: 8),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 24), // 48pt top margin
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -71),
            
            // Duration container - adjust position within content container
            durationContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 24),
            durationContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            durationContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            calendarIcon.leadingAnchor.constraint(equalTo: durationContainer.leadingAnchor),
            calendarIcon.centerYAnchor.constraint(equalTo: durationContainer.centerYAnchor),
            calendarIcon.widthAnchor.constraint(equalToConstant: 20),
            calendarIcon.heightAnchor.constraint(equalToConstant: 20),
            
            durationLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor, constant: 8),
            durationLabel.centerYAnchor.constraint(equalTo: durationContainer.centerYAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: durationContainer.trailingAnchor),
            
            // Title container
            titleContainer.topAnchor.constraint(equalTo: durationContainer.bottomAnchor, constant: 16),
            titleContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            titleContainer.trailingAnchor.constraint(equalTo: yearCountLabel.leadingAnchor, constant: -24),

            yearCountLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            yearCountLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            yearCountLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            yearCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            companyNameLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            companyNameLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            companyNameLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor),
            companyNameLabel.trailingAnchor.constraint(equalTo: yearCountLabel.leadingAnchor, constant: -16),
            
            // Role label
            roleLabel.topAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: 16),
            roleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            roleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            // Location container
            locationContainer.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 12),
            locationContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            locationContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            locationIcon.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor),
            locationIcon.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            locationLabel.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: locationContainer.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
