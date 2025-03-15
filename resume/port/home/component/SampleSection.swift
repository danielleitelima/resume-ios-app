import UIKit

class SampleSection: UIView {
    private let titleLabel = UILabel()
    private let carouselView = UIStackView()
    
    let samplesScrollView = UIScrollView()
    let samplesStackView = UIStackView()
    
    private var samples = [CodeSample]()
    private var onSelect: (CodeSample) -> Void = { _ in }
    
    @discardableResult
    func setData(
        samples: [CodeSample],
        onSelect: @escaping (CodeSample) -> Void
    ) -> SampleSection {
        self.samples = samples
        self.onSelect = onSelect
        
        setupCarousel()
        
        return self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = .systemFont(ofSize: 36, weight: .regular)
      
        titleLabel.textColor = .label
        titleLabel.text = "Code samples"
       
        
        titleLabel.numberOfLines = 0
        
        
        setConstraints()
        setupContainer()
       
        
    }
    
    func setupCarousel() {
        samplesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for subview in samplesScrollView.subviews {
            if let label = subview as? UILabel {
                label.removeFromSuperview()
            }
        }
        
        if samples.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No code samples available"
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.textAlignment = .center
            emptyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            
            samplesScrollView.addSubview(emptyLabel)
            
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: samplesScrollView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: samplesScrollView.centerYAnchor)
            ])
            return
        }
        
        for sample in samples {
            
            let card = SampleCard()
                .setData(
                    title: sample.Name,
                    description: sample.Description,
                    imageURL: URL(string: sample.ThumbnailURL)
                )
            
            card.onClick = { [weak self] in
                guard let self = self else { return }
                self.onSelect(sample)
            }
            
            samplesStackView.addArrangedSubview(card)
            
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 164)
            ])
        }
        
        samplesScrollView.contentSize = CGSize(
            width: CGFloat(samples.count) * (164 + 12) + 24, // card width + spacing + padding
            height: samplesScrollView.frame.height
        )
    }
    
    private func setupContainer(){
        addSubview(samplesScrollView)
        
        samplesScrollView.translatesAutoresizingMaskIntoConstraints = false
        samplesScrollView.showsHorizontalScrollIndicator = false
        samplesScrollView.showsVerticalScrollIndicator = false
        samplesScrollView.addSubview(samplesStackView)
        
        samplesStackView.translatesAutoresizingMaskIntoConstraints = false
        samplesStackView.axis = .horizontal
        samplesStackView.spacing = 12
        samplesStackView.alignment = .center
            
        // Set constraints
        NSLayoutConstraint.activate([
            samplesScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            samplesScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            samplesScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            samplesScrollView.heightAnchor.constraint(equalToConstant: 240),
            samplesScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            samplesStackView.topAnchor.constraint(equalTo: samplesScrollView.topAnchor),
            samplesStackView.leadingAnchor.constraint(equalTo: samplesScrollView.leadingAnchor, constant: 12),
            samplesStackView.trailingAnchor.constraint(equalTo: samplesScrollView.trailingAnchor, constant: -12),
            samplesStackView.heightAnchor.constraint(equalTo: samplesScrollView.heightAnchor)
        ])
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Loading code samples..."
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            
        samplesScrollView.addSubview(placeholderLabel)
            
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: samplesScrollView.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: samplesScrollView.centerYAnchor)
        ])
    }
    
    private func setConstraints() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
