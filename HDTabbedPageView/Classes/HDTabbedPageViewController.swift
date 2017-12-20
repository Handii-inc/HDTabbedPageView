import UIKit

/**
 Page view controller with tab.
 */
open class HDTabbedPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    //MARK:- Properties
    public weak var dataSource: HDTabbedPageViewControllerDataSource?

    public weak var indicator: HDTabbedPageViewIndicator?

    public weak var style: HDTabbedPageViewControllerStyle?
    
    //MARK:- Sub components
    private lazy var segmentedView: UIView = {
        let view = UIView()
        self.view.backgroundColor = .clear
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self,
                          action: #selector(self.valueChanged(sender:)),
                          for: .valueChanged)
        control.backgroundColor = .clear
        control.tintColor = .clear
        return control
    }()
    
    private var contents: UIView {
        get {
            return self.pageViewController.view
        }
    }
    
    //MARK:- Sub controllers
    private lazy var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        controller.delegate = self
        controller.dataSource = self
        return controller
    }()
    
    //MARK:- Life cycle events
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.segmentedView)
        self.segmentedView.addSubview(self.segmentedControl)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.contents)
        self.didMove(toParentViewController: self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let dataSourceNotNil = self.dataSource else {
            return
        }

        guard let indicatorNotNil = self.indicator else {
            return
        }
        
        let segmented = (self.segmentedView, self.segmentedControl)
        
        Initializer.initialize(indicator: indicatorNotNil,
                               on: segmented,
                               by: dataSourceNotNil)
        Initializer.initialize(segmented: segmented,
                               with: self.style,
                               by: dataSourceNotNil)
        Initializer.initialize(pageViewController: self.pageViewController,
                               by: dataSourceNotNil)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let topGapOfSegment = self.style?.topGapOfTab ?? 0
        let bottomGapOfSegment = self.style?.bottomGapOfTab ?? 0

        self.segmentedView.frame = CGRect(x: 0,
                                          y: topGapOfSegment,
                                          width: self.view.frame.width,
                                          height: self.style?.heightOfTab ?? 45)
        self.segmentedControl.frame = CGRect(x: 0,
                                             y: 0,
                                             width: self.segmentedView.frame.width,
                                             height: self.segmentedView.frame.height)
        self.indicator?.asView().frame = self.segmentedControl.frame
        
        let contentHeight
            = self.view.frame.height
            - (topGapOfSegment + self.segmentedControl.frame.height + bottomGapOfSegment)
        self.contents.frame = CGRect(x: 0,
                                     y: self.segmentedView.frame.maxY + bottomGapOfSegment,
                                     width: self.segmentedView.frame.width,
                                     height: contentHeight)
        
        return
    }
    
    //MARK:- UIPageViewControllerDataSource
    open func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        return self.pageViewController(viewController: viewController,
                                       offset: -1)
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController,
                                 viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        return self.pageViewController(viewController: viewController,
                                       offset: 1)
    }
    
    //MARK:- UIPageViewControllerDelegate
    open func pageViewController(_ pageViewController: UIPageViewController,
                                 didFinishAnimating finished: Bool,
                                 previousViewControllers: [UIViewController],
                                 transitionCompleted completed: Bool)
    {
        if !completed {
            return
        }
        
        guard let viewModel = self.dataSource else {
            return
        }

        guard let previous = previousViewControllers.first else {
            return
        }

        guard let current = pageViewController.viewControllers?.first else {
            return
        }
        
        if (previous.isEqual(current)) {
            return  //no change.
        }
        
        guard let idx = viewModel.controllers.index(of: current) else {
            return
        }
        
        self.segmentedControl.selectedSegmentIndex = idx
        self.indicator?.selected(index: self.segmentedControl.selectedSegmentIndex) //operate indicator.

        return
    }
    
    //MARK:- Privates
    private class Initializer {
        /**
         Initialize indicator area.
            - Note: Call by viewWillAppear
         */
        static func initialize(indicator: HDTabbedPageViewIndicator,
                               on segmented: (UIView, UISegmentedControl),
                               by dataSource: HDTabbedPageViewControllerDataSource)
        {
            let (area, control) = segmented
            indicator.setCount(count: dataSource.count)
            area.insertSubview(indicator.asView(),
                               belowSubview: control)   //Don't move to viewDidLoad. Indicator object has set after viewDidLoad.
            return
        }
        
        /**
         Initialize segmented control area.
         - Note: Call by viewWillAppear
         */
        static func initialize(segmented: (UIView, UISegmentedControl),
                               with style: HDTabbedPageViewControllerStyle?,
                               by dataSource: HDTabbedPageViewControllerDataSource)
        {
            let (_, control) = segmented
            
            control.removeAllSegments()
            (0..<dataSource.count).forEach{ i in
                let title = dataSource.titles[i]
                control.insertSegment(withTitle: title, at: i, animated: false)
            }
            control.selectedSegmentIndex = 0
            
            guard let styleNotNil = style else {
                return  //do nothing
            }
            let attributes: [NSAttributedStringKey : Any] = [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: styleNotNil.textSizeOfTab),
                NSAttributedStringKey.foregroundColor: styleNotNil.textColorOfTab
            ]
            control.setTitleTextAttributes(attributes,
                                           for: .normal)
            
            return
        }
        
        /**
         Initialize contents area.
         - Note: Call by viewWillAppear
         */
        static func initialize(pageViewController: UIPageViewController,
                               by dataSource: HDTabbedPageViewControllerDataSource)
        {
            guard let firstController = dataSource.controllers.first else {
                return
            }
            pageViewController.setViewControllers([firstController],
                                                  direction: .forward,
                                                  animated: false,
                                                  completion: nil)
            return
        }
    }
    
    private func pageViewController(viewController: UIViewController,
                                    offset: Int) -> UIViewController?
    {
        guard let viewModel = self.dataSource else {
            return nil
        }
        
        guard let idx = viewModel.controllers.index(of: viewController) else {
            return nil
        }
        
        let offsetIdx = idx + offset
        
        if offsetIdx < 0 || viewModel.count <= offsetIdx {
            return nil
        }
        
        return viewModel.controllers[offsetIdx]
    }
    
    @objc private func valueChanged(sender: UISegmentedControl)
    {
        guard let viewModel = self.dataSource else {
            return
        }
        
        guard let current = pageViewController.viewControllers?.first else {
            return
        }

        guard let currentIdx = viewModel.controllers.index(of: current) else {
            return
        }
        
        let idx = sender.selectedSegmentIndex

        self.view.isUserInteractionEnabled = false
        self.turnPages(from: currentIdx,
                       to: idx,
                       controllers: viewModel.controllers)
        self.indicator?.selected(index: idx) //operate indicator.
        return
    }
    
    private func turnPages(from: Int,
                           to: Int,
                           controllers: [UIViewController])
    {
        let direction: UIPageViewControllerNavigationDirection = (from < to) ? .forward : .reverse
        let next = (direction == .forward) ? from + 1 : from - 1
        let isEnd = (next == to)

        let completion = { [unowned self] (_: Bool) in
            if isEnd {
                self.view.isUserInteractionEnabled = true
            }
        }
        self.pageViewController.setViewControllers([controllers[next]],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: completion)
        if isEnd {
            return
        }
        
        self.turnPages(from: next, to: to, controllers: controllers)
        return
    }
}
