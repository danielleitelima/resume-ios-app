import UIKit

class FlexboxLayout: UIView {
    // Spacing between items
    var spacing: CGFloat = 8
    
    // Padding around the container
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    // Array to store all the arranged subviews
    private var arrangedSubviews: [UIView] = []
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add a view to the flexbox layout
    func addArrangedSubview(_ view: UIView) {
        arrangedSubviews.append(view)
        addSubview(view)
        setNeedsLayout()
    }
    
    // Remove all arranged subviews
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
        arrangedSubviews.removeAll()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let containerWidth = bounds.width - padding.left - padding.right
        var currentX = padding.left
        var currentY = padding.top
        var rowHeight: CGFloat = 0
        
        for view in arrangedSubviews {
            // Get the view's intrinsic content size instead of using sizeToFit()
            let viewSize = view.intrinsicContentSize
            
            // Check if we need to wrap to the next line
            if currentX + viewSize.width > containerWidth && currentX > padding.left {
                // Move to the next line
                currentX = padding.left
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            // Position the view
            view.frame = CGRect(
                x: currentX,
                y: currentY,
                width: viewSize.width,
                height: viewSize.height
            )
            
            // Update position for the next view
            currentX += viewSize.width + spacing
            rowHeight = max(rowHeight, viewSize.height)
        }
        
        // Update the frame height to fit all content
        let newHeight = currentY + rowHeight + padding.bottom
        if frame.size.height != newHeight {
            frame.size.height = newHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        if arrangedSubviews.isEmpty {
            return CGSize(width: UIView.noIntrinsicMetric, height: padding.top + padding.bottom)
        }
        
        var height: CGFloat = 0
        if let lastView = arrangedSubviews.last {
            height = lastView.frame.maxY + padding.bottom
        }
        
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
} 