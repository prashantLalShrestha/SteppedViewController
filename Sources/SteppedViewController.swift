//
//  SteppedViewController.swift
//  SteppedViewController
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import CocoaUI

open class SteppedViewController: ViewController {
    public var buttonTapDelegate: SteppedViewControllerDelegate?
    public var steppedNavigationController: SteppedNavigationController?
    public var stepBar: SteppedProgressBar?
}
