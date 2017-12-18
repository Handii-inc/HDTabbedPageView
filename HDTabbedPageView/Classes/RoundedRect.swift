import UIKit

/**
 Rounded rectangle indicator.
 */
public class RoundedRect: UIView, HDTabbedPageViewIndicator {
    //MARK:- UIView

    /**
     Initializer.
     - Parameters:
        - color: Underline color.
        - padding: The length of the padding.
     */
    public init(color: UIColor,
                padding: CGFloat)
    {
        self.padding = padding
        super.init(frame:.zero)
        self.backgroundColor = color
    }
    
    /**
     Convenience initializer.
     - Parameters:
        - color: Rectangle color.
     */
    convenience public init(color: UIColor)
    {
        self.init(color: color,
                  padding: 0)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews()
    {
        super.layoutSubviews()
        
        guard let superFrame = self.superview?.frame else {
            return
        }
        
        let rect = CGRect(x: 0,
                          y: 0,
                          width: superFrame.width / CGFloat(self.count),
                          height: superFrame.height)
        let insets = UIEdgeInsets(top: self.padding,
                                  left: self.padding,
                                  bottom: self.padding,
                                  right: self.padding)
        self.frame = UIEdgeInsetsInsetRect(rect, insets)
        self.layer.cornerRadius = (rect.height - self.padding * 2) * 0.5
    }
    
    //MARK:- HDTabbedPageViewIndicator
    public func setCount(count: Int)
    {
        self.count = count
        return
    }
    
    public func selected(index: Int)
    {
        guard let superFrame = self.superview?.frame else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = self.padding + CGFloat(index) * superFrame.width / CGFloat(self.count)
        }
        
        return
    }
    
    public func asView() -> UIView
    {
        return self
    }
    
    //MARK:- Privates
    private let padding: CGFloat
    private var count: Int = 0
}
