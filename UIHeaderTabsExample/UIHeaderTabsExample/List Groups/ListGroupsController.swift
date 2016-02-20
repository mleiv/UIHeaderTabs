//
//  ListGroupsController.swift
//
//  Created by Emily Ivie on 9/22/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

import UIKit

class ListGroupsController: UIViewController, TabGroupsControllable {

    var pageLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        pageLoaded = true
    }
    
    // MARK: TabGroupsControllable protocol
    
    @IBOutlet weak var tabs: UIHeaderTabs!
    @IBOutlet weak var tabsContentWrapper: UIView!
    
    var tabNames: [String] = ["Friends", "Enemies"]
    
    func tabControllersInitializer(tabName: String) -> UIViewController? {
        let bundle = NSBundle(forClass: self.dynamicType)
        switch tabName {
            case "Friends":
                let controller = UIStoryboard(name: "List", bundle: bundle).instantiateInitialViewController() as? ListController
                // set some custom values here (mine happen to be trivial):
                controller?.group = "Friends"
                return controller
            case "Enemies":
                // can use any controller/storyboard here (mine happen to be the same):
                let controller = UIStoryboard(name: "List", bundle: bundle).instantiateInitialViewController() as? ListController
                controller?.group = "Enemies"
                return controller
            default: return nil
        }
    }
    
    // only used internally:
    var tabsPageViewController: UIPageViewController?
    var tabControllers: [String: UIViewController] = [:]
    var tabCurrentIndex: Int = 0
   
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return handleTabsPageViewController(pageViewController, viewControllerBeforeViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return handleTabsPageViewController(pageViewController, viewControllerAfterViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        handleTabsPageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
}
