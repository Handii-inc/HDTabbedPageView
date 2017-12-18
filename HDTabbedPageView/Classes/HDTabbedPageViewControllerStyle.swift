import UIKit

/**
 Tab style protocol.
 */
public protocol HDTabbedPageViewControllerStyle: class {
    /**
     The color of tab of text.
     */
    var textColorOfTab: UIColor { get }

    /**
     The color of tab of text.
     - Note: This method has default implementation.
     */
    var textSizeOfTab: CGFloat { get }
    
    /**
     The height of tab.
     - note: This method has default implementation.
     */
    var heightOfTab: CGFloat { get }
    
    /**
     The gap of the top of tab.
     - note: This method has default implementation.
     */
    var topGapOfTab: CGFloat { get }

    /**
     The gap of the bottom of tab.
     - note: This method has default implementation.
     */
    var bottomGapOfTab: CGFloat { get }
}

/**
 Default implementation of HDTabbedPageViewControllerStyle.
 */
public extension HDTabbedPageViewControllerStyle {
    var textSizeOfTab: CGFloat {
        get {
            return 16
        }
    }
    
    var heightOfTab: CGFloat {
        get {
            return 45
        }
    }
    
    var topGapOfTab: CGFloat {
        get {
            return 0
        }
    }
    
    var bottomGapOfTab: CGFloat {
        get {
            return 0
        }
    }
}
