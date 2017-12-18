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

        self.initializeIndicator()
        self.initializeSegementedControl()
        self.initializeContents()
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
    /**
     Initialize indicator area.
     - Note: Call by viewWillAppear
     */
    private func initializeIndicator()
    {
        guard let indicatorNotNil = self.indicator else {
            return
        }
        
        if let count = self.dataSource?.count {
            indicatorNotNil.setCount(count: count)
        }
        
        self.segmentedView.insertSubview(indicatorNotNil.asView(),
                                         belowSubview: self.segmentedControl)   //Don't move to viewDidLoad. Indicator object has set after viewDidLoad.
        return
    }

    /**
     Initialize segmented control area.
     - Note: Call by viewWillAppear
     */
    private func initializeSegementedControl()
    {
        guard let data = self.dataSource else {
            return
        }
        
        self.segmentedControl.removeAllSegments()
        (0..<data.count).forEach{ i in
            let title = data.titles[i]
            self.segmentedControl.insertSegment(withTitle: title, at: i, animated: false)
        }
        self.segmentedControl.selectedSegmentIndex = 0
        
        guard let styleNotNil = self.style else {
            return  //do nothing
        }
        let attributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: styleNotNil.textSizeOfTab),
            NSAttributedStringKey.foregroundColor: styleNotNil.textColorOfTab
        ]
        self.segmentedControl.setTitleTextAttributes(attributes,
                                                     for: .normal)
        
        return
    }
    
    /**
     Initialize contents area.
     - Note: Call by viewWillAppear
     */
    private func initializeContents()
    {
        guard let firstController = self.dataSource?.controllers.first else {
            return
        }
        self.pageViewController.setViewControllers([firstController],
                                                   direction: .forward,
                                                   animated: false,
                                                   completion: nil)
        return
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
        let enableInteraction = { [unowned self] (_ isComplete: Bool) -> Void in
            if isComplete {
                self.view.isUserInteractionEnabled = true
            }
        }
        
        self.turnPages(from: currentIdx,
                       to: idx,
                       controllers: viewModel.controllers,
                       completion: enableInteraction)
        self.indicator?.selected(index: idx) //operate indicator.
        return
    }
    
    private func turnPages(from: Int,
                           to: Int,
                           controllers: [UIViewController],
                           completion: @escaping (Bool) -> Void)
    {
        let direction: UIPageViewControllerNavigationDirection = (from < to) ? .forward : .reverse
        let next = (direction == .forward) ? from + 1 : from - 1
        let isEnd = (next == to)

        self.pageViewController.setViewControllers([controllers[next]],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: isEnd ? completion : nil)
        if isEnd {
            return
        }
        
        self.turnPages(from: next, to: to, controllers: controllers, completion: completion)
        return
    }
}
