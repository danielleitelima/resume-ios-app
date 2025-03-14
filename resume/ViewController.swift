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

// New model for code samples
struct CodeSample: Codable {
    let ID: String
    let Name: String
    let Description: String
    let InputSchema: String
    let ThumbnailURL: String
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
    let resumeUrl = "https://api.danielleitelima.com/getResume"
    let codeSamplesUrl = "https://api.danielleitelima.com/getCodeSamples"
    
    // Resume data
    var resumeData: Resume?
    var codeSamples: [CodeSample] = []
    
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
    let articlesButton = SectionButton(title: "Articles", icon: "doc.fill")
    let contactButton = SectionButton(title: "Contact", icon: "questionmark.circle.fill")
    
    // Resume section views
    let aboutMeSection = ResumeSection(title: "About Me")
    let codeSamplesSection = ResumeSection(title: "Code Samples")
    let skillsSection = ResumeSection(title: "Skills")
    let experienceSection = ResumeSection(title: "Experience")
    let educationSection = ResumeSection(title: "Education")
    let languagesSection = ResumeSection(title: "Languages")
    let contactSection = ResumeSection(title: "Contact")
    
    // Code samples carousel
    let codeSamplesCarouselView = UIScrollView()
    let codeSamplesStackView = UIStackView()
    
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
        
        middleRowStack.addArrangedSubview(skillsButton)
        middleRowStack.addArrangedSubview(experienceButton)
        
        bottomRowStack.addArrangedSubview(languagesButton)
        bottomRowStack.addArrangedSubview(educationButton)
        
        menuStackView.addArrangedSubview(topRowStack)
        menuStackView.addArrangedSubview(middleRowStack)
        menuStackView.addArrangedSubview(bottomRowStack)
        
        // Setup close button
        let xImage = UIImage(systemName: "xmark")
        closeButton.setImage(xImage, for: .normal)
        closeButton.tintColor = .label
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Set up button actions
        introButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        codeButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        skillsButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        experienceButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        languagesButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        educationButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
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
            menuOverlay.heightAnchor.constraint(equalToConstant: 248),
            
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
                
                // After fetching resume data, fetch code samples
                self.fetchCodeSamples()
                
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
    
    // New method to fetch code samples
    func fetchCodeSamples() {
        guard let url = URL(string: codeSamplesUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching code samples: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Server error when fetching code samples")
                return
            }
            
            guard let data = data else {
                print("No code samples data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let samples = try decoder.decode([CodeSample].self, from: data)
                self.codeSamples = samples
                
                DispatchQueue.main.async {
                    self.setupCodeSamplesCarousel()
                }
            } catch {
                print("Failed to parse code samples: \(error)")
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
            codeSamplesSection,
            skillsSection, 
            experienceSection, 
            languagesSection,
            educationSection, 
            contactSection
        ]
        
        // Add all sections to content view
        allSections.forEach { section in
            contentView.addSubview(section)
            section.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Set content for sections
        aboutMeSection.contentLabel.text = resume.introduction.description
        
        // Setup code samples carousel container
        setupCodeSamplesContainer()
        
        // Format skills
        let skillsText = resume.skills
            .prefix(10) // Limit to first 10 skills to avoid overwhelming
            .map { "• \($0.description)" }
            .joined(separator: "\n")
        skillsSection.contentLabel.text = skillsText
        
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
            
            // Code Samples section
            codeSamplesSection.topAnchor.constraint(equalTo: aboutMeSection.bottomAnchor, constant: 20),
            codeSamplesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeSamplesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Skills section
            skillsSection.topAnchor.constraint(equalTo: codeSamplesSection.bottomAnchor, constant: 20),
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
            
            // Contact section
            contactSection.topAnchor.constraint(equalTo: educationSection.bottomAnchor, constant: 20),
            contactSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // Setup container for code samples carousel
    func setupCodeSamplesContainer() {
        // Remove content label from code samples section
        codeSamplesSection.contentLabel.removeFromSuperview()
        
        // Add carousel scroll view to code samples section
        codeSamplesSection.addSubview(codeSamplesCarouselView)
        codeSamplesCarouselView.translatesAutoresizingMaskIntoConstraints = false
        codeSamplesCarouselView.showsHorizontalScrollIndicator = false
        codeSamplesCarouselView.showsVerticalScrollIndicator = false
        
        // Add stack view to carousel
        codeSamplesCarouselView.addSubview(codeSamplesStackView)
        codeSamplesStackView.translatesAutoresizingMaskIntoConstraints = false
        codeSamplesStackView.axis = .horizontal
        codeSamplesStackView.spacing = 15
        codeSamplesStackView.alignment = .center
        
        // Set constraints
        NSLayoutConstraint.activate([
            codeSamplesCarouselView.topAnchor.constraint(equalTo: codeSamplesSection.dividerLine.bottomAnchor, constant: 12),
            codeSamplesCarouselView.leadingAnchor.constraint(equalTo: codeSamplesSection.leadingAnchor),
            codeSamplesCarouselView.trailingAnchor.constraint(equalTo: codeSamplesSection.trailingAnchor),
            codeSamplesCarouselView.heightAnchor.constraint(equalToConstant: 180),
            codeSamplesCarouselView.bottomAnchor.constraint(equalTo: codeSamplesSection.bottomAnchor),
            
            codeSamplesStackView.topAnchor.constraint(equalTo: codeSamplesCarouselView.topAnchor),
            codeSamplesStackView.leadingAnchor.constraint(equalTo: codeSamplesCarouselView.leadingAnchor, constant: 10),
            codeSamplesStackView.trailingAnchor.constraint(equalTo: codeSamplesCarouselView.trailingAnchor, constant: -10),
            codeSamplesStackView.heightAnchor.constraint(equalTo: codeSamplesCarouselView.heightAnchor)
        ])
        
        // Add a placeholder message if no code samples are available yet
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Loading code samples..."
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        codeSamplesCarouselView.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: codeSamplesCarouselView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: codeSamplesCarouselView.centerYAnchor)
        ])
    }
    
    // Setup code samples carousel with data from API
    func setupCodeSamplesCarousel() {
        // Remove all existing cards
        codeSamplesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Remove placeholder label if it exists
        for subview in codeSamplesCarouselView.subviews {
            if let label = subview as? UILabel {
                label.removeFromSuperview()
            }
        }
        
        if codeSamples.isEmpty {
            // Show "No code samples available" message
            let emptyLabel = UILabel()
            emptyLabel.text = "No code samples available"
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            
            codeSamplesCarouselView.addSubview(emptyLabel)
            
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: codeSamplesCarouselView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: codeSamplesCarouselView.centerYAnchor)
            ])
            return
        }
        
        // Add code sample cards
        for sample in codeSamples {
            let card = CodeSampleCard(sample: sample)
            
            // Set tap handler for the card
            card.tapHandler = { [weak self] in
                guard let self = self, let sample = card.sample else { return }
                self.showCodeSampleDetail(sample)
            }
            
            codeSamplesStackView.addArrangedSubview(card)
            
            // Set fixed width for each card
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 200)
            ])
        }
        
        // Update content size for horizontal scrolling
        codeSamplesCarouselView.contentSize = CGSize(
            width: CGFloat(codeSamples.count) * (200 + 15) + 20, // card width + spacing + padding
            height: codeSamplesCarouselView.frame.height
        )
    }
    
    // Navigate to code sample detail screen
    func showCodeSampleDetail(_ sample: CodeSample) {
        let detailVC = CodeSampleDetailViewController(sample: sample)
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
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
         educationButton, contactButton].forEach { $0.isSelected = false }
        
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
            targetView = codeSamplesSection
        case skillsButton:
            targetView = skillsSection
        case experienceButton:
            targetView = experienceSection
        case languagesButton:
            targetView = languagesSection
        case educationButton:
            targetView = educationSection
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
            (codeSamplesSection, codeButton),
            (skillsSection, skillsButton),
            (experienceSection, experienceButton),
            (languagesSection, languagesButton),
            (educationSection, educationButton),
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

// MARK: - CodeSampleCard
class CodeSampleCard: UIView {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    var sample: CodeSample?
    var tapHandler: (() -> Void)?
    
    init(sample: CodeSample) {
        self.sample = sample
        super.init(frame: .zero)
        setupView()
        configure(with: sample)
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupTapGesture()
    }
    
    private func setupView() {
        // Card appearance
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        clipsToBounds = true
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        // Configure thumbnail
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .systemGray5
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view hierarchy
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 160),
            
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)
        ])
    }
    
    private func setupTapGesture() {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func cardTapped() {
        tapHandler?()
    }
    
    func configure(with sample: CodeSample) {
        self.sample = sample
        titleLabel.text = sample.Name
        descriptionLabel.text = sample.Description
        
        // Load thumbnail image
        if let thumbnailURL = URL(string: sample.ThumbnailURL) {
            URLSession.shared.dataTask(with: thumbnailURL) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error loading thumbnail: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.setPlaceholderImage()
                    }
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data received")
                    DispatchQueue.main.async {
                        self.setPlaceholderImage()
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }.resume()
        } else {
            // Set placeholder image if URL is invalid
            setPlaceholderImage()
        }
    }
    
    private func setPlaceholderImage() {
        // Set placeholder image
        thumbnailImageView.image = UIImage(systemName: "doc.text.fill")
        thumbnailImageView.tintColor = .systemGray3
        thumbnailImageView.contentMode = .scaleAspectFit
        thumbnailImageView.backgroundColor = .systemGray6
    }
}

#Preview {
    ViewController()
}

// MARK: - CodeSampleDetailViewController
class CodeSampleDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let sample: CodeSample
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let inputFormStackView = UIStackView()
    private let runButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    // Dictionary to store input fields and their values
    private var inputFields: [String: UIView] = [:]
    private var inputSchema: [String: Any] = [:]
    
    // MARK: - Initialization
    init(sample: CodeSample) {
        self.sample = sample
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Code Sample"
        
        // Add close button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        setupUI()
        parseInputSchema()
        setupInputForm()
    }
    
    // Remove any duplicate viewDidLayoutSubviews or updateCodeScrollViewContentSizes methods here
    // ...
    
    // MARK: - UI Setup
    private func setupUI() {
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Setup title label
        titleLabel.text = sample.Name
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup description label
        descriptionLabel.text = sample.Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup input form stack view
        inputFormStackView.axis = .vertical
        inputFormStackView.spacing = 16
        inputFormStackView.alignment = .fill
        inputFormStackView.distribution = .fill
        inputFormStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup run button
        runButton.setTitle("Run Code Sample", for: .normal)
        runButton.backgroundColor = .systemBlue
        runButton.setTitleColor(.white, for: .normal)
        runButton.layer.cornerRadius = 10
        runButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        runButton.translatesAutoresizingMaskIntoConstraints = false
        runButton.addTarget(self, action: #selector(runButtonTapped), for: .touchUpInside)
        
        // Setup result label
        resultLabel.text = "Result will appear here"
        resultLabel.font = UIFont.systemFont(ofSize: 16)
        resultLabel.textColor = .secondaryLabel
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.isHidden = true
        
        // Setup loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        // Add subviews to content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(inputFormStackView)
        contentView.addSubview(runButton)
        contentView.addSubview(resultLabel)
        contentView.addSubview(loadingIndicator)
        
        // Set constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            inputFormStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            inputFormStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            inputFormStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            runButton.topAnchor.constraint(equalTo: inputFormStackView.bottomAnchor, constant: 32),
            runButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            runButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            runButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: runButton.bottomAnchor, constant: 24),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: resultLabel.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: resultLabel.centerYAnchor)
        ])
    }
    
    // MARK: - Input Schema Parsing
    private func parseInputSchema() {
        guard let jsonData = sample.InputSchema.data(using: .utf8) else {
            showAlert(title: "Error", message: "Invalid input schema format")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                // Create a modified schema that correctly identifies boolean types
                var modifiedSchema: [String: Any] = [:]
                
                for (key, value) in json {
                    if key.lowercased().contains("bool") {
                        // If the key contains "bool", treat it as a boolean regardless of how it was parsed
                        modifiedSchema[key] = (value as? NSNumber)?.boolValue ?? false
                    } else {
                        modifiedSchema[key] = value
                    }
                }
                
                inputSchema = modifiedSchema
                
                // Print the schema for debugging
                print("Input Schema: \(inputSchema)")
            }
        } catch {
            showAlert(title: "Error", message: "Failed to parse input schema: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Input Form Setup
    private func setupInputForm() {
        // Add a section title
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.text = "Input Parameters"
        sectionTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        sectionTitleLabel.textColor = .label
        inputFormStackView.addArrangedSubview(sectionTitleLabel)
        
        // Add a separator
        let separator = UIView()
        separator.backgroundColor = .systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        inputFormStackView.addArrangedSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Add input fields based on the schema
        for (key, value) in inputSchema {
            let fieldContainer = UIView()
            fieldContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let fieldLabel = UILabel()
            fieldLabel.text = key
            fieldLabel.font = UIFont.systemFont(ofSize: 16)
            fieldLabel.translatesAutoresizingMaskIntoConstraints = false
            
            fieldContainer.addSubview(fieldLabel)
            
            // First check if it's a boolean field by name
            if key.lowercased().contains("bool") {
                // Boolean input - use a toggle/switch
                let switchControl = UISwitch()
                // Convert value to boolean (default to false if conversion fails)
                let boolValue = (value as? Bool) ?? (value as? NSNumber)?.boolValue ?? false
                switchControl.isOn = boolValue
                switchControl.translatesAutoresizingMaskIntoConstraints = false
                
                // Add a value label to show current state
                let valueLabel = UILabel()
                valueLabel.text = boolValue ? "Yes" : "No"
                valueLabel.font = UIFont.systemFont(ofSize: 14)
                valueLabel.textColor = .secondaryLabel
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                
                // Update value label when switch changes
                switchControl.addAction(UIAction { action in
                    let isOn = switchControl.isOn
                    valueLabel.text = isOn ? "Yes" : "No"
                }, for: .valueChanged)
                
                fieldContainer.addSubview(switchControl)
                fieldContainer.addSubview(valueLabel)
                inputFields[key] = switchControl
                
                NSLayoutConstraint.activate([
                    fieldLabel.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    
                    valueLabel.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    valueLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -8),
                    
                    switchControl.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    switchControl.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    fieldContainer.heightAnchor.constraint(equalToConstant: 50)
                ])
            }
            // Then check other types
            else if let stringValue = value as? String {
                // String input
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter text"
                textField.text = stringValue // Set default value
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                fieldContainer.addSubview(textField)
                inputFields[key] = textField
                
                NSLayoutConstraint.activate([
                    fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    textField.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8),
                    textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
                ])
                
            } else if let intValue = value as? Int {
                // Number input
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter number"
                textField.keyboardType = .numberPad
                textField.text = "\(intValue)" // Set default value
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                fieldContainer.addSubview(textField)
                inputFields[key] = textField
                
                NSLayoutConstraint.activate([
                    fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    textField.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8),
                    textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
                ])
                
            } else if let doubleValue = value as? Double {
                // Float input
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter decimal number"
                textField.keyboardType = .decimalPad
                textField.text = "\(doubleValue)" // Set default value
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                fieldContainer.addSubview(textField)
                inputFields[key] = textField
                
                NSLayoutConstraint.activate([
                    fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    textField.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8),
                    textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
                ])
                
            } else if let boolValue = value as? Bool {
                // Boolean input - use a toggle/switch
                let switchControl = UISwitch()
                switchControl.isOn = boolValue
                switchControl.translatesAutoresizingMaskIntoConstraints = false
                
                // Add a value label to show current state
                let valueLabel = UILabel()
                valueLabel.text = boolValue ? "Yes" : "No"
                valueLabel.font = UIFont.systemFont(ofSize: 14)
                valueLabel.textColor = .secondaryLabel
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                
                // Update value label when switch changes
                switchControl.addAction(UIAction { action in
                    let isOn = switchControl.isOn
                    valueLabel.text = isOn ? "Yes" : "No"
                }, for: .valueChanged)
                
                fieldContainer.addSubview(switchControl)
                fieldContainer.addSubview(valueLabel)
                inputFields[key] = switchControl
                
                NSLayoutConstraint.activate([
                    fieldLabel.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    
                    valueLabel.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    valueLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor, constant: -8),
                    
                    switchControl.centerYAnchor.constraint(equalTo: fieldContainer.centerYAnchor),
                    switchControl.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    fieldContainer.heightAnchor.constraint(equalToConstant: 50)
                ])
            } else {
                // For any other type, add a label showing the type is not supported
                let typeLabel = UILabel()
                typeLabel.text = "Unsupported type: \(type(of: value))"
                typeLabel.font = UIFont.systemFont(ofSize: 14)
                typeLabel.textColor = .systemRed
                typeLabel.translatesAutoresizingMaskIntoConstraints = false
                
                fieldContainer.addSubview(typeLabel)
                
                NSLayoutConstraint.activate([
                    fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
                    fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    
                    typeLabel.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8),
                    typeLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                    typeLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                    typeLabel.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
                ])
            }
            
            inputFormStackView.addArrangedSubview(fieldContainer)
        }
        
        // Add a note about the example fields
        if inputSchema.keys.contains(where: { $0.hasPrefix("Example") }) {
            let noteLabel = UILabel()
            noteLabel.text = "Note: Fields starting with 'Example' are for demonstration purposes."
            noteLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noteLabel.textColor = .secondaryLabel
            noteLabel.numberOfLines = 0
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            inputFormStackView.addArrangedSubview(noteLabel)
        }
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func runButtonTapped() {
        // Hide keyboard
        view.endEditing(true)
        
        // Validate input fields
        if !validateInputFields() {
            return
        }
        
        // Show loading indicator
        resultLabel.isHidden = true
        loadingIndicator.startAnimating()
        
        // Collect input values
        var inputValues: [String: Any] = [:]
        
        for (key, inputField) in inputFields {
            if let textField = inputField as? UITextField, let originalValue = inputSchema[key] {
                if originalValue is Int {
                    // Convert to Int
                    if let text = textField.text, !text.isEmpty, let intValue = Int(text) {
                        inputValues[key] = intValue
                    } else {
                        inputValues[key] = 0 // Default value
                    }
                } else if originalValue is Double {
                    // Convert to Double
                    if let text = textField.text, !text.isEmpty, let doubleValue = Double(text) {
                        inputValues[key] = doubleValue
                    } else {
                        inputValues[key] = 0.0 // Default value
                    }
                } else {
                    // String value
                    inputValues[key] = textField.text ?? ""
                }
            } else if let switchControl = inputField as? UISwitch {
                // Boolean value from switch
                inputValues[key] = switchControl.isOn
            } else {
                // Handle any other type of input field
                print("Unhandled input field type for key: \(key)")
            }
        }
        
        // Make API request
        runCodeSample(sampleId: sample.ID, input: inputValues)
    }
    
    // Validate input fields
    private func validateInputFields() -> Bool {
        var isValid = true
        var errorMessage = ""
        
        for (key, inputField) in inputFields {
            if let textField = inputField as? UITextField, let originalValue = inputSchema[key] {
                if originalValue is Int {
                    // Validate integer
                    if let text = textField.text, !text.isEmpty {
                        if Int(text) == nil {
                            isValid = false
                            errorMessage = "'\(key)' must be a valid integer."
                            textField.layer.borderColor = UIColor.systemRed.cgColor
                            textField.layer.borderWidth = 1
                            break
                        } else {
                            textField.layer.borderWidth = 0
                        }
                    }
                } else if originalValue is Double {
                    // Validate double
                    if let text = textField.text, !text.isEmpty {
                        if Double(text) == nil {
                            isValid = false
                            errorMessage = "'\(key)' must be a valid decimal number."
                            textField.layer.borderColor = UIColor.systemRed.cgColor
                            textField.layer.borderWidth = 1
                            break
                        } else {
                            textField.layer.borderWidth = 0
                        }
                    }
                } else if originalValue is String {
                    // No specific validation for strings
                    textField.layer.borderWidth = 0
                }
            }
        }
        
        if !isValid {
            showAlert(title: "Validation Error", message: errorMessage)
        }
        
        return isValid
    }
    
    // MARK: - API Request
    private func runCodeSample(sampleId: String, input: [String: Any]) {
        // Prepare request
        guard let url = URL(string: "https://api.danielleitelima.com/runCodeSample") else {
            showResult(success: false, message: "Invalid API URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let requestBody: [String: Any] = [
            "sampleId": sampleId,
            "input": input
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            showResult(success: false, message: "Failed to create request: \(error.localizedDescription)")
            return
        }
        
        // Make request
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                self.resultLabel.isHidden = false
                
                if let error = error {
                    self.showResult(success: false, message: "Network error: \(error.localizedDescription)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showResult(success: false, message: "Invalid response")
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    self.showResult(success: false, message: "Server error: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else {
                    self.showResult(success: false, message: "No data received")
                    return
                }
                
                // Parse and display result
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let result = json["result"] as? String {
                            // Show simple result in the label
                            self.showResult(success: true, message: result)
                        } else if let sourceCode = json["sourceCode"] as? String,
                                  let output = json["output"] as? String,
                                  let duration = json["duration"] as? String {
                            // We have a detailed code result - show in a new screen
                            let logs = json["log"] as? [String] ?? []
                            
                            // Create and present the result view controller
                            let resultVC = CodeResultViewController(
                                sourceCode: sourceCode,
                                output: output,
                                duration: duration,
                                logs: logs
                            )
                            let navController = UINavigationController(rootViewController: resultVC)
                            self.present(navController, animated: true)
                            
                            // Hide the result label since we're showing a new screen
                            self.resultLabel.isHidden = true
                        } else {
                            let resultString = String(data: data, encoding: .utf8) ?? "Unknown result format"
                            self.showResult(success: true, message: resultString)
                        }
                    } else {
                        let resultString = String(data: data, encoding: .utf8) ?? "Unknown result format"
                        self.showResult(success: true, message: resultString)
                    }
                } catch {
                    self.showResult(success: false, message: "Failed to parse result: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // MARK: - Helper Methods
    private func showResult(success: Bool, message: String) {
        if success {
            resultLabel.text = message
            resultLabel.textColor = .systemGreen
            resultLabel.isHidden = false
        } else {
            // Show error alert for unsuccessful results
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            // Also update the result label as a fallback
            resultLabel.text = "Error: " + message
            resultLabel.textColor = .systemRed
            resultLabel.isHidden = false
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CodeResultViewController
class CodeResultViewController: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let outputTitleLabel = UILabel()
    private let outputValueLabel = UILabel()
    private let durationTitleLabel = UILabel()
    private let durationValueLabel = UILabel()
    private let logsTitleLabel = UILabel()
    private let logsStackView = UIStackView()
    private let sourceCodeTitleLabel = UILabel()
    private let sourceCodeView = UIView()
    
    private let sourceCode: String
    private let output: String
    private let duration: String
    private let logs: [String]
    
    // MARK: - Initialization
    init(sourceCode: String, output: String, duration: String, logs: [String]) {
        self.sourceCode = sourceCode
        self.output = output
        self.duration = duration
        self.logs = logs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Code Execution Result"
        
        // Add close button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        setupUI()
        populateData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update content size for all horizontal scroll views in the code view
        updateCodeScrollViewContentSizes()
    }
    
    // Helper method to update scroll view content sizes
    private func updateCodeScrollViewContentSizes() {
        // Find all scroll views in the source code view
        sourceCodeView.subviews.forEach { container in
            container.subviews.forEach { view in
                if let stackView = view as? UIStackView {
                    for case let lineContainer as UIView in stackView.arrangedSubviews {
                        for case let scrollView as UIScrollView in lineContainer.subviews {
                            // For each scroll view, find its content
                            if let lineView = scrollView.subviews.first,
                               let codeLabel = lineView.subviews.first as? UILabel {
                                
                                // Calculate the width needed for the content
                                let labelSize = codeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: codeLabel.frame.height))
                                let contentWidth = max(labelSize.width, 500)
                                
                                // Update the line view width
                                for constraint in lineView.constraints {
                                    if constraint.firstAttribute == .width {
                                        constraint.constant = contentWidth
                                    }
                                }
                                
                                // Set the content size to accommodate the full width of the code
                                scrollView.contentSize = CGSize(
                                    width: contentWidth,
                                    height: scrollView.frame.height
                                )
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Setup scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Setup section title styles
        [outputTitleLabel, durationTitleLabel, logsTitleLabel, sourceCodeTitleLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = .label
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Setup value label styles
        [outputValueLabel, durationValueLabel].forEach { label in
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .label
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Setup section titles
        outputTitleLabel.text = "Output"
        durationTitleLabel.text = "Execution Time"
        logsTitleLabel.text = "Logs"
        sourceCodeTitleLabel.text = "Source Code"
        
        // Setup logs stack view
        logsStackView.axis = .vertical
        logsStackView.spacing = 8
        logsStackView.alignment = .fill
        logsStackView.distribution = .equalSpacing
        logsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup source code view
        sourceCodeView.backgroundColor = .systemGray6
        sourceCodeView.layer.cornerRadius = 8
        sourceCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all views to content view
        contentView.addSubview(outputTitleLabel)
        contentView.addSubview(outputValueLabel)
        contentView.addSubview(durationTitleLabel)
        contentView.addSubview(durationValueLabel)
        contentView.addSubview(logsTitleLabel)
        contentView.addSubview(logsStackView)
        contentView.addSubview(sourceCodeTitleLabel)
        contentView.addSubview(sourceCodeView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Output section
            outputTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            outputTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outputTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            outputValueLabel.topAnchor.constraint(equalTo: outputTitleLabel.bottomAnchor, constant: 8),
            outputValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outputValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Duration section
            durationTitleLabel.topAnchor.constraint(equalTo: outputValueLabel.bottomAnchor, constant: 20),
            durationTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            durationValueLabel.topAnchor.constraint(equalTo: durationTitleLabel.bottomAnchor, constant: 8),
            durationValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            durationValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Logs section
            logsTitleLabel.topAnchor.constraint(equalTo: durationValueLabel.bottomAnchor, constant: 20),
            logsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            logsStackView.topAnchor.constraint(equalTo: logsTitleLabel.bottomAnchor, constant: 8),
            logsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Source code section
            sourceCodeTitleLabel.topAnchor.constraint(equalTo: logsStackView.bottomAnchor, constant: 20),
            sourceCodeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sourceCodeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            sourceCodeView.topAnchor.constraint(equalTo: sourceCodeTitleLabel.bottomAnchor, constant: 8),
            sourceCodeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sourceCodeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sourceCodeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            sourceCodeView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    // MARK: - Data Population
    private func populateData() {
        // Set output value
        outputValueLabel.text = output
        
        // Set duration value
        durationValueLabel.text = duration
        
        // Add log entries
        if logs.isEmpty {
            let emptyLogLabel = UILabel()
            emptyLogLabel.text = "No logs available"
            emptyLogLabel.font = UIFont.systemFont(ofSize: 14)
            emptyLogLabel.textColor = .secondaryLabel
            emptyLogLabel.translatesAutoresizingMaskIntoConstraints = false
            logsStackView.addArrangedSubview(emptyLogLabel)
        } else {
            for (index, log) in logs.enumerated() {
                let logLabel = UILabel()
                logLabel.text = "\(index + 1). \(log)"
                logLabel.font = UIFont.systemFont(ofSize: 14)
                logLabel.textColor = .label
                logLabel.numberOfLines = 0
                logsStackView.addArrangedSubview(logLabel)
            }
        }
        
        // Setup source code with syntax highlighting
        setupSourceCodeView()
    }
    
    // MARK: - Source Code View Setup
    private func setupSourceCodeView() {
        // Create a container for the code
        let codeContainer = UIView()
        codeContainer.translatesAutoresizingMaskIntoConstraints = false
        sourceCodeView.addSubview(codeContainer)
        
        // Create a single horizontal scroll view for all code
        let codeScrollView = UIScrollView()
        codeScrollView.showsHorizontalScrollIndicator = true
        codeScrollView.showsVerticalScrollIndicator = false
        codeScrollView.translatesAutoresizingMaskIntoConstraints = false
        codeScrollView.alwaysBounceHorizontal = true
        codeContainer.addSubview(codeScrollView)
        
        // Create a content view for the scroll view
        let scrollContentView = UIView()
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        codeScrollView.addSubview(scrollContentView)
        
        // Split the source code into lines
        let codeLines = sourceCode.components(separatedBy: .newlines)
        
        // Create a stack view for the code lines
        let codeStackView = UIStackView()
        codeStackView.axis = .vertical
        codeStackView.spacing = 2
        codeStackView.alignment = .fill
        codeStackView.distribution = .equalSpacing
        codeStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(codeStackView)
        
        // Set up constraints for the scroll view and its content
        NSLayoutConstraint.activate([
            codeScrollView.topAnchor.constraint(equalTo: codeContainer.topAnchor),
            codeScrollView.leadingAnchor.constraint(equalTo: codeContainer.leadingAnchor),
            codeScrollView.trailingAnchor.constraint(equalTo: codeContainer.trailingAnchor),
            codeScrollView.bottomAnchor.constraint(equalTo: codeContainer.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: codeScrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: codeScrollView.leadingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: codeScrollView.bottomAnchor),
            // Don't constrain trailing to allow content to be wider than the scroll view
            scrollContentView.heightAnchor.constraint(equalTo: codeScrollView.heightAnchor),
            
            codeStackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            codeStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            codeStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            codeStackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
        ])
        
        // Track the maximum content width needed
        var maxContentWidth: CGFloat = 0
        
        // Add each line with line number and syntax highlighting
        for (index, line) in codeLines.enumerated() {
            // Line container to hold number and code
            let lineContainer = UIView()
            lineContainer.translatesAutoresizingMaskIntoConstraints = false
            
            // Line number label
            let lineNumberLabel = UILabel()
            lineNumberLabel.text = "\(index + 1)"
            lineNumberLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
            lineNumberLabel.textColor = .secondaryLabel
            lineNumberLabel.textAlignment = .right
            lineNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Code content label with syntax highlighting
            let codeLabel = UILabel()
            codeLabel.attributedText = applySyntaxHighlighting(to: preserveIndentation(in: line))
            codeLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
            codeLabel.numberOfLines = 1
            codeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add views to container
            lineContainer.addSubview(lineNumberLabel)
            lineContainer.addSubview(codeLabel)
            
            // Set constraints for the line components
            NSLayoutConstraint.activate([
                lineNumberLabel.leadingAnchor.constraint(equalTo: lineContainer.leadingAnchor),
                lineNumberLabel.topAnchor.constraint(equalTo: lineContainer.topAnchor),
                lineNumberLabel.bottomAnchor.constraint(equalTo: lineContainer.bottomAnchor),
                lineNumberLabel.widthAnchor.constraint(equalToConstant: 30),
                
                codeLabel.leadingAnchor.constraint(equalTo: lineNumberLabel.trailingAnchor, constant: 8),
                codeLabel.topAnchor.constraint(equalTo: lineContainer.topAnchor),
                codeLabel.bottomAnchor.constraint(equalTo: lineContainer.bottomAnchor),
                // Don't constrain trailing to allow content to extend
            ])
            
            // Add the line container to the stack view
            codeStackView.addArrangedSubview(lineContainer)
            
            // Calculate the width needed for this line
            let labelSize = codeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: codeLabel.frame.height))
            let lineWidth = 30 + 8 + labelSize.width + 20 // line number + spacing + code width + padding
            
            // Update max content width if this line is wider
            maxContentWidth = max(maxContentWidth, lineWidth)
        }
        
        // Set the width of the scroll content view
        scrollContentView.widthAnchor.constraint(equalToConstant: max(maxContentWidth, 500)).isActive = true
        
        // Set content size for horizontal scrolling
        codeScrollView.layoutIfNeeded()
        codeScrollView.contentSize = CGSize(width: max(maxContentWidth, 500), height: codeScrollView.frame.height)
        
        // Set constraints for the container
        NSLayoutConstraint.activate([
            codeContainer.topAnchor.constraint(equalTo: sourceCodeView.topAnchor, constant: 12),
            codeContainer.leadingAnchor.constraint(equalTo: sourceCodeView.leadingAnchor, constant: 12),
            codeContainer.trailingAnchor.constraint(equalTo: sourceCodeView.trailingAnchor, constant: -12),
            codeContainer.bottomAnchor.constraint(equalTo: sourceCodeView.bottomAnchor, constant: -12)
        ])
        
        // Set a height constraint for the source code view to ensure it has a proper size
        sourceCodeView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true
    }
    
    // Helper method to preserve indentation in code
    private func preserveIndentation(in line: String) -> String {
        // Replace leading tabs with spaces (4 spaces per tab)
        var result = line
        while result.hasPrefix("\t") {
            result = "    " + result.dropFirst()
        }
        return result
    }
    
    // MARK: - Syntax Highlighting
    private func applySyntaxHighlighting(to line: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: line)
        let nsString = line as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        
        // Define colors for different syntax elements
        let keywordColor = UIColor.systemBlue
        let stringColor = UIColor.systemGreen
        let commentColor = UIColor.systemGray
        let functionColor = UIColor.systemPurple
        let numberColor = UIColor.systemOrange
        let operatorColor = UIColor.systemRed
        
        // Define Go keywords
        let keywords = ["func", "var", "const", "type", "struct", "interface", "map", "chan", "package", "import", 
                        "if", "else", "for", "range", "switch", "case", "default", "break", "continue", "return",
                        "go", "defer", "select", "goto", "fallthrough", "nil", "true", "false", "string", "int", 
                        "bool", "float", "byte", "rune", "uint", "int8", "int16", "int32", "int64", "uint8", 
                        "uint16", "uint32", "uint64", "float32", "float64", "complex64", "complex128", "len"]
        
        // Highlight comments first (they take precedence)
        do {
            let commentPattern = "//.*$"
            let regex = try NSRegularExpression(pattern: commentPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: fullRange)
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: commentColor, range: match.range)
                attributedString.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: 12, weight: .regular), range: match.range)
                
                // If we have a comment, we can skip other highlighting for the commented part
                if match.range.location == 0 && match.range.length == line.count {
                    return attributedString
                }
            }
        } catch {
            print("Error highlighting comments: \(error)")
        }
        
        // Highlight strings (text between quotes)
        do {
            let stringPattern = "\"[^\"]*\""
            let regex = try NSRegularExpression(pattern: stringPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: fullRange)
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: stringColor, range: match.range)
            }
        } catch {
            print("Error highlighting strings: \(error)")
        }
        
        // Highlight keywords
        for keyword in keywords {
            let pattern = "\\b\(keyword)\\b"
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let matches = regex.matches(in: line, options: [], range: fullRange)
                for match in matches {
                    attributedString.addAttribute(.foregroundColor, value: keywordColor, range: match.range)
                    attributedString.addAttribute(.font, value: UIFont.monospacedSystemFont(ofSize: 12, weight: .bold), range: match.range)
                }
            } catch {
                print("Error creating regex for keyword \(keyword): \(error)")
            }
        }
        
        // Highlight function calls
        do {
            let functionPattern = "\\b[a-zA-Z_][a-zA-Z0-9_]*\\("
            let regex = try NSRegularExpression(pattern: functionPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: fullRange)
            for match in matches {
                if match.range.length > 1 {
                    // Adjust range to exclude the opening parenthesis
                    let functionRange = NSRange(location: match.range.location, length: match.range.length - 1)
                    attributedString.addAttribute(.foregroundColor, value: functionColor, range: functionRange)
                }
            }
        } catch {
            print("Error highlighting function calls: \(error)")
        }
        
        // Highlight numbers
        do {
            let numberPattern = "\\b\\d+(\\.\\d+)?\\b"
            let regex = try NSRegularExpression(pattern: numberPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: fullRange)
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: numberColor, range: match.range)
            }
        } catch {
            print("Error highlighting numbers: \(error)")
        }
        
        // Highlight operators
        do {
            let operatorPattern = "\\+|\\-|\\*|\\/|\\=|\\<|\\>|\\!|\\&|\\||\\^|\\%|\\:"
            let regex = try NSRegularExpression(pattern: operatorPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: fullRange)
            for match in matches {
                attributedString.addAttribute(.foregroundColor, value: operatorColor, range: match.range)
            }
        } catch {
            print("Error highlighting operators: \(error)")
        }
        
        return attributedString
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}