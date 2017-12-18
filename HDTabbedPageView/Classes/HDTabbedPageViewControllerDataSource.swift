import UIKit

/**
 Data source of the controller.
 */
public protocol HDTabbedPageViewControllerDataSource: class {
    /**
     Controllers of contents.
     */
    var controllers: [UIViewController] { get }
    
    /**
     The number of data source.
     - Note: This method has default implementation.
     */
    var count: Int { get }

    /**
     The titles of controllers.
     - Note: This method has default implementation.
     */
    var titles: [String] { get }
}

/**
 Default implementation of HDTabbedPageViewControllerDataSource.
 */
public extension HDTabbedPageViewControllerDataSource {
    var count: Int {
        get {
            return self.controllers.count
        }
    }
    
    var titles: [String] {
        get {
            return self.controllers.map{ c in
                guard let title = c.title else {
                    return ""
                }
                return title
            }
        }
    }
}
