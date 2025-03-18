import UIKit

class HomeScreen: UIViewController, UIScrollViewDelegate {

    let profilePhotoView = UIImageView()
   
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    private let personalDataSection = PersonalDataSection()
    private let sampleSection = SampleSection()
    private let skillSection = SkillSection()
    private let languageSection = LanguageSection()
    private let footerSection = FooterSection()
    private let experienceSection = ExperienceSection()
    
    private let customDivider: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "custom-divider")?.withTintColor(.primary))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
    let contactButton = SectionButton().setData(title: "Contact", icon: "questionmark.circle.fill")
    
    // Code samples carousel
    let codeSamplesCarouselView = UIScrollView()
    let codeSamplesStackView = UIStackView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .surface
                
        setupStatusBarBackground()
        setupTopBar()
        setupLoadingView()
        setupScrollView()
        setupMenuOverlay()
//
//        // Fetch resume data
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
        
        statusBarView.backgroundColor = .surfaceContainer
        
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
            loadingView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
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
        
        topBarView.backgroundColor = .surfaceContainer
        
        let menuImage = UIImage(systemName: "line.horizontal.3")
        menuButton.setImage(menuImage, for: .normal)
        menuButton.tintColor = .onSurface
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
        menuOverlay.backgroundColor = .surfaceContainer
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
        topRowStack.distribution = .fill
        
        let middleRowStack = UIStackView()
        middleRowStack.axis = .horizontal
        middleRowStack.spacing = 15
        middleRowStack.distribution = .fill
        
        let bottomRowStack = UIStackView()
        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = 15
        bottomRowStack.distribution = .fill
        
        topRowStack.addArrangedSubview(introButton)
        topRowStack.addArrangedSubview(codeButton)
        
        middleRowStack.addArrangedSubview(skillsButton)
        middleRowStack.addArrangedSubview(experienceButton)
        
        bottomRowStack.addArrangedSubview(languagesButton)
        bottomRowStack.addArrangedSubview(contactButton)
        
        menuStackView.addArrangedSubview(topRowStack)
        menuStackView.addArrangedSubview(middleRowStack)
        menuStackView.addArrangedSubview(bottomRowStack)
        
        // Setup close button
        let xImage = UIImage(systemName: "xmark")
        closeButton.setImage(xImage, for: .normal)
        closeButton.tintColor = .onSurface
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Set up button actions
        introButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        codeButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        skillsButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        experienceButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
        languagesButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
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
                    print(error)
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
                    self.sampleSection.setData(
                        samples: self.codeSamples
                    ){
                        sample in
                        self.showCodeSampleDetail(sample)
                    }
                }
            } catch {
                print("Failed to parse code samples: \(error)")
            }
        }.resume()
    }
    
    // Navigate to code sample detail screen
    func showCodeSampleDetail(_ sample: CodeSample) {
        let sampleDetailScreen = SampleDetailScreen(sample: sample)
        let navController = UINavigationController(rootViewController: sampleDetailScreen)
        present(navController, animated: true)
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
        
        setupPersonalDataSection(with: resume)
        
        setupSampleSection()

        setupSkillsSection(with: resume.skills)
        
        setupExperienceSection(with: resume.experiences)
        
        setupLanguageSection(with: resume.languages)
        
        setupFooterSection(with: resume.personalData)
    }
    
    func setupProfileImageView(with personalData: PersonalData) {
        let size: CGFloat = 200

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
    
    func setupPersonalDataSection(with resume: Resume) {
        contentView.addSubview(personalDataSection)
        contentView.addSubview(customDivider)
        
        personalDataSection.translatesAutoresizingMaskIntoConstraints = false
        customDivider.translatesAutoresizingMaskIntoConstraints = false

        personalDataSection.setData(
            name: resume.personalData.name,
            title: resume.personalData.title,
            description: resume.personalData.description,
            location: resume.personalData.location,
            introductionTitle: resume.introduction.title,
            introductionDescription: resume.introduction.description
        )
        
        NSLayoutConstraint.activate([
            personalDataSection.topAnchor.constraint(
                equalTo: profilePhotoView.bottomAnchor,
                constant: 24
            ),
            personalDataSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            personalDataSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            customDivider.topAnchor.constraint(equalTo: personalDataSection.bottomAnchor, constant: 32),
            customDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48),
            customDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48),
            
        ])
    }
    
    func setupSampleSection() {
        contentView.addSubview(sampleSection)
        
        sampleSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sampleSection.topAnchor.constraint(
                equalTo: customDivider.bottomAnchor,
                constant: 24
            ),
            sampleSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sampleSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    }
    
    func setupSkillsSection(with skills: [Skill]) {
        skillSection.setData(skills: skills)
        
        contentView.addSubview(skillSection)
        
        skillSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            skillSection.topAnchor.constraint(
                equalTo: sampleSection.bottomAnchor,
                constant: 24
            ),
            skillSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            skillSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
        ])
    }
    
    func setupExperienceSection(with experiences: [Experience]) {
        experienceSection.setData(experiences)
        
        contentView.addSubview(experienceSection)
        
        experienceSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            experienceSection.topAnchor.constraint(
                equalTo: skillSection.bottomAnchor,
                constant: 24
            ),
            experienceSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            experienceSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupLanguageSection(with languages: [Language]) {
        languageSection.setData(languages: languages)
        
        contentView.addSubview(languageSection)
        
        languageSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            languageSection.topAnchor.constraint(
                equalTo: experienceSection.bottomAnchor,
                constant: 24
            ),
            languageSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            languageSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func setupFooterSection(with personalData: PersonalData) {
        footerSection.setData(email: personalData.emailAddress, linkedInURL: personalData.linkedinUrl, gitHubURL: personalData.githubUrl)
        
        contentView.addSubview(footerSection)
        
        footerSection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            footerSection.topAnchor.constraint(
                equalTo: languageSection.bottomAnchor,
                constant: 48
            ),
            footerSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            footerSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
    
    // MARK: - Actions
    @objc func menuButtonTapped() {
        toggleMenu(open: true)
    }
    
    @objc func closeButtonTapped() {
        toggleMenu(open: false)
    }
    
    @objc func sectionButtonTapped(_ sender: SectionButton) {
        // Reset all buttons
        [introButton, codeButton, skillsButton, experienceButton, languagesButton, contactButton].forEach { $0.isSelected = false }
        
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
            targetView = sampleSection
        case skillsButton:
            targetView = skillSection
        case experienceButton:
            targetView = experienceSection
        case languagesButton:
            targetView = languageSection
        case contactButton:
            targetView = footerSection
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
            (sampleSection, codeButton),
            (skillSection, skillsButton),
            (experienceSection, experienceButton),
            (languageSection, languagesButton),
            (footerSection, contactButton)
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
    HomeScreen()
}
