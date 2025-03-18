//
//  LogSection.swift
//  resume
//
//  Created by Daniel Leite Lima on 14.03.25.
//

import UIKit

class CodeSection: UIView {
    let contentContainer = UIView()
    let scrollView = UIScrollView()
    let scrollContentView = UIView()
    let stackView = UIStackView()
    
    var content: String = ""
    
    @discardableResult
    func setData(content: String) -> CodeSection {
        self.content = content
        setup()
        return self
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup(){
        // Setup source code view
        backgroundColor = .surfaceContainer
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
                
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(contentContainer)
        
        // Create a single horizontal scroll view for all code
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = true
        
        contentContainer.addSubview(scrollView)
        
        // Create a content view for the scroll view
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(scrollContentView)
        
        // Split the source code into lines
        let codeLines = content.components(
            separatedBy: .newlines
        )
        
        // Create a stack view for the code lines
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(stackView)
        
        // Set up constraints for the scroll view and its content
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            scrollView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Don't constrain trailing to allow content to be wider than the scroll view
            
            stackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor)
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
            stackView.addArrangedSubview(lineContainer)
            
            // Calculate the width needed for this line
            let labelSize = codeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: codeLabel.frame.height))
            let lineWidth = 30 + 8 + labelSize.width + 20 // line number + spacing + code width + padding
            
            // Update max content width if this line is wider
            maxContentWidth = max(maxContentWidth, lineWidth)
        }
        
        // Set the width of the scroll content view
        scrollContentView.widthAnchor.constraint(greaterThanOrEqualToConstant: max(maxContentWidth, 500)).isActive = true
        
        // Set content size for horizontal scrolling
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: max(maxContentWidth, 500), height: scrollView.frame.height)
        
        // Set a height constraint for the source code view to ensure it has a proper size
        let stackViewHeight = CGFloat(codeLines.count) * 20 // Approximate height per line
        heightAnchor.constraint(greaterThanOrEqualToConstant: min(max(stackViewHeight, 100), 500)).isActive = true
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}

#Preview {
    CodeSection().setData(content: "func (m *MergeStringsAlternately) Run() string {\n\t// TODO: Implement the logic to merge strings alternately\n\n\t// Create a new string to store the result\n\tresult := \"\"\n\n\t// Get the length of the shorter string\n\tminLength := len(m.FirstString)\n\tif len(m.SecondString) < minLength {\n\t\tminLength = len(m.SecondString)\n\t}\n\n\t// Merge the strings alternately\n\tfor i := 0; i < minLength; i++ {\n\t\tresult += string(m.FirstString[i]) + string(m.SecondString[i])\n\t}\n\n\t// Add the remaining characters from the longer string\n\tif len(m.FirstString) > minLength {\n\t\tresult += m.FirstString[minLength:]\n\t} else if len(m.SecondString) > minLength {\n\t\tresult += m.SecondString[minLength:]\n\t}\n\n\treturn result\n}")
}
