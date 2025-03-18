import UIKit

class SectionButton: UIButton {
    private let iconImageView = UIImageView()
    private let customTitleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            applySelectionState()
        }
    }
    
    @discardableResult
    func setData(title: String, icon: String) -> SectionButton{
        customTitleLabel.text = title
        iconImageView.image = UIImage(systemName: icon)
        applySelectionState()
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 20
        
        iconImageView.tintColor = .label
        iconImageView.contentMode = .scaleAspectFit
        
        customTitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        customTitleLabel.textColor = .label
        
        setConstraints()
    }
    
    private func applySelectionState() {
        UIView.animate(withDuration: 0.2) {
            if self.isSelected {
                self.backgroundColor = .secondaryContainer
                self.layer.borderWidth = 0
                self.iconImageView.tintColor = .onSecondaryContainer
                self.customTitleLabel.textColor = .onSecondaryContainer
            } else {
                self.backgroundColor = .clear
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.onSurfaceVariant.cgColor
                self.iconImageView.tintColor = .onSurfaceVariant
                self.customTitleLabel.textColor = .onSurfaceVariant
            }
        }
    }
    
    private func setConstraints(){
        addSubview(iconImageView)
        addSubview(customTitleLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            customTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            customTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            customTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
