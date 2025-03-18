import UIKit
import SafariServices

class FooterSection: UIView {
    private let messageLabel = UILabel()
    private let customDivider: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "custom-divider")?.withTintColor(.outline))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailButton = FooterButton()
    private let linkedInButton = FooterButton()
    private let gitHubButton = FooterButton()
    private let buttonsStackView = UIStackView()
    
    private var email: String?
    private var linkedInURL: String?
    private var gitHubURL: String?
    
    @discardableResult
    func setData(
        email: String?,
        linkedInURL: String?,
        gitHubURL: String?
    ) -> FooterSection {
        self.email = email
        self.linkedInURL = linkedInURL
        self.gitHubURL = gitHubURL
        
        emailButton.setData(icon: "ic-mail")
        linkedInButton.setData(icon: "ic-linkedin")
        gitHubButton.setData(icon: "ic-github")
        
        // Add targets for button actions
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        linkedInButton.addTarget(self, action: #selector(linkedInButtonTapped), for: .touchUpInside)
        gitHubButton.addTarget(self, action: #selector(gitHubButtonTapped), for: .touchUpInside)

        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        messageLabel.text = "Let's talk!"
        messageLabel.font = .headlineLarge
        messageLabel.textColor = .outline
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        
        setupButtonsStackView()
        setConstraints()
    }
    
    private func setupButtonsStackView() {
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.spacing = 24
        buttonsStackView.alignment = .center
        
        buttonsStackView.addArrangedSubview(emailButton)
        buttonsStackView.addArrangedSubview(linkedInButton)
        buttonsStackView.addArrangedSubview(gitHubButton)
    }
    
    private func setConstraints() {
        addSubview(customDivider)
        addSubview(messageLabel)
        addSubview(buttonsStackView)
        
        customDivider.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            customDivider.topAnchor.constraint(equalTo: topAnchor),
            customDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            customDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: customDivider.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            buttonsStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 24),
            buttonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonsStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32)
        ])
        
        // Set a fixed width for each button to ensure they're visible
        [emailButton, linkedInButton, gitHubButton].forEach { button in
            button.widthAnchor.constraint(equalToConstant: 48).isActive = true
            button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func emailButtonTapped() {
        guard let email = email, let emailURL = URL(string: "mailto:\(email)") else { return }
        
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func linkedInButtonTapped() {
        guard let linkedInURLString = linkedInURL, let url = URL(string: linkedInURLString) else { return }
        presentSafariViewController(with: url)
    }
    
    @objc private func gitHubButtonTapped() {
        guard let gitHubURLString = gitHubURL, let url = URL(string: gitHubURLString) else { return }
        presentSafariViewController(with: url)
    }
    
    private func presentSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        UIApplication.shared.windows.first?.rootViewController?.present(safariVC, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
