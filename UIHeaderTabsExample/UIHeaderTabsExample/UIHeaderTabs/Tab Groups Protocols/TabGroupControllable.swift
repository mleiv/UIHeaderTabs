//
//  TabGroupControllable.swift
//
//  Created by Emily Ivie on 9/23/15.
//  Copyright © 2015 urdnot.

//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

//

import UIKit

// implemented by individual tab pages
public protocol TabGroupControllable: class {
    // implement in controller:
    var group: String { get set }
    var groupIndex: Int { get set }
    var groupsController: UIViewController? { get set }
}