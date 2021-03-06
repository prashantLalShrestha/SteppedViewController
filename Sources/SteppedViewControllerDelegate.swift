//
//  SteppedViewControllerDelegate.swift
//  SteppedViewController
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import Foundation


public protocol SteppedViewControllerDelegate: class {
    func moveToNextViewController()
    func moveToPreviousViewController()
    func dismissSteppedNavigationController()
}


public protocol SteppedContainerViewControllerDelegate: class {
    func steppedViewController(_ steppedViewController: SteppedViewController, willMoveTo index: Int)
    func steppedViewController(_ steppedViewController: SteppedViewController, didMoveTo index: Int)
}
