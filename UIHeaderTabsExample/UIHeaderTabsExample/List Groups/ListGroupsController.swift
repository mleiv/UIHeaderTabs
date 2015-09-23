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

    @IBOutlet weak var tabs: UIHeaderTabs!
    @IBOutlet weak var pageControllerWrapper: UIView!
    
    var pageLoaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in orderedGroups.indices {
            controllerStoryboards.append("List")
        }
        print(orderedGroups)
        setupTabGroups()
        pageLoaded = true
    }
    
    // MARK: TabGroupsControllable protocol
    
    var pageViewController: UIPageViewController?
    var controllers: [UIViewController] = []
    var controllerStoryboards: [String] = []
    var orderedGroups: [String] = ["Friends", "Enemies"]
    var currentIndex = 0
   
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return handlePageViewController(pageViewController, viewControllerBeforeViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return handlePageViewController(pageViewController, viewControllerAfterViewController: viewController)
    }
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        handlePageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, transitionCompleted: completed)
    }
}
