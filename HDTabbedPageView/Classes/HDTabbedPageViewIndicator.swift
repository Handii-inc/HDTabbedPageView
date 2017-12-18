import UIKit


/**
 Interface for indicator. Please implement me, if you want to create your original indicator.
 - note: When you create implementation of this, you should inherit UIView, too.
 */
public protocol HDTabbedPageViewIndicator: class {
    /**
     Set max count of tab items. Please implement me as the following, for example.
     ```swift
     func setCount(count: Int)
     {
        self.count = count  //store count.
     }
     ```
     */
    func setCount(count: Int)

    /**
     Implementation to this add animation to the indicator.
     - Parameters:
        - index: selected index of tab item.
     */
    func selected(index: Int)
    
    /**
     This protocol expect to inject to class that is inherit UIView.
     This interface is often used by controller that want to regard this object as sub component, for example UIViewController.
     Therefore this interface is very easy to implementation, only inheritance UIView and returning self. See the following.
     ```
     class SomeIndicator: UIView, HDTabbedPageViewIndicator {
        func asView() -> UIView
        {
            return self
        }
     }
     ```
     */
    func asView() -> UIView
}
