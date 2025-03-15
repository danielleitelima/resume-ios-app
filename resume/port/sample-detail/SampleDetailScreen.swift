import UIKit

class SampleDetailScreen: UIViewController {
    
    private let sample: CodeSample
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let introductionSection = IntroductionSection()
    private let separator = UIView()
    private let inputSection = InputSection()
    
    private let runButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(sample: CodeSample) {
        self.sample = sample
        super.init(nibName: nil, bundle: nil)
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
        setupInputForm()
    }
    
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
        
        introductionSection.translatesAutoresizingMaskIntoConstraints = false
        
        introductionSection.setData(title: sample.Name, description: sample.Description)
        
        separator.backgroundColor = .systemGray4
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        inputSection.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup run button
        runButton.setTitle("Run Code Sample", for: .normal)
        runButton.backgroundColor = .systemBlue
        runButton.setTitleColor(.white, for: .normal)
        runButton.layer.cornerRadius = 10
        runButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        runButton.translatesAutoresizingMaskIntoConstraints = false
        runButton.addTarget(self, action: #selector(runButtonTapped), for: .touchUpInside)
        
        // Setup loading indicator
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.hidesWhenStopped = true
        
        contentView.addSubview(introductionSection)
        contentView.addSubview(separator)
        contentView.addSubview(inputSection)
        contentView.addSubview(runButton)
        contentView.addSubview(loadingIndicator)
        
        // Set constraints
        NSLayoutConstraint.activate([
            introductionSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            introductionSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            introductionSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            separator.topAnchor.constraint(equalTo: introductionSection.bottomAnchor, constant: 32),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            inputSection.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 32),
            inputSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            inputSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            runButton.topAnchor.constraint(equalTo: inputSection.bottomAnchor, constant: 32),
            runButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            runButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            runButton.heightAnchor.constraint(equalToConstant: 50),
          
            loadingIndicator.centerXAnchor.constraint(equalTo: runButton.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: runButton.bottomAnchor, constant: 20),
            
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: loadingIndicator.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupInputForm() {
        inputSection.setData(inputScheme: sample.InputSchema)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func runButtonTapped() {
        print("Button clicked")
        
        view.endEditing(true)
        
        let errorMessage = inputSection.validateInputFields()
        
        if errorMessage != nil {
            showAlert(title: "Incorrect parameters", message: errorMessage!)
            return
        }
        
        loadingIndicator.startAnimating()
 
        runCodeSample(sampleId: sample.ID, input: inputSection.getInputValues())
    }
    
    private func runCodeSample(sampleId: String, input: [String: Any]) {
        guard let url = URL(string: "https://api.danielleitelima.com/runCodeSample") else {
            showAlert(title: "Failed to create request", message:"Invalid API URL")
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
            showAlert(title: "Failed to create request", message: error.localizedDescription)
            return
        }
        
        // Make request
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                
                if let error = error {
                    self.showAlert(title: "Network error", message: error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.showAlert(title: "Network error", message: "Invalid response")
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    self.showAlert(title: "Network error", message: "Server error: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else {
                    self.showAlert(title: "Network error", message: "No data received")
                    return
                }
                
                // Parse and display result
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let sourceCode = json["sourceCode"] as? String,
                                  let output = json["output"] as? String,
                                  let duration = json["duration"] as? String {
                            // We have a detailed code result - show in a new screen
                            let logs = json["log"] as? [String] ?? []
                            
                            // Create and present the result view controller
                            let sampleResultScreen = SampleResultScreen(
                                sourceCode: sourceCode,
                                output: output,
                                duration: duration,
                                logs: logs
                            )
                            let navController = UINavigationController(rootViewController: sampleResultScreen)
                            self.present(navController, animated: true)
                            
                            // Hide the result label since we're showing a new screen
                        } else {
                            let resultString = String(data: data, encoding: .utf8) ?? "Unknown result format"
                            self.showAlert(title: "Formatting error", message: resultString)
                        }
                    } else {
                        let resultString = String(data: data, encoding: .utf8) ?? "Unknown result format"
                        self.showAlert(title: "Formatting error", message: resultString)
                    }
                } catch {
                    self.showAlert(title: "Failed to parse result", message:error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
