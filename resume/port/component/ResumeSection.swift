import UIKit

class ResumeSection: UIView {
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let dividerLine = UIView()
    
    @discardableResult
    func setData(title: String) -> ResumeSection {
        titleLabel.text = title
        
        return self
    }
    
    init() {
        super.init(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    
        dividerLine.backgroundColor = .systemGray4
        
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 0

        setConstraints()
    }
    
    private func setConstraints() {
        addSubview(titleLabel)
        addSubview(dividerLine)
        addSubview(contentLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dividerLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dividerLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            contentLabel.topAnchor.constraint(equalTo: dividerLine.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
