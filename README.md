# UIHeaderTabs
Simple Swift 2.0 nib and protocols to implement header tabs in any iOS application.

![Example](/UIHeaderTabsExample/Example.png?raw=true)

## Latest Update 2016-02-20

I removed the secondary child view controller protocol, *TabGroupControllable*, and replaced *controllerStoryboards* and *controllers* list with a function *tabControllersInitializer* to create each controller for each tab. I renamed many of the protocol variables to be more specific to tabs. Added some boundaries to the individual tab nib, so that it does not overflow its space (although you may want to switch the tabs nib UIStackView to use proportional spacing rather than equal spacing if you have a mix of large/small tabs that won't fit inside boxes divided equally - but the idea is that you wholly customize the nibs to your own app anyway).

## Including UIHeaderTabs Your App

Add the UIHeaderTabs folder to your app. (There is no Carthage or Cocoapods option, sorry).

## Implementing UIHeaderTabs in Your App

You will need at least two pages to implement header tabs - a parent tab groups page, and a child tab page. Your parent tab groups page will need to implement the TabGroupsControllable protocol and the UIView will need to have a UIHeaderTabs placeholder element as well as a Page Controller placeholder element. The child tab page will need to implement the TabGroupControllable protocol. There are examples of both in UIHeaderTabsExample.


### Implementing TabGroupsControllable Protocol

#### Required parameters:

- **var tabs: UIHeaderTabs!** - from an @IBOutlet placeholder
- **var tabsContentWrapper: UIView!** - from an @IBOutlet placeholder
- **var tabNames: \[String\]** - a list of strings to use as tab titles
- **func tabControllersInitializer(tabName: String) -> UIViewController?** - returns an instantiated view controller to display under that tab. See the example project for examples - it is not hard to do.

Please add the following additional parameters as-is, so TabGroupsControllable can use them:

    var tabsPageViewController: UIPageViewController?
    var tabControllers: [UIViewController] = []
    var tabCurrentIndex = 0

#### Required functions:

Please add the following functions as-is, to call TabsGroupsControllable functions on delegation calls (protocols can't function as delegates, alas):


    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return handleTabsPageViewController(pageViewController, viewControllerBeforeViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return handleTabsPageViewController(pageViewController, viewControllerAfterViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        handleTabsPageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }

Additionally, you will need to call setupTabs() inside your viewDidLoad()
    
    
    
    