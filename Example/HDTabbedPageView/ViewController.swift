import UIKit
import HDTabbedPageView

class ViewController: HDTabbedPageViewController, HDTabbedPageViewControllerDataSource, HDTabbedPageViewControllerStyle {
    //MARK:- Sub components.
    private let roundedRect = RoundedRect(color: .orange, padding: 5)
    
    //MARK:- Life cycle events.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.dataSource = self
        self.style = self
        self.indicator = self.roundedRect
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.frame = UIScreen.main.bounds
    }

    //MARK:- HDTabbedPageViewControllerDataSource
    var controllers: [UIViewController] = [
        ViewController.createSampleViewController("Red", .red),
        ViewController.createSampleViewController("Cyan", .cyan),
        ViewController.createSampleViewController("Green", .green),
    ]
    
    //MARK:- HDTabbedPageViewControllerStyle
    var textColorOfTab: UIColor {
        get {
            return .black
        }
    }
    
    var topGapOfTab: CGFloat {
        get {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    private static func createSampleViewController(_ title: String,
                                                   _ color: UIColor) -> UIViewController
    {
        let controller = UIViewController()
        controller.title = title
        controller.view.backgroundColor = color
        return controller
    }
}
