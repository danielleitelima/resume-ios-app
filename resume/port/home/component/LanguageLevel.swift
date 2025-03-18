import UIKit

class LanguageLevel: UIView {
    private let contentStackView = UIStackView()
    let level1Bar = UIView()
    let level2Bar = UIView()
    let level3Bar = UIView()
    let level4Bar = UIView()

    @discardableResult
    func setData(level: Int) -> LanguageLevel {
        switch level {
            case 1:
                let barColor = UIColor(named: "language-beginner")
                level1Bar.backgroundColor = barColor
                level2Bar.backgroundColor = .surface
                level3Bar.backgroundColor = .surface
                level4Bar.backgroundColor = .surface
            case 2:
                let barColor = UIColor(named: "language-intermediate")
                level1Bar.backgroundColor = barColor
                level2Bar.backgroundColor = barColor
                level3Bar.backgroundColor = .surface
                level4Bar.backgroundColor = .surface
            case 3:
                let barColor = UIColor(named: "language-advanced")
                level1Bar.backgroundColor = barColor
                level2Bar.backgroundColor = barColor
                level3Bar.backgroundColor = barColor
                level4Bar.backgroundColor = .surface
            default:
                let barColor = UIColor(named: "language-fluent")
                level1Bar.backgroundColor = barColor
                level2Bar.backgroundColor = barColor
                level3Bar.backgroundColor = barColor
                level4Bar.backgroundColor = barColor
            break
        }
      
        return self
    }
    
    init() {
        super.init(frame: .zero)
        
        level1Bar.backgroundColor = .surface
        level1Bar.layer.cornerRadius = 4
        
        level2Bar.backgroundColor = .surface
        level2Bar.layer.cornerRadius = 4
        
        level3Bar.backgroundColor = .surface
        level3Bar.layer.cornerRadius = 4
        
        level4Bar.backgroundColor = .surface
        level4Bar.layer.cornerRadius = 4
        
        // Add height constraints to ensure bars are visible
        for bar in [level1Bar, level2Bar, level3Bar, level4Bar] {
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.heightAnchor.constraint(equalToConstant: 6).isActive = true
            bar.widthAnchor.constraint(equalToConstant: 16).isActive = true
        }
        
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.spacing = 6
        contentStackView.distribution = .fillEqually
        
        contentStackView.addArrangedSubview(level1Bar)
        contentStackView.addArrangedSubview(level2Bar)
        contentStackView.addArrangedSubview(level3Bar)
        contentStackView.addArrangedSubview(level4Bar)
    
        setupConstraints()
    }
    
    private func setupConstraints() {
        addSubview(contentStackView)
        
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 98),
            heightAnchor.constraint(equalToConstant: 6),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
