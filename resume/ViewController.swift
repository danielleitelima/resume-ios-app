import UIKit

// MARK: - Resume Models
struct Resume: Codable {
    let personalData: PersonalData
    let introduction: Introduction
    let skills: [Skill]
    let experiences: [Experience]
    let languages: [Language]
    let education: [Education]
    let articles: [Article]
}

struct PersonalData: Codable {
    let name: String
    let description: String
    let location: String
    let photoUrl: String
    let emailAddress: String
    let linkedinUrl: String
    let githubUrl: String
}

struct Introduction: Codable {
    let title: String
    let description: String
}

struct Skill: Codable {
    let description: String
    let imageUrl: String
}

struct Experience: Codable {
    let company: Company
    let roles: [Role]
}

struct Company: Codable {
    let name: String
    let period: String
    let location: String
}

struct Role: Codable {
    let name: String
    let period: String
    let description: String
}

struct Language: Codable {
    let name: String
    let level: Int
    let description: String
}

struct Education: Codable {
    let title: String
    let institution: String
    let period: String
    let location: String
}

struct Article: Codable {
    // Empty for now as the API returns an empty array
}

class ViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    let profilePhotoView = UIImageView()
    let nameLabel = UILabel()
    let jobTitleLabel = UILabel()
    let contactInfoView = ContactInfoView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // Status bar background view
    let statusBarView = UIView()
    
    // Loading components
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let loadingLabel = UILabel()
    
    // API URL
    let resumeUrl = "https://danielleitelima.github.io/resume/main.json"
    
    // Resume data
    var resumeData: Resume?
    
    // Top Bar components
    let topBarView = UIView()
    let menuButton = UIButton(type: .system)
    let menuOverlay = UIView()
    let menuBackgroundView = UIView()
    let menuStackView = UIStackView()
    let closeButton = UIButton(type: .system)
    var isMenuOpen = false
    var isScrollingProgrammatically = false
    
    // Navigation buttons
    let introButton = SectionButton(title: "Intro", icon: "person.fill")
    let codeButton = SectionButton(title: "Code", icon: "chevron.left.forwardslash.chevron.right")
    let skillsButton = SectionButton(title: "Skills", icon: "wrench.fill")
    let experienceButton = SectionButton(title: "Experience", icon: "chart.line.uptrend.xyaxis")
    let languagesButton = SectionButton(title: "Languages", icon: "text.bubble.fill")
    let educationButton = SectionButton(title: "Education", icon: "book.fill")
    let articlesButton = SectionButton(title: "Articles", icon: "doc.text.fill")
    let contactButton = SectionButton(title: "Contact", icon: "questionmark.circle.fill")
    
    // Resume section views
    let aboutMeSection = ResumeSection(title: "About Me")
    let skillsSection = ResumeSection(title: "Skills")
    let experienceSection = ResumeSection(title: "Experience")
    let educationSection = ResumeSection(title: "Education")
    let languagesSection = ResumeSection(title: "Languages")
    let codeSection = ResumeSection(title: "Code")
    let articlesSection = ResumeSection(title: "Articles")
    let contactSection = ResumeSection(title: "Contact")
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupStatusBarBackground()
        setupLoadingView()
        setupTopBar()
        setupScrollView()
        setupMenuOverlay()

        // Fetch resume data
        fetchResumeData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSelectedButtonForCurrentPosition()
    }
    
    // MARK: - Setup Methods
    func setupStatusBarBackground() {
        view.addSubview(statusBarView)
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Use the same background color as the top bar
        statusBarView.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            statusBarView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loadingView.backgroundColor = UIColor.systemBackground
        
        loadingLabel.text = "Loading resume..."
        loadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loadingLabel.textColor = .secondaryLabel
        loadingLabel.textAlignment = .center
        
        activityIndicator.startAnimating()
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 16),
            loadingLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupTopBar() {
        view.addSubview(topBarView)
        topBarView.addSubview(menuButton)
        
        topBarView.translatesAutoresizingMaskIntoConstraints = false
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Get from hex 1B2023
        topBarView.backgroundColor = .systemGray6
        
        // Configure menu button
        let menuImage = UIImage(systemName: "line.horizontal.3")
        menuButton.setImage(menuImage, for: .normal)
        menuButton.tintColor = .label
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 48),
            
            menuButton.leadingAnchor.constraint(equalTo: topBarView.leadingAnchor, constant: 20),
            menuButton.topAnchor.constraint(equalTo: topBarView.topAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupMenuOverlay() {
        // Add background view first (behind everything)
        view.addSubview(menuBackgroundView)
        menuBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        menuBackgroundView.backgroundColor = UIColor.clear
        menuBackgroundView.isHidden = true
        
        // Add tap gesture to background view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        menuBackgroundView.addGestureRecognizer(tapGesture)
        
        // Setup menu overlay
        view.addSubview(menuOverlay)
        menuOverlay.addSubview(menuStackView)
        menuOverlay.addSubview(closeButton)
        
        menuOverlay.translatesAutoresizingMaskIntoConstraints = false
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Get from hex 1B2023
        menuOverlay.backgroundColor = .systemGray6
        menuOverlay.alpha = 0
        menuOverlay.isHidden = true
        
        // Configure stack view
        menuStackView.axis = .vertical
        menuStackView.spacing = 15
        menuStackView.alignment = .center
        menuStackView.distribution = .equalSpacing
        
        // Add buttons to row stacks
        let topRowStack = UIStackView()
        topRowStack.axis = .horizontal
        topRowStack.spacing = 15
        topRowStack.distribution = .fillEqually
        
        let middleRowStack = UIStackView()
        middleRowStack.axis = .horizontal
        middleRowStack.spacing = 15
        middleRowStack.distribution = .fillEqually
        
        let bottomRowStack = UIStackView()
        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = 15
        bottomRowStack.distribution = .fillEqually
        
        topRowStack.addArrangedSubview(introButton)
        topRowStack.addArrangedSubview(codeButton)
        topRowStack.addArrangedSubview(skillsButton)
        
        middleRowStack.addArrangedSubview(experienceButton)
        middleRowStack.addArrangedSubview(languagesButton)
        
        bottomRowStack.addArrangedSubview(educationButton)
        bottomRowStack.addArrangedSubview(articlesButton)
        
        menuStackView.addArrangedSubview(topRowStack)
        menuStackView.addArrangedSubview(middleRowStack)
        menuStackView.addArrangedSubview(bottomRowStack)
        menuStackView.addArrangedSubview(contactButton)
        
        // Setup close button
        let xImage = UIImage(systemName: "xmark")
        closeButton.setImage(xImage, for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Set up button actions
        introButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        codeButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        skillsButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        experienceButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        languagesButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        educationButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        articlesButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        contactButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        
        // Set constraints for background view
        NSLayoutConstraint.activate([

            menuBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            menuOverlay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuOverlay.heightAnchor.constraint(equalToConstant: 350),
            
            closeButton.topAnchor.constraint(equalTo: menuOverlay.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: menuOverlay.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            
            menuStackView.centerYAnchor.constraint(equalTo: menuOverlay.centerYAnchor, constant: 20),
            menuStackView.leadingAnchor.constraint(equalTo: menuOverlay.leadingAnchor, constant: 20),
            menuStackView.trailingAnchor.constraint(equalTo: menuOverlay.trailingAnchor, constant: -20)
        ])
    }
    
    // MARK: - Data Fetching
    func fetchResumeData() {
        guard let url = URL(string: resumeUrl) else {
            showError("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.showError("Network error: \(error.localizedDescription)")
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.showError("Server error")
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showError("No data received")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let resume = try decoder.decode(Resume.self, from: data)
                self.resumeData = resume
                
                DispatchQueue.main.async {
                    self.setupUI(with: resume)
                    self.hideLoadingView()
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError("Failed to parse data: \(error)")
                }
            }
        }.resume()
    }
    
    func hideLoadingView() {
        UIView.animate(withDuration: 0.3) {
            self.loadingView.alpha = 0
        } completion: { _ in
            self.loadingView.removeFromSuperview()
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingLabel.text = "Error: \(message)"
            self.loadingLabel.textColor = .systemRed
            
            // Add a retry button
            let retryButton = UIButton(type: .system)
            retryButton.setTitle("Retry", for: .normal)
            retryButton.addTarget(self, action: #selector(self.retryButtonTapped), for: .touchUpInside)
            retryButton.translatesAutoresizingMaskIntoConstraints = false
            
            self.loadingView.addSubview(retryButton)
            
            NSLayoutConstraint.activate([
                retryButton.topAnchor.constraint(equalTo: self.loadingLabel.bottomAnchor, constant: 16),
                retryButton.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor)
            ])
        }
    }
    
    @objc func retryButtonTapped() {
        // Reset loading state
        loadingLabel.text = "Loading resume..."
        loadingLabel.textColor = .secondaryLabel
        activityIndicator.startAnimating()
        
        // Remove retry button
        for subview in loadingView.subviews {
            if let button = subview as? UIButton {
                button.removeFromSuperview()
            }
        }
        
        // Retry fetching data
        fetchResumeData()
    }
    
    // MARK: - UI Setup with Resume Data
    func setupUI(with resume: Resume) {
        setupProfileImageView(with: resume.personalData)
        setupNameAndTitle(with: resume.personalData)
        setupContactInfo(with: resume.personalData)
        setupResumeSections(with: resume)
    }
    
    func setupProfileImageView(with personalData: PersonalData) {
        let size: CGFloat = 150

        contentView.addSubview(profilePhotoView)
        
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoView.contentMode = .scaleAspectFill
        profilePhotoView.clipsToBounds = true
        profilePhotoView.layer.cornerRadius = size / 2
        
        // Load profile image from URL
        if let photoURL = URL(string: personalData.photoUrl) {
            downloadImage(from: photoURL, for: profilePhotoView)
        } else {
            profilePhotoView.image = UIImage(named: "profile-photo") // Fallback image
        }
        
        NSLayoutConstraint.activate([
            profilePhotoView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 32 // Added offset for top bar
            ),
            profilePhotoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profilePhotoView.widthAnchor.constraint(equalToConstant: size),
            profilePhotoView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    func downloadImage(from url: URL, for imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
    
    func setupNameAndTitle(with personalData: PersonalData) {
        contentView.addSubview(nameLabel)
        contentView.addSubview(jobTitleLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = personalData.name
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        
        // Convert \n in description to spaces for job title
        let jobTitle = personalData.description.replacingOccurrences(of: "\\n", with: " ")
        jobTitleLabel.text = jobTitle
        jobTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        jobTitleLabel.textColor = .secondaryLabel
        jobTitleLabel.textAlignment = .center
        jobTitleLabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            jobTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            jobTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            jobTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupContactInfo(with personalData: PersonalData) {
        contentView.addSubview(contactInfoView)
        contactInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        // Update contact info with data from API
        contactInfoView.updateContactInfo(
            email: personalData.emailAddress,
            location: personalData.location,
            linkedin: personalData.linkedinUrl,
            github: personalData.githubUrl
        )
        
        NSLayoutConstraint.activate([
            contactInfoView.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 24),
            contactInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupResumeSections(with resume: Resume) {
        // Add new sections
        let allSections = [
            aboutMeSection, 
            codeSection,
            skillsSection, 
            experienceSection, 
            languagesSection,
            educationSection, 
            articlesSection,
            contactSection
        ]
        
        // Add all sections to content view
        allSections.forEach { section in
            contentView.addSubview(section)
            section.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Set content for sections
        aboutMeSection.contentLabel.text = resume.introduction.description
        
        // Format skills
        let skillsText = resume.skills
            .prefix(10) // Limit to first 10 skills to avoid overwhelming
            .map { "• \($0.description)" }
            .joined(separator: "\n")
        skillsSection.contentLabel.text = skillsText
        
        // Format code skills (for now using a subset of skills related to code)
        let codeSkills = resume.skills
            .filter { $0.description.contains("Kotlin") || $0.description.contains("Java") || 
                     $0.description.contains("Android") || $0.description.contains("TypeScript") ||
                     $0.description.contains("JavaScript") || $0.description.contains("HTML") ||
                     $0.description.contains("CSS") || $0.description.contains("Git") }
            .prefix(8)
            .map { "• \($0.description)" }
            .joined(separator: "\n")
        codeSection.contentLabel.text = codeSkills.isEmpty ? "• Experienced developer" : codeSkills
        
        // Format experiences
        var experiencesText = ""
        for experience in resume.experiences {
            experiencesText += "\(experience.company.name) - \(experience.company.location)\n"
            experiencesText += "\(experience.company.period)\n"
            
            for role in experience.roles {
                experiencesText += "• \(role.name) (\(role.period))\n"
                experiencesText += "• \(role.description)\n\n"
            }
        }
        experienceSection.contentLabel.text = experiencesText
        
        // Format languages
        let languagesText = resume.languages
            .map { "• \($0.name) (\($0.description))" }
            .joined(separator: "\n")
        languagesSection.contentLabel.text = languagesText
        
        // Format education
        let educationText = resume.education
            .map { "• \($0.title)\n  \($0.institution)\n  \($0.period)\n  \($0.location)" }
            .joined(separator: "\n\n")
        educationSection.contentLabel.text = educationText
        
        // Format articles (if any)
        articlesSection.contentLabel.text = resume.articles.isEmpty ? 
            "No articles available at this time." : 
            "Articles will be displayed here."
        
        // Contact section
        contactSection.contentLabel.text = """
        Feel free to reach out for job opportunities or collaborations.

        Email: \(resume.personalData.emailAddress)
        Location: \(resume.personalData.location)
        LinkedIn: \(resume.personalData.linkedinUrl)
        GitHub: \(resume.personalData.githubUrl)
        """
        
        // Set up constraints
        NSLayoutConstraint.activate([
            // About Me section
            aboutMeSection.topAnchor.constraint(equalTo: contactInfoView.bottomAnchor, constant: 24),
            aboutMeSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutMeSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Code section
            codeSection.topAnchor.constraint(equalTo: aboutMeSection.bottomAnchor, constant: 20),
            codeSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Skills section
            skillsSection.topAnchor.constraint(equalTo: codeSection.bottomAnchor, constant: 20),
            skillsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            skillsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Experience section
            experienceSection.topAnchor.constraint(equalTo: skillsSection.bottomAnchor, constant: 20),
            experienceSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            experienceSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Languages section
            languagesSection.topAnchor.constraint(equalTo: experienceSection.bottomAnchor, constant: 20),
            languagesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            languagesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Education section
            educationSection.topAnchor.constraint(equalTo: languagesSection.bottomAnchor, constant: 20),
            educationSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            educationSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Articles section
            articlesSection.topAnchor.constraint(equalTo: educationSection.bottomAnchor, constant: 20),
            articlesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articlesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Contact section
            contactSection.topAnchor.constraint(equalTo: articlesSection.bottomAnchor, constant: 20),
            contactSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc func menuButtonTapped() {
        toggleMenu(open: true)
    }
    
    @objc func closeButtonTapped() {
        toggleMenu(open: false)
    }
    
    @objc func sectionButtonTapped(_ sender: SectionButton) {
        // Reset all buttons
        [introButton, codeButton, skillsButton, experienceButton, languagesButton, 
         educationButton, articlesButton, contactButton].forEach { $0.isSelected = false }
        
        // Set selected button
        sender.isSelected = true
        
        // Close menu
        toggleMenu(open: false)
        
        // Handle intro button specially - scroll to top
        if sender == introButton {
            isScrollingProgrammatically = true
            UIView.animate(withDuration: 0.3) {
                self.scrollView.setContentOffset(.zero, animated: false)
            } completion: { _ in
                self.isScrollingProgrammatically = false
            }
            return
        }
        
        // Scroll to appropriate section
        var targetView: UIView?
        
        switch sender {
        case codeButton:
            targetView = codeSection
        case skillsButton:
            targetView = skillsSection
        case experienceButton:
            targetView = experienceSection
        case languagesButton:
            targetView = languagesSection
        case educationButton:
            targetView = educationSection
        case articlesButton:
            targetView = articlesSection
        case contactButton:
            targetView = contactSection
        default:
            break
        }
        
        if let targetView = targetView {
            scrollToView(targetView)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isScrollingProgrammatically {
            updateSelectedButtonForCurrentPosition()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingProgrammatically = false
    }
    
    // MARK: - Helper Methods
    func updateSelectedButtonForCurrentPosition() {
        // Get visible rect
        let visibleRect = CGRect(
            origin: scrollView.contentOffset,
            size: scrollView.bounds.size
        )
        
        // Add offset for top bar
        let visibleRectWithOffset = CGRect(
            x: visibleRect.origin.x,
            y: visibleRect.origin.y + 100, // Account for top bar and partial visibility
            width: visibleRect.width,
            height: visibleRect.height - 150 // Reduce height to check for "fully visible"
        )
        
        // Define sections in order from top to bottom with their corresponding buttons
        let sections: [(view: UIView, button: SectionButton)] = [
            (profilePhotoView, introButton),
            (codeSection, codeButton),
            (skillsSection, skillsButton),
            (experienceSection, experienceButton),
            (languagesSection, languagesButton),
            (educationSection, educationButton),
            (articlesSection, articlesButton),
            (contactSection, contactButton)
        ]
        
        // Reset all buttons
        sections.forEach { _, button in
            button.isSelected = false
        }
        
        // Find the first section that is fully visible
        var selectedSection: SectionButton?
        for (section, button) in sections {
            let sectionFrame = contentView.convert(section.frame, to: scrollView)
            
            // Check if the section is fully visible or at least 50% visible
            if sectionFrame.intersects(visibleRectWithOffset) {
                let visibleArea = sectionFrame.intersection(visibleRectWithOffset).height
                let sectionHeight = sectionFrame.height
                
                // If section is at least 30% visible, select it
                if visibleArea >= (sectionHeight * 0.3) {
                    selectedSection = button
                    break
                }
            }
        }
        
        // If no section is fully visible, select the first visible one
        if selectedSection == nil && sections.count > 0 {
            for (section, button) in sections {
                let sectionFrame = contentView.convert(section.frame, to: scrollView)
                if visibleRect.intersects(sectionFrame) {
                    selectedSection = button
                    break
                }
            }
        }
        
        // Update selected button
        selectedSection?.isSelected = true
    }
    
    func toggleMenu(open: Bool) {
        isMenuOpen = open
        
        // Prepare for animation
        menuOverlay.isHidden = false
        menuBackgroundView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.menuOverlay.alpha = open ? 1.0 : 0.0
        }) { completed in
            if !open {
                self.menuOverlay.isHidden = true
                self.menuBackgroundView.isHidden = true
            }
        }
    }
    
    func scrollToView(_ view: UIView) {
        // Set flag to prevent updateSelectedButtonForCurrentPosition from being called during programmatic scrolling
        isScrollingProgrammatically = true
        
        // Calculate the offset to scroll to view
        let rect = contentView.convert(view.frame, to: scrollView)
        
        // Adjust for top bar height
        var point = CGPoint(x: 0, y: rect.origin.y) // Keep x at 0 to prevent horizontal scrolling
        point.y = max(0, point.y - 70) // Offset for top bar
        
        // Calculate maximum scrollable y-offset to prevent scrolling beyond content
        let maxScrollY = scrollView.contentSize.height - scrollView.bounds.height
        
        // Ensure we don't scroll beyond the maximum allowable point
        if maxScrollY > 0 {
            point.y = min(point.y, maxScrollY)
        }
        
        // Animate scrolling
        UIView.animate(withDuration: 0.3) {
            self.scrollView.setContentOffset(point, animated: false)
        } completion: { _ in
            self.isScrollingProgrammatically = false
        }
    }
}

// MARK: - SectionButton
class SectionButton: UIButton {
    private let iconImageView = UIImageView()
    private let customTitleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    init(title: String, icon: String) {
        super.init(frame: .zero)
        
        // Setup button appearance
        self.layer.cornerRadius = 20
        
        // Configure icon
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = .label
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure title
        customTitleLabel.text = title
        customTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customTitleLabel.textColor = .label
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to hierarchy
        self.addSubview(iconImageView)
        self.addSubview(customTitleLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 40),
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            customTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            customTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            customTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Initial appearance
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.2) {
            if self.isSelected {
                self.backgroundColor = .systemGray4
                self.layer.borderWidth = 0
                self.iconImageView.tintColor = .label
                self.customTitleLabel.textColor = .label
            } else {
                self.backgroundColor = .clear
                self.layer.borderWidth = 1
                // Use systemGray instead of .label for border color to ensure visibility in dark mode
                self.layer.borderColor = UIColor.systemGray.cgColor
                self.iconImageView.tintColor = .label
                self.customTitleLabel.textColor = .label
            }
        }
    }
    
    // Make sure appearance updates when trait collection changes (light/dark mode)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateAppearance()
        }
    }
}

// Custom view for contact information
class ContactInfoView: UIView {
    private let stackView = UIStackView()
    private let emailLabel = UILabel()
    private let locationLabel = UILabel()
    private let linkedinLabel = UILabel()
    private let githubLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Configure stack view
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure labels
        [emailLabel, locationLabel, linkedinLabel, githubLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .systemGray
            label.textAlignment = .center
        }
        
        // Add to view hierarchy
        addSubview(stackView)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(linkedinLabel)
        stackView.addArrangedSubview(githubLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Method to update contact information with data from API
    func updateContactInfo(email: String, location: String, linkedin: String, github: String) {
        emailLabel.text = email
        locationLabel.text = location
        linkedinLabel.text = linkedin
        githubLabel.text = github
    }
}

// Custom view for resume sections
class ResumeSection: UIView {
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let dividerLine = UIView()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Configure title label
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure divider line
        dividerLine.backgroundColor = .systemGray4
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure content label
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view hierarchy
        addSubview(titleLabel)
        addSubview(dividerLine)
        addSubview(contentLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dividerLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dividerLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            contentLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#Preview {
    ViewController()
}