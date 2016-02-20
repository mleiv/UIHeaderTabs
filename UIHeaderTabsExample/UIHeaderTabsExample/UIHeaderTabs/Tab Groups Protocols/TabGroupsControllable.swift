//
//  TabGroups.swift
//
//  Created by Emily Ivie on 9/23/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

//

import UIKit

// implemented by tab groups top-level page
public protocol TabGroupsControllable: class, UIPageViewControllerDataSource, UIPageViewControllerDelegate {//, UINavigationControllerDelegate {

    // implement in controller:
    var tabs: UIHeaderTabs! { get } // @IBOutlet
    var tabsContentWrapper: UIView! { get } // @IBOutlet
    var tabNames: [String] { get }
    func tabControllersInitializer(tabName: String) -> UIViewController?
    // only used internally:
    var tabsPageViewController: UIPageViewController? { get set }
    var tabControllers: [String: UIViewController] { get set }
    var tabCurrentIndex: Int { get set }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)

    // public, but require no additional code in implementing controller
    func setupTabs()
    func handleTabsPageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    func handleTabsPageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    func handleTabsPageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func switchToTab(controller: UIViewController)
}

extension TabGroupsControllable where Self: UIViewController {

    public func setupTabs() {
        setupTabPages()
        setupTabsPageControl()
        setupTabsPageViewController()
    }
    
    private func selectNewTabIndex() -> Int {
        return 0
    }
    
    private func setupTabPages() {
        for tabName in tabNames {
            let tabController = tabControllersInitializer(tabName) ?? UIViewController() // fill index no matter what
            tabControllers[tabName] = tabController
        }
    }

    private func setupTabsPageControl() {
        tabs.segments = tabNames.count
        tabs.segmentTitles = tabNames.joinWithSeparator(",")
        tabs.selectedSegmentIndex = tabCurrentIndex
        tabs.onClick = { [weak self] index in
            let tabName = self?.tabNames[index] ?? ""
            if let tabController = self?.tabControllers[tabName] {
                self?.switchToTab(tabController)
            }
        }
    }

    private func setupTabsPageViewController() {
        let currentIndex = tabCurrentIndex < tabNames.count ? tabCurrentIndex : 0
        guard let currentController = tabControllers[tabNames[currentIndex]]
        else {
            return
        }
        let tabsPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        tabsPageViewController.dataSource = self
        tabsPageViewController.delegate = self
        tabsPageViewController.setViewControllers([currentController], direction: .Forward, animated: false, completion: nil)
        tabsPageViewController.willMoveToParentViewController(self)
        self.addChildViewController(tabsPageViewController)
        tabsPageViewController.didMoveToParentViewController(self)
        tabsContentWrapper.addSubview(tabsPageViewController.view)
        tabsPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tabsPageViewController.view.leadingAnchor.constraintEqualToAnchor(tabsContentWrapper.leadingAnchor).active = true
        tabsPageViewController.view.trailingAnchor.constraintEqualToAnchor(tabsContentWrapper.trailingAnchor).active = true
        tabsPageViewController.view.topAnchor.constraintEqualToAnchor(tabsContentWrapper.topAnchor).active = true
        tabsPageViewController.view.bottomAnchor.constraintEqualToAnchor(tabsContentWrapper.bottomAnchor).active = true
        self.tabsPageViewController = tabsPageViewController
    }

    public func handleTabsPageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        if let tabName = tabControllers.keys.filter(({ self.tabControllers[$0] === viewController})).first,
            index = tabNames.indexOf(tabName) {
            tabCurrentIndex = index
            let prevIndex = tabCurrentIndex - 1
            if 0..<tabControllers.count ~= prevIndex {
                let prevController = tabControllers[tabNames[prevIndex]]
                return prevController
            }
        }
        return nil
    }

    public func handleTabsPageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        if let tabName = tabControllers.keys.filter(({ self.tabControllers[$0] === viewController})).first,
            index = tabNames.indexOf(tabName) {
            tabCurrentIndex = index
            let nextIndex = tabCurrentIndex + 1
            if 0..<tabControllers.count ~= nextIndex {
                let nextController = tabControllers[tabNames[nextIndex]]
                return nextController
            }
        }
        return nil
    }

    public func handleTabsPageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    
        if completed, let
            controller = pageViewController.viewControllers?.last,
            tabName = tabControllers.keys.filter(({ self.tabControllers[$0] === controller})).first,
            index = tabNames.indexOf(tabName) {
            tabCurrentIndex = index
            tabs.selectedSegmentIndex = tabCurrentIndex
        }
    }
    
    public func switchToTab(controller: UIViewController) {
        var direction = UIPageViewControllerNavigationDirection.Forward
        if let tabName = tabControllers.keys.filter(({ self.tabControllers[$0] === controller})).first,
            index = tabNames.indexOf(tabName) {
            guard index != tabCurrentIndex else {
                return // do nothing
            }
            direction = index > tabCurrentIndex ? .Forward : .Reverse
            tabCurrentIndex = index
            tabs.selectedSegmentIndex = tabCurrentIndex
        }
        tabsPageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: { finished in
            dispatch_async(dispatch_get_main_queue(), {
                self.tabsPageViewController?.setViewControllers([controller], direction: .Forward, animated: false, completion: nil)
            })
        })
    }}