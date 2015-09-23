# UIHeaderTabs
Simple Swift 2.0 nib and protocols to implement header tabs in any iOS application.

![Example](/UIHeaderTabsExample/Example.png?raw=true)

## Including UIHeaderTabs Your App

Add the UIHeaderTabs folder to your app. (There is no Carthage or Cocoapods option, sorry).

## Implementing UIHeaderTabs in Your App

You will need at least two pages to implement header tabs - a parent tab groups page, and a child tab page. Your parent tab groups page will need to implement the TabGroupsControllable protocol and the UIView will need to have a UIHeaderTabs placeholder element as well as a Page Controller placeholder element. The child tab page will need to implement the TabGroupControllable protocol. There are examples of both in UIHeaderTabsExample.


### Implementing TabGroupsControllable Protocol

#### Required parameters:

- **var tabs: UIHeaderTabs!** - from an @IBOutlet placeholder
- **var pageControllerWrapper: UIView!** - from an @IBOutlet placeholder
- **var orderedGroups: \[String\]** - a list of strings to use as tab titles
- **var controllerStoryboards: \[String\]** - the storyboard names to use as tab content. These can all be the same if they are going to a shared table view controller, or all different if you have multiple pages you'd like to show in tabs. *Note: Because I use IBIncludedStoryboard in all my apps, this is not configured to use same-storyboard scene identifiers (although it would be easy enough to change it to do so). Put your tab content into a separate storyboard and use that filename in this list. If you need to invoke a segue in the main storyboard from the child tab page, you can use: groupsController?.performSegueWithIdentifier("My Segue Identifier", sender: nil).*

Please add the following additional parameters as-is, so TabGroupsControllable can use them:

    var pageViewController: UIPageViewController?
    var controllers: [UIViewController] = []
    var currentIndex = 0

#### Required functions:

Please add the following functions as-is, to call TabsGroupsControllable functions on delegation calls (protocols can't function as delegates, alas):


    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return handlePageViewController(pageViewController, viewControllerBeforeViewController: viewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return handlePageViewController(pageViewController, viewControllerAfterViewController: viewController)
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        handlePageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }

Additionally, you will need to call setupTabGroups() inside your viewDidLoad()


### Implementing TabGroupControllable Protocol

#### Required parameters:

- **var group: String** - a default tab title (will be set by TabGroupsControllable parent)
- **var groupIndex: Int** - a default tab index (will be set by TabGroupsControllable parent)
- **weak var groupsController: UIViewController?** - do not initialize: this will be set by TabGroupsControllable parent. You can use it yourself, however, whenever you want to call out to the parent tabs group page.
    
    
    
    