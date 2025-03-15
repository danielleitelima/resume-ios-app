import UIKit

class SampleDetailScreen: UIViewController {
    
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
    private var requiredFields: [String] = []
    private var arrayFields: [String: [UIView]] = [:]
    
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
                // Extract properties from the schema
                if let properties = json["properties"] as? [String: Any] {
                    inputSchema = properties
                    
                    // Extract required fields
                    if let required = json["required"] as? [String] {
                        requiredFields = required
                    }
                    
                    // Print the schema for debugging
                    print("Input Schema Properties: \(inputSchema)")
                    print("Required Fields: \(requiredFields)")
                }
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
            guard let fieldInfo = value as? [String: Any] else { continue }
            
            let fieldContainer = UIView()
            fieldContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let fieldLabel = UILabel()
            let isRequired = requiredFields.contains(key)
            fieldLabel.text = key + (isRequired ? " *" : "")
            fieldLabel.font = UIFont.systemFont(ofSize: 16, weight: isRequired ? .bold : .regular)
            fieldLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add description if available
            let descriptionLabel = UILabel()
            if let description = fieldInfo["description"] as? String {
                descriptionLabel.text = description
                descriptionLabel.font = UIFont.systemFont(ofSize: 12)
                descriptionLabel.textColor = .secondaryLabel
                descriptionLabel.numberOfLines = 0
                descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            }
            
            fieldContainer.addSubview(fieldLabel)
            fieldContainer.addSubview(descriptionLabel)
            
            // Determine field type
            if let type = fieldInfo["type"] as? String {
                switch type {
                case "array":
                    // Handle array type
                    setupArrayField(key: key, fieldInfo: fieldInfo, fieldContainer: fieldContainer, fieldLabel: fieldLabel, descriptionLabel: descriptionLabel)
                case "boolean":
                    // Boolean input - use a toggle/switch
                    setupBooleanField(key: key, fieldInfo: fieldInfo, fieldContainer: fieldContainer, fieldLabel: fieldLabel, descriptionLabel: descriptionLabel)
                case "string":
                    // String input
                    setupTextField(key: key, fieldInfo: fieldInfo, fieldContainer: fieldContainer, fieldLabel: fieldLabel, descriptionLabel: descriptionLabel, keyboardType: .default)
                case "integer":
                    // Integer input
                    setupTextField(key: key, fieldInfo: fieldInfo, fieldContainer: fieldContainer, fieldLabel: fieldLabel, descriptionLabel: descriptionLabel, keyboardType: .numberPad)
                case "number":
                    // Float input
                    setupTextField(key: key, fieldInfo: fieldInfo, fieldContainer: fieldContainer, fieldLabel: fieldLabel, descriptionLabel: descriptionLabel, keyboardType: .decimalPad)
                default:
                    // Unsupported type
                    let typeLabel = UILabel()
                    typeLabel.text = "Unsupported type: \(type)"
                    typeLabel.font = UIFont.systemFont(ofSize: 14)
                    typeLabel.textColor = .systemRed
                    typeLabel.translatesAutoresizingMaskIntoConstraints = false
                    
                    fieldContainer.addSubview(typeLabel)
                    
                    NSLayoutConstraint.activate([
                        fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
                        fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                        fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                        
                        descriptionLabel.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 4),
                        descriptionLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                        descriptionLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                        
                        typeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
                        typeLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
                        typeLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
                        typeLabel.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
                    ])
                }
            }
            
            inputFormStackView.addArrangedSubview(fieldContainer)
        }
        
        // Add a note about required fields
        if !requiredFields.isEmpty {
            let noteLabel = UILabel()
            noteLabel.text = "* Required fields"
            noteLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noteLabel.textColor = .secondaryLabel
            noteLabel.numberOfLines = 0
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            inputFormStackView.addArrangedSubview(noteLabel)
        }
    }
    
    // Setup array field
    private func setupArrayField(key: String, fieldInfo: [String: Any], fieldContainer: UIView, fieldLabel: UILabel, descriptionLabel: UILabel) {
        // Create a container for the array items
        let arrayContainer = UIStackView()
        arrayContainer.axis = .vertical
        arrayContainer.spacing = 8
        arrayContainer.alignment = .fill
        arrayContainer.distribution = .equalSpacing
        arrayContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Add buttons to add/remove items
        let buttonContainer = UIStackView()
        buttonContainer.axis = .horizontal
        buttonContainer.spacing = 8
        buttonContainer.alignment = .center
        buttonContainer.distribution = .fillEqually
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Item", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 5
        
        let removeButton = UIButton(type: .system)
        removeButton.setTitle("Remove Last", for: .normal)
        removeButton.backgroundColor = .systemRed
        removeButton.setTitleColor(.white, for: .normal)
        removeButton.layer.cornerRadius = 5
        
        buttonContainer.addArrangedSubview(addButton)
        buttonContainer.addArrangedSubview(removeButton)
        
        // Store array items
        arrayFields[key] = []
        
        // Add action to buttons
        addButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.addArrayItem(key: key, fieldInfo: fieldInfo, arrayContainer: arrayContainer)
        }, for: .touchUpInside)
        
        removeButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.removeArrayItem(key: key, arrayContainer: arrayContainer)
        }, for: .touchUpInside)
        
        // Add to view hierarchy
        fieldContainer.addSubview(arrayContainer)
        fieldContainer.addSubview(buttonContainer)
        
        // Set constraints
        NSLayoutConstraint.activate([
            fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            buttonContainer.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            buttonContainer.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            buttonContainer.heightAnchor.constraint(equalToConstant: 40),
            
            arrayContainer.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: 8),
            arrayContainer.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            arrayContainer.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            arrayContainer.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor)
        ])
        
        // Add default items if available
        if let defaultValue = fieldInfo["default"] as? [Any], !defaultValue.isEmpty {
            for _ in defaultValue {
                addArrayItem(key: key, fieldInfo: fieldInfo, arrayContainer: arrayContainer)
            }
        } else {
            // Add at least one item by default
            addArrayItem(key: key, fieldInfo: fieldInfo, arrayContainer: arrayContainer)
        }
    }
    
    // Add an item to an array field
    private func addArrayItem(key: String, fieldInfo: [String: Any], arrayContainer: UIStackView) {
        // Create a container for this item
        let itemContainer = UIView()
        itemContainer.translatesAutoresizingMaskIntoConstraints = false
        itemContainer.backgroundColor = .systemGray6
        itemContainer.layer.cornerRadius = 5
        
        // Create an index label
        let indexLabel = UILabel()
        let itemIndex = arrayFields[key]?.count ?? 0
        indexLabel.text = "[\(itemIndex)]"
        indexLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Determine the type of items in the array
        if let items = fieldInfo["items"] as? [String: Any], let itemType = items["type"] as? String {
            var inputField: UIView
            
            switch itemType {
            case "string":
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter text"
                textField.translatesAutoresizingMaskIntoConstraints = false
                inputField = textField
                
            case "integer":
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter number"
                textField.keyboardType = .numberPad
                textField.translatesAutoresizingMaskIntoConstraints = false
                
                // If there's an enum, create a picker instead
                if let enumValues = items["enum"] as? [Int] {
                    let segmentedControl = UISegmentedControl(items: enumValues.map { String($0) })
                    segmentedControl.selectedSegmentIndex = 0
                    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
                    inputField = segmentedControl
                } else {
                    inputField = textField
                }
                
            case "number":
                let textField = UITextField()
                textField.borderStyle = .roundedRect
                textField.placeholder = "Enter decimal"
                textField.keyboardType = .decimalPad
                textField.translatesAutoresizingMaskIntoConstraints = false
                inputField = textField
                
            case "boolean":
                let switchControl = UISwitch()
                switchControl.translatesAutoresizingMaskIntoConstraints = false
                inputField = switchControl
                
            default:
                let label = UILabel()
                label.text = "Unsupported item type: \(itemType)"
                label.textColor = .systemRed
                label.translatesAutoresizingMaskIntoConstraints = false
                inputField = label
            }
            
            // Add views to container
            itemContainer.addSubview(indexLabel)
            itemContainer.addSubview(inputField)
            
            // Set constraints
            NSLayoutConstraint.activate([
                indexLabel.leadingAnchor.constraint(equalTo: itemContainer.leadingAnchor, constant: 8),
                indexLabel.centerYAnchor.constraint(equalTo: itemContainer.centerYAnchor),
                indexLabel.widthAnchor.constraint(equalToConstant: 30),
                
                inputField.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 8),
                inputField.trailingAnchor.constraint(equalTo: itemContainer.trailingAnchor, constant: -8),
                inputField.centerYAnchor.constraint(equalTo: itemContainer.centerYAnchor),
                
                itemContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
            ])
            
            // Add to array container
            arrayContainer.addArrangedSubview(itemContainer)
            
            // Store the input field
            if var fields = arrayFields[key] {
                fields.append(inputField)
                arrayFields[key] = fields
            } else {
                arrayFields[key] = [inputField]
            }
            
            // Set default value if available
            if let defaultValues = fieldInfo["default"] as? [Any], itemIndex < defaultValues.count {
                let defaultValue = defaultValues[itemIndex]
                
                if let textField = inputField as? UITextField {
                    textField.text = "\(defaultValue)"
                } else if let switchControl = inputField as? UISwitch, let boolValue = defaultValue as? Bool {
                    switchControl.isOn = boolValue
                } else if let segmentedControl = inputField as? UISegmentedControl, let intValue = defaultValue as? Int, 
                          let enumValues = items["enum"] as? [Int], let index = enumValues.firstIndex(of: intValue) {
                    segmentedControl.selectedSegmentIndex = index
                }
            }
        }
    }
    
    // Remove the last item from an array field
    private func removeArrayItem(key: String, arrayContainer: UIStackView) {
        guard var fields = arrayFields[key], !fields.isEmpty,
              arrayContainer.arrangedSubviews.count > 0 else { return }
        
        // Remove the last item
        if let lastView = arrayContainer.arrangedSubviews.last {
            arrayContainer.removeArrangedSubview(lastView)
            lastView.removeFromSuperview()
            
            // Remove from stored fields
            fields.removeLast()
            arrayFields[key] = fields
        }
    }
    
    // Setup boolean field
    private func setupBooleanField(key: String, fieldInfo: [String: Any], fieldContainer: UIView, fieldLabel: UILabel, descriptionLabel: UILabel) {
        // Boolean input - use a toggle/switch
        let switchControl = UISwitch()
        // Convert value to boolean (default to false if conversion fails)
        let boolValue = fieldInfo["default"] as? Bool ?? false
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
            fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            
            switchControl.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            switchControl.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 8),
            switchControl.trailingAnchor.constraint(lessThanOrEqualTo: fieldContainer.trailingAnchor),
            switchControl.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: -8)
        ])
    }
    
    // Setup text field
    private func setupTextField(key: String, fieldInfo: [String: Any], fieldContainer: UIView, fieldLabel: UILabel, descriptionLabel: UILabel, keyboardType: UIKeyboardType) {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter value"
        textField.keyboardType = keyboardType
        
        // Set default value if available
        if let defaultValue = fieldInfo["default"] {
            textField.text = "\(defaultValue)"
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        fieldContainer.addSubview(textField)
        inputFields[key] = textField
        
        NSLayoutConstraint.activate([
            fieldLabel.topAnchor.constraint(equalTo: fieldContainer.topAnchor),
            fieldLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            fieldLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: fieldContainer.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: fieldContainer.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: fieldContainer.bottomAnchor, constant: -8)
        ])
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
        
        // Process regular input fields
        for (key, inputField) in inputFields {
            if let textField = inputField as? UITextField, let fieldInfo = inputSchema[key] as? [String: Any] {
                if let type = fieldInfo["type"] as? String {
                    switch type {
                    case "integer":
                        // Convert to Int
                        if let text = textField.text, !text.isEmpty, let intValue = Int(text) {
                            inputValues[key] = intValue
                        } else {
                            inputValues[key] = 0 // Default value
                        }
                    case "number":
                        // Convert to Double
                        if let text = textField.text, !text.isEmpty, let doubleValue = Double(text) {
                            inputValues[key] = doubleValue
                        } else {
                            inputValues[key] = 0.0 // Default value
                        }
                    default:
                        // String value
                        inputValues[key] = textField.text ?? ""
                    }
                }
            } else if let switchControl = inputField as? UISwitch {
                // Boolean value from switch
                inputValues[key] = switchControl.isOn
            }
        }
        
        // Process array fields
        for (key, fields) in arrayFields {
            var arrayValues: [Any] = []
            
            if let fieldInfo = inputSchema[key] as? [String: Any],
               let items = fieldInfo["items"] as? [String: Any],
               let itemType = items["type"] as? String {
                
                for field in fields {
                    if let textField = field as? UITextField {
                        switch itemType {
                        case "integer":
                            if let text = textField.text, !text.isEmpty, let intValue = Int(text) {
                                arrayValues.append(intValue)
                            } else {
                                arrayValues.append(0) // Default value
                            }
                        case "number":
                            if let text = textField.text, !text.isEmpty, let doubleValue = Double(text) {
                                arrayValues.append(doubleValue)
                            } else {
                                arrayValues.append(0.0) // Default value
                            }
                        default:
                            arrayValues.append(textField.text ?? "")
                        }
                    } else if let switchControl = field as? UISwitch {
                        arrayValues.append(switchControl.isOn)
                    } else if let segmentedControl = field as? UISegmentedControl {
                        if let enumValues = items["enum"] as? [Int], 
                           segmentedControl.selectedSegmentIndex >= 0,
                           segmentedControl.selectedSegmentIndex < enumValues.count {
                            arrayValues.append(enumValues[segmentedControl.selectedSegmentIndex])
                        } else {
                            arrayValues.append(segmentedControl.selectedSegmentIndex)
                        }
                    }
                }
            }
            
            inputValues[key] = arrayValues
        }
        
        // Make API request
        runCodeSample(sampleId: sample.ID, input: inputValues)
    }
    
    // Validate input fields
    private func validateInputFields() -> Bool {
        var isValid = true
        var errorMessage = ""
        
        // Validate regular fields
        for key in requiredFields {
            if let inputField = inputFields[key] {
                if let textField = inputField as? UITextField, let text = textField.text, text.isEmpty {
                    isValid = false
                    errorMessage = "'\(key)' is required."
                    textField.layer.borderColor = UIColor.systemRed.cgColor
                    textField.layer.borderWidth = 1
                    break
                }
            } else if arrayFields[key] == nil || arrayFields[key]?.isEmpty == true {
                isValid = false
                errorMessage = "'\(key)' is required and must have at least one item."
                break
            }
        }
        
        // Validate array fields
        for (key, fields) in arrayFields {
            if requiredFields.contains(key) && fields.isEmpty {
                isValid = false
                errorMessage = "'\(key)' is required and must have at least one item."
                break
            }
            
            for (index, field) in fields.enumerated() {
                if let textField = field as? UITextField, 
                   let fieldInfo = inputSchema[key] as? [String: Any],
                   let items = fieldInfo["items"] as? [String: Any],
                   let itemType = items["type"] as? String {
                    
                    if let text = textField.text, !text.isEmpty {
                        switch itemType {
                        case "integer":
                            if Int(text) == nil {
                                isValid = false
                                errorMessage = "'\(key)[\(index)]' must be a valid integer."
                                textField.layer.borderColor = UIColor.systemRed.cgColor
                                textField.layer.borderWidth = 1
                                break
                            } else {
                                textField.layer.borderWidth = 0
                            }
                        case "number":
                            if Double(text) == nil {
                                isValid = false
                                errorMessage = "'\(key)[\(index)]' must be a valid decimal number."
                                textField.layer.borderColor = UIColor.systemRed.cgColor
                                textField.layer.borderWidth = 1
                                break
                            } else {
                                textField.layer.borderWidth = 0
                            }
                        default:
                            break   
                        }
                    }
                }
            }
            
            if !isValid {
                break
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
                            let resultVC = CodeSampleResultViewController(
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
