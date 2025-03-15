import UIKit

class ContactInfoView: UIView {
    private let stackView = UIStackView()
    private let emailLabel = UILabel()
    private let locationLabel = UILabel()
    private let linkedinLabel = UILabel()
    private let githubLabel = UILabel()
    
    @discardableResult
    func setData(
        email: String,
        location: String,
        linkedin: String,
        github: String
    ) -> ContactInfoView {
        
        emailLabel.text = email
        locationLabel.text = location
        linkedinLabel.text = linkedin
        githubLabel.text = github
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        [emailLabel, locationLabel, linkedinLabel, githubLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .systemGray
            label.textAlignment = .center
        }
        
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(linkedinLabel)
        stackView.addArrangedSubview(githubLabel)
        
        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
