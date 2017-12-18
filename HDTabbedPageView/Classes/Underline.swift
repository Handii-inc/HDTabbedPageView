import UIKit

/**
 Underline indicator.
 */
public class Underline: UIView, HDTabbedPageViewIndicator {
    //MARK:- UIView
    
    /**
     Initializer.
     - Parameters:
        - color: Underline color.
        - height: The thickness of height.
        - ratioOfWidth: The ratio of width.
     */
    public init(color: UIColor,
                height: CGFloat,
                ratioOfWidth: CGFloat)
    {
        self.height = height
        self.ratioOfWidth = ratioOfWidth
        super.init(frame:.zero)
        self.backgroundColor = color
        self.layer.cornerRadius = self.height * 0.5
    }
    
    /**
     Convenience initializer.
     - Parameters:
        - color: Underline color.
     */
    convenience public init(color: UIColor)
    {
        self.init(color: color,
                  height: 3,
                  ratioOfWidth: 1)
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
        
        self.frame = CGRect(x: self.gap * 0.5,
                            y: superFrame.height - self.height,
                            width: width,
                            height: self.height)
    }
    
    //MARK:- HDTabbedPageViewIndicator
    public func setCount(count: Int)
    {
        self.count = count
        return
    }
    
    public func selected(index: Int)
    {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = self.gap * 0.5 + self.widthOfBounds * CGFloat(index)
        }
        
        return
    }

    public func asView() -> UIView
    {
        return self
    }
    
    //MARK:- Privates
    private let ratioOfWidth: CGFloat
    private let height: CGFloat
    private var count: Int = 0
    private var widthOfBounds: CGFloat {
        get {
            guard let superFrame = self.superview?.frame else {
                return 0
            }
            
            return superFrame.width / CGFloat(self.count)
        }
    }
    private var width: CGFloat {
        get {
            return self.widthOfBounds * self.ratioOfWidth
        }
    }
    private var gap: CGFloat {
        get {
            return (self.widthOfBounds - self.width)
        }
    }
}

