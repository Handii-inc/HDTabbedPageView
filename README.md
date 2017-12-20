# HDTabbedPageView

[![CI Status](http://img.shields.io/travis/Handii-inc/HDTabbedPageView.svg?style=flat)](https://travis-ci.org/Handii-inc/HDTabbedPageView)
[![Version](https://img.shields.io/cocoapods/v/HDTabbedPageView.svg?style=flat)](http://cocoapods.org/pods/HDTabbedPageView)
[![License](https://img.shields.io/cocoapods/l/HDTabbedPageView.svg?style=flat)](http://cocoapods.org/pods/HDTabbedPageView)
[![Platform](https://img.shields.io/cocoapods/p/HDTabbedPageView.svg?style=flat)](http://cocoapods.org/pods/HDTabbedPageView)
[![codebeat badge](https://codebeat.co/badges/74eeaebf-49a4-425c-96bf-13b10008c161)](https://codebeat.co/projects/github-com-handii-inc-hdtabbedpageview-master)

## Description
Inspired by [TabPageViewController](https://github.com/EndouMari/TabPageViewController).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can use it with inheritance of HDTabbedPageViewController and implementation of HDTabbedPageViewControllerimplementation and HDTabbedPageViewControllerStyle.

It's very easy as the following.

```swift
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

    //MARK:- Helper
    private static func createSampleViewController(_ title: String,
                                                   _ color: UIColor) -> UIViewController
    {
        let controller = UIViewController()
        controller.title = title
        controller.view.backgroundColor = color
        return controller
    }
}
```

## Customize

You can easy to customize this library.

### HDTabbedPageViewControllerDataSource

There are two optional interfaces except controllers.

- count : The number of data source. It is the default implementation to return controllers.count.
- titles : The titles of controllers. It is the default implementation to return titles of controllers.

### HDTabbedPageViewControllerStyle

There are optional interfaces except textColorOfTab.

- textSizeOfTab : The color of tab of text. 
- heightOfTab : The height of tab.(default 45)
- topGapOfTab : The gap of the top of tab.(default 0)
- bottomGapOfTab : The gap of the bottom of tab.(default 0)

### HDTabbedPageViewIndicator

This is the protocol for indicator.
When you create implementation of this protocol, you should create as subclass of UIView.

There are two reference implementation, please refer them if you want to implement your customize one.
Those are Underline and RoundedRect.

## Installation

HDTabbedPageView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HDTabbedPageView'
```

## Author

Handii, Inc. github@handii.co.jp

## License

HDTabbedPageView is available under the MIT license. See the LICENSE file for more info.
