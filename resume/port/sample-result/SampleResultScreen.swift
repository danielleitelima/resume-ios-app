import UIKit

class SampleResultScreen: UIViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let codeSection = CodeSection()
    private let outputSection = OutputSection()
    private let logSection = LogSection()
    
    private let sourceCode: String
    private let output: String
    private let duration: String
    private let logs: [String]
    
    init(sourceCode: String, output: String, duration: String, logs: [String]) {
        self.sourceCode = sourceCode
        self.output = output
        self.duration = duration
        self.logs = logs
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .surface
        title = "Result"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
        
        setup()
    }
    
    // MARK: - UI Setup
    private func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        codeSection.translatesAutoresizingMaskIntoConstraints = false
        outputSection.translatesAutoresizingMaskIntoConstraints = false
        logSection.translatesAutoresizingMaskIntoConstraints = false
        
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
       
        contentView.addSubview(outputSection)
        contentView.addSubview(logSection)
        contentView.addSubview(codeSection)
        
        NSLayoutConstraint.activate([
            outputSection.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outputSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            outputSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            logSection.topAnchor.constraint(equalTo: outputSection.bottomAnchor, constant: 8),
            logSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            logSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            codeSection.topAnchor.constraint(equalTo: logSection.bottomAnchor, constant: 8),
            codeSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            codeSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            codeSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        outputSection.setData(value: output, duration: duration)
        logSection.setData(logs: logs)
        codeSection.setData(content: sourceCode)
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
