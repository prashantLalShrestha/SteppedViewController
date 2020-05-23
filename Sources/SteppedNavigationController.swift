//
//  SteppedNavigationController.swift
//  SteppedViewController
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import CocoaUI

open class SteppedNavigationController: NavigationController {
    
    public init(viewControllers: [SteppedViewController], title: String) {
        let steppedViewController = SteppedContainerViewController(viewControllers: viewControllers, title: title)
        super.init(nibName: nil, bundle: nil)
        viewControllers.forEach({ $0.steppedNavigationController = self })
        self.pushViewController(steppedViewController, animated: true)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
