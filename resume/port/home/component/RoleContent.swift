import UIKit

class RoleContent: UIView {
    private let roleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let durationLabel = UILabel()
    
    private let locationContainer = UIView()
    private let locationIcon = UIImageView()
    private let locationLabel = UILabel()
    
    var bottomView: UIView {
        locationLabel.text?.isEmpty ?? true ? descriptionLabel : locationContainer
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    func setData(role: Role) -> RoleContent {
        // Role name
        roleLabel.text = role.name
        
        // Role description
        descriptionLabel.text = role.description
        
        // Format and set role duration
        let roleDuration = formatDetailedDuration(startDate: role.startDate, endDate: role.endDate)
        durationLabel.text = roleDuration.isEmpty ? "" : roleDuration
        
        // Location (if available)
        if let roleLocation = role.location, !roleLocation.isEmpty {
            locationLabel.text = roleLocation
            locationContainer.isHidden = false
        } else {
            locationContainer.isHidden = true
        }
        
        setupConstraints()
        return self
    }
    
    private func setupViews() {
        // Role label
        roleLabel.font = .titleSmall
        roleLabel.textColor = .onSurface
        
        durationLabel.textColor = .onSurfaceVariant
        durationLabel.font = .labelSmall
        durationLabel.textAlignment = .right
        
        descriptionLabel.font = .bodySmall
        descriptionLabel.textColor = .onSurface
        descriptionLabel.numberOfLines = 0
        
        locationIcon.image = UIImage(systemName: "mappin.and.ellipse")
        locationIcon.tintColor = .onSurface
        locationLabel.font = .bodySmall
        locationLabel.textColor = .onSurface
        
        addSubview(roleLabel)
        addSubview(durationLabel)
        addSubview(descriptionLabel)
        
        locationContainer.addSubview(locationIcon)
        locationContainer.addSubview(locationLabel)
        addSubview(locationContainer)
    }
    
    private func setupConstraints() {
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        locationContainer.translatesAutoresizingMaskIntoConstraints = false
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roleLabel.topAnchor.constraint(equalTo: topAnchor),
            roleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: durationLabel.leadingAnchor, constant: -12),
            
            durationLabel.topAnchor.constraint(equalTo: roleLabel.topAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: roleLabel.bottomAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            locationContainer.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 16),
            locationContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            locationContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            locationIcon.leadingAnchor.constraint(equalTo: locationContainer.leadingAnchor),
            locationIcon.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationIcon.widthAnchor.constraint(equalToConstant: 20),
            locationIcon.heightAnchor.constraint(equalToConstant: 20),
            
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            locationLabel.centerYAnchor.constraint(equalTo: locationContainer.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: locationContainer.trailingAnchor),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: locationContainer.isHidden ? roleLabel.bottomAnchor : locationContainer.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func formatDetailedDuration(startDate: String, endDate: String?) -> String {
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
} 
