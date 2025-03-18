import UIKit

class ExperienceCard: UIView {
    private let timeline = ExperienceTimeline()
    private let contentContainer = UIView()
    
    private let durationContainer = UIView()
    private let calendarIcon = UIImageView()
    private let durationLabel = UILabel()
    
    private let companyContainer = UIView()
    private let companyNameLabel = UILabel()
    private let yearCountLabel = UILabel()
    
    private let locationContainer = UIView()
    private let locationIcon = UIImageView()
    private let locationLabel = UILabel()
    
    private var roleContentViews: [RoleContent] = []
    
    private var startYear: String = ""
    private var isFirst: Bool = false
    private var isLast: Bool = false
    
    @discardableResult
    func setData(
        company: Company,
        roles: [Role],
        isFirst: Bool,
        isLast: Bool
    ) -> ExperienceCard {
        self.isFirst = isFirst
        self.isLast = isLast
        
        let period = formatPeriod(startDate: company.startDate, endDate: company.endDate)
        durationLabel.text = period.isEmpty ? "" : "From \(period)"
        
        startYear = extractStartYear(from: company.startDate)
        
        timeline.setData(isFirst: isFirst, isLast: isLast, year: startYear)
        
        companyNameLabel.text = company.name
        
        locationLabel.text = company.location ?? ""
        locationContainer.isHidden = (company.location ?? "").isEmpty
        
        yearCountLabel.text = calculateYearCount(startDate: company.startDate, endDate: company.endDate)
        
        roleContentViews.forEach { $0.removeFromSuperview() }
        roleContentViews.removeAll()
        
        for role in roles {
            let roleContent = RoleContent()
            roleContent.setData(role: role)
            roleContentViews.append(roleContent)
            contentContainer.addSubview(roleContent)
            roleContent.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setupConstraints()
        return self
    }
    
    private func formatPeriod(startDate: String, endDate: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let start = dateFormatter.date(from: startDate) else { return "" }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        
        let startYear = outputFormatter.string(from: start)
        
        if let endDate = endDate, let end = dateFormatter.date(from: endDate) {
            let endYear = outputFormatter.string(from: end)
            return "\(startYear) to \(endYear)"
        } else {
            return "\(startYear) to Present"
        }
    }
    
    private func extractStartYear(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        return ""
    }
    
    private func calculateYearCount(startDate: String, endDate: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let start = dateFormatter.date(from: startDate) else { return "" }
        
        let end = endDate.flatMap { dateFormatter.date(from: $0) } ?? Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: start, to: end)
        
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year" : "\(years) years"
        } else if let months = components.month, months > 0 {
            return months == 1 ? "1 month" : "\(months) months"
        } else if let days = components.day, days > 0 {
            return days == 1 ? "1 day" : "\(days) days"
        }
        
        return ""
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .clear
        
        contentContainer.backgroundColor = .surfaceContainerLow
        contentContainer.layer.cornerRadius = 12
        contentContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        calendarIcon.image = UIImage(systemName: "calendar")
        calendarIcon.tintColor = .primary
        
        durationLabel.textColor = .onSurfaceVariant
        durationLabel.font = .bodyMedium
        
        companyNameLabel.font = .titleMedium
        companyNameLabel.textColor = .onSurface
        companyNameLabel.numberOfLines = 0
        
        yearCountLabel.textColor = .onSurfaceVariant
        yearCountLabel.font = .labelSmall
        yearCountLabel.textAlignment = .right
        
        locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        locationIcon.tintColor = .onSurface
        
        locationLabel.font = .bodySmall
        locationLabel.textColor = .onSurface
        
        addSubview(timeline)
        addSubview(contentContainer)
        
        contentContainer.addSubview(durationContainer)
        durationContainer.addSubview(calendarIcon)
        durationContainer.addSubview(durationLabel)
        
        contentContainer.addSubview(companyContainer)
        companyContainer.addSubview(companyNameLabel)
        companyContainer.addSubview(yearCountLabel)
        
        contentContainer.addSubview(locationContainer)
        locationContainer.addSubview(locationIcon)
        locationContainer.addSubview(locationLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        timeline.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        durationContainer.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        companyContainer.translatesAutoresizingMaskIntoConstraints = false
        companyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        yearCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        locationContainer.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeline.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeline.topAnchor.constraint(equalTo: topAnchor),
            timeline.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentContainer.leadingAnchor.constraint(equalTo: timeline.trailingAnchor, constant: 12),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: isLast ? -119 : -71),
            
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
            
            companyContainer.topAnchor.constraint(equalTo: durationContainer.bottomAnchor, constant: 24),
            companyContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            companyContainer.trailingAnchor.constraint(equalTo: yearCountLabel.leadingAnchor, constant: -24),

            yearCountLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            yearCountLabel.topAnchor.constraint(equalTo: companyContainer.topAnchor),
            yearCountLabel.bottomAnchor.constraint(equalTo: companyContainer.bottomAnchor),
            yearCountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            companyNameLabel.leadingAnchor.constraint(equalTo: companyContainer.leadingAnchor),
            companyNameLabel.topAnchor.constraint(equalTo: companyContainer.topAnchor),
            companyNameLabel.bottomAnchor.constraint(equalTo: companyContainer.bottomAnchor),
            companyNameLabel.trailingAnchor.constraint(equalTo: yearCountLabel.leadingAnchor, constant: -16),
            
            locationContainer.topAnchor.constraint(equalTo: companyContainer.bottomAnchor, constant: 16),
            locationContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
            locationContainer.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            
            locationIcon.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor),
            locationIcon.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            locationLabel.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor),
        ])
        
        var previousView: UIView = locationContainer
        
        for (index, roleContent) in roleContentViews.enumerated() {
            NSLayoutConstraint.activate([
                roleContent.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 24),
                roleContent.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 24),
                roleContent.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -24),
            ])
            
            previousView = roleContent
            
            if index == roleContentViews.count - 1 {
                roleContent.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -24).isActive = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
} 
