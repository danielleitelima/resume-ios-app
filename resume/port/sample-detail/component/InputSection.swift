//
//  LogSection.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class InputSection: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private var inputSchema: String?
    private var properties: [String: Any]?
    private var required: [String]?
    
    private var arrayFields: [String: [UIView]] = [:]
    private var inputFields: [String: UIView] = [:]

    
    @discardableResult
    func setData(inputScheme: String) -> InputSection {
        self.inputSchema = inputScheme
        parseInputSchema()
        setupInputForm()
        return self
    }
    
    init() {
        super.init(frame: .zero)
        setConstraints()
    }
    
    private func parseInputSchema() {
        guard let inputSchema = inputSchema, let jsonData = inputSchema.data(using: .utf8) else {
//            showAlert(title: "Error", message: "Invalid input schema format")
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                if let properties = json["properties"] as? [String: Any] {
                    
                    self.properties = properties
                    
                    if let required = json["required"] as? [String] {
                        self.required = required
                    }
                    
                }
            }
        } catch {
//            showAlert(title: "Error", message: "Failed to parse input schema: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Input Form Setup
    private func setupInputForm() {
        guard let properties = properties, let required = required else { return }
        
        // Add input fields based on the schema
        for (key, value) in properties {
            guard let fieldInfo = value as? [String: Any] else { continue }
            
            let fieldContainer = UIView()
            fieldContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let fieldLabel = UILabel()
            let isRequired = required.contains(key)
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
            
            stackView.addArrangedSubview(fieldContainer)
        }
        
        // Add a note about required fields
        if !required.isEmpty {
            let noteLabel = UILabel()
            noteLabel.text = "* Required fields"
            noteLabel.font = UIFont.italicSystemFont(ofSize: 14)
            noteLabel.textColor = .secondaryLabel
            noteLabel.numberOfLines = 0
            noteLabel.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(noteLabel)
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
    
    func getInputValues() -> [String: Any] {
        // Collect input values
        var inputValues: [String: Any] = [:]
        
        guard let properties = properties else { return [:]}

        
        // Process regular input fields
        for (key, inputField) in inputFields {
            if let textField = inputField as? UITextField, let fieldInfo = properties[key] as? [String: Any] {
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
            
            if let fieldInfo = properties[key] as? [String: Any],
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
        
        return inputValues
    }
    
    func validateInputFields() -> String? {
        var errorMessage: String?

        guard let required = required, let properties = properties else {
            return errorMessage
        }

        // Validate regular fields
        for key in required {
            if let inputField = inputFields[key] {
                if let textField = inputField as? UITextField, let text = textField.text, text.isEmpty {
                    errorMessage = "'\(key)' is required."
                    textField.layer.borderColor = UIColor.systemRed.cgColor
                    textField.layer.borderWidth = 1
                    break
                }
            } else if arrayFields[key] == nil || arrayFields[key]?.isEmpty == true {
                errorMessage = "'\(key)' is required and must have at least one item."
                break
            }
        }
        
        // Validate array fields
        for (key, fields) in arrayFields {
            if required.contains(key) && fields.isEmpty {
                errorMessage = "'\(key)' is required and must have at least one item."
                break
            }
            
            for (index, field) in fields.enumerated() {
                if let textField = field as? UITextField,
                   let fieldInfo = properties[key] as? [String: Any],
                   let items = fieldInfo["items"] as? [String: Any],
                   let itemType = items["type"] as? String {
                    
                    if let text = textField.text, !text.isEmpty {
                        switch itemType {
                        case "integer":
                            if Int(text) == nil {
                                errorMessage = "'\(key)[\(index)]' must be a valid integer."
                                textField.layer.borderColor = UIColor.systemRed.cgColor
                                textField.layer.borderWidth = 1
                                break
                            } else {
                                textField.layer.borderWidth = 0
                            }
                        case "number":
                            if Double(text) == nil {
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
            
            if errorMessage != nil {
                break
            }
        }
      
        return errorMessage
    }
    
    private func setConstraints() {
        addSubview(stackView)
       
        stackView.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
