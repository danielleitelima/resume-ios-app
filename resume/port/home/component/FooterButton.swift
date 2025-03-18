import UIKit

class FooterButton: UIButton {
    private let iconImageView = UIImageView()
    private let customTitleLabel = UILabel()

    
    @discardableResult
    func setData(icon: String) -> FooterButton{
        iconImageView.image = UIImage(named: icon)
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 24
        layer.borderWidth = 2
        layer.borderColor = UIColor.outline.cgColor
        
        iconImageView.tintColor = .outline
        iconImageView.contentMode = .scaleAspectFit
        
        setConstraints()
    }
    
    private func setConstraints(){
        addSubview(iconImageView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
