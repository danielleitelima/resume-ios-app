import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {

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
    let introButton = SectionButton().setData(title: "Intro", icon: "person.fill")
    let codeButton = SectionButton().setData(title: "Code", icon: "chevron.left.forwardslash.chevron.right")
    let skillsButton = SectionButton().setData(title: "Skills", icon: "wrench.fill")
    let experienceButton = SectionButton().setData(title: "Experience", icon: "chart.line.uptrend.xyaxis")
    let languagesButton = SectionButton().setData(title: "Languages", icon: "text.bubble.fill")
    let educationButton = SectionButton().setData(title: "Education", icon: "book.fill")
    let articlesButton = SectionButton().setData(title: "Articles", icon: "doc.fill")
    let contactButton = SectionButton().setData(title: "Contact", icon: "questionmark.circle.fill")
    
    // Resume section views
    let aboutMeSection = ResumeSection().setData(title: "About Me")
    let codeSamplesSection = ResumeSection().setData(title: "Code Samples")
    let skillsSection = ResumeSection().setData(title: "Skills")
    let experienceSection = ResumeSection().setData(title: "Experience")
    let educationSection = ResumeSection().setData(title: "Education")
    let languagesSection = ResumeSection().setData(title: "Languages")
    let contactSection = ResumeSection().setData(title: "Contact")
    
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
        
        contactInfoView.setData(
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
            codeSamplesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            codeSamplesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
            codeSamplesCarouselView.heightAnchor.constraint(equalToConstant: 240),
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
            
            let card = CodeSampleCard()
                .setData(
                    title: sample.Name,
                    description: sample.Description,
                    imageURL: URL(string: sample.ThumbnailURL)
                )
            
            card.onClick = { [weak self] in
                guard let self = self else { return }
                self.showCodeSampleDetail(sample)
            }
            
            codeSamplesStackView.addArrangedSubview(card)
            
            // Set fixed width for each card
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 164)
            ])
        }
        
        // Update content size for horizontal scrolling
        codeSamplesCarouselView.contentSize = CGSize(
            width: CGFloat(codeSamples.count) * (164 + 15) + 20, // card width + spacing + padding
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

#Preview {
    HomeViewController()
}
