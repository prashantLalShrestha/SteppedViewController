//
//  SteppedContainerViewController.swift
//  SteppedViewController
//
//  Created by Prashant Shrestha on 5/23/20.
//  Copyright © 2020 Inficare. All rights reserved.
//

import UIKit
import CocoaUI
import FlexibleSteppedProgressBar

open class SteppedContainerViewController: ViewController, SteppedViewControllerDelegate, FlexibleSteppedProgressBarDelegate {
    
    private(set) public var viewControllers: [SteppedViewController]? {
        didSet {
            viewControllers?.forEach({
                if $0.buttonTapDelegate == nil {
                    $0.buttonTapDelegate = self
                }
                if $0.stepBar == nil {
                    $0.stepBar = steppedProgressBar
                }
            })
        }
    }
    private(set) public var currentIndex: Int? {
        didSet {
            if let currentIndex = currentIndex, let viewController = viewControllers?[currentIndex] {
                delegate?.steppedViewController(viewController, didMoveTo: currentIndex)
            }
        }
    }
    
    public var delegate: SteppedContainerViewControllerDelegate?
    
    lazy var steppedProgressbarContainerView: UIView = {
        let view = UIView()
        return view
    }()
    public lazy var steppedProgressBar: SteppedProgressBar = {
        let view = SteppedProgressBar()
        
        view.lineHeight = 1
        view.radius = 8
        view.progressRadius = 9
        view.selectedOuterCircleLineWidth = 2
        view.progressLineHeight = 1
        view.textDistance = 9
        view.stepAnimationDuration = 0.16
        view.centerLayerTextColor = UIColor.clear
        view.centerLayerDarkBackgroundTextColor = UIColor.clear
        view.delegate = self
        return view
    }()
    lazy var separaterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    lazy var containerNavigationController: NavigationController = {
        let viewController = NavigationController()
        viewController.isNavigationBarHidden = true
        return viewController
    }()
    
    public init(viewControllers: [SteppedViewController], title: String) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: Bundle(for: SteppedContainerViewController.self))
        viewControllers.forEach({
            $0.buttonTapDelegate = self
            $0.stepBar = steppedProgressBar
        })
        self.navigationTitle = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        super.viewWillAppear(animated)
    }
    
    public override func makeUI() {
        super.makeUI()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.addSubview(steppedProgressbarContainerView)
        steppedProgressbarContainerView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            steppedProgressbarContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            steppedProgressbarContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            steppedProgressbarContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        } else {
            steppedProgressbarContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            steppedProgressbarContainerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            steppedProgressbarContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
        
        steppedProgressbarContainerView.addSubview(steppedProgressBar)
        steppedProgressBar.translatesAutoresizingMaskIntoConstraints = false
        steppedProgressBar.topAnchor.constraint(equalTo: steppedProgressbarContainerView.topAnchor, constant: 8).isActive = true
        steppedProgressBar.centerXAnchor.constraint(equalTo: steppedProgressbarContainerView.centerXAnchor).isActive = true
        steppedProgressBar.heightAnchor.constraint(equalToConstant: 24).isActive = true
        steppedProgressBar.bottomAnchor.constraint(equalTo: steppedProgressbarContainerView.bottomAnchor, constant: -24).isActive = true
        
        if let count = viewControllers?.count, count >= 2 {
            steppedProgressBar.numberOfPoints = count
        } else {
            steppedProgressBar.numberOfPoints = 2
        }
        let steppedProgressCount = steppedProgressBar.numberOfPoints
        let progressBarWidth = view.frame.width * CGFloat(Double(steppedProgressCount) - 0.72) / CGFloat(steppedProgressCount)
        
        steppedProgressBar.widthAnchor.constraint(equalToConstant: progressBarWidth).isActive = true
        
        steppedProgressbarContainerView.addSubview(separaterView)
        separaterView.translatesAutoresizingMaskIntoConstraints = false
        separaterView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separaterView.bottomAnchor.constraint(equalTo: steppedProgressbarContainerView.bottomAnchor).isActive = true
        separaterView.leftAnchor.constraint(equalTo: steppedProgressbarContainerView.leftAnchor).isActive = true
        separaterView.rightAnchor.constraint(equalTo: steppedProgressbarContainerView.rightAnchor).isActive = true
        
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: steppedProgressbarContainerView.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            containerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        } else {
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            containerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }


        self.addChild(containerNavigationController)
        containerView.addSubview(containerNavigationController.view)
        containerNavigationController.didMove(toParent: self)
        containerNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        containerNavigationController.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        containerNavigationController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        containerNavigationController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        containerNavigationController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true

        if let firstViewController = viewControllers?.first {
            containerNavigationController.pushViewController(firstViewController, animated: true)
            currentIndex = 0
        }
    }
    
    public func moveToNextViewController() {
        if let viewControllers = viewControllers, let currentIndex = currentIndex, currentIndex < viewControllers.count - 1 {
            let nextIndex = currentIndex + 1
            delegate?.steppedViewController(viewControllers[nextIndex], willMoveTo: nextIndex)
            viewControllers[currentIndex].navigationController?.pushViewController(viewControllers[nextIndex], animated: true)
            self.currentIndex = nextIndex
            steppedProgressBar.currentIndex = nextIndex
        }
    }
    
    public func moveToPreviousViewController() {
        if let viewControllers = viewControllers, let currentIndex = currentIndex, currentIndex > 0 {
            let nextIndex = currentIndex - 1
            delegate?.steppedViewController(viewControllers[nextIndex], willMoveTo: nextIndex)
            viewControllers[currentIndex].navigationController?.popViewController(animated: true)
            self.currentIndex = nextIndex
            steppedProgressBar.currentIndex = nextIndex
        }
    }
    
    public func dismissSteppedNavigationController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public func progressBar(_ progressBar: FlexibleSteppedProgressBar, textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if position == FlexibleSteppedProgressBarTextLocation.bottom {
            if let viewControllers = viewControllers {
                return viewControllers[index].title ?? viewControllers[index].navigationTitle
            } else {
                return ""
            }
        } else if position == FlexibleSteppedProgressBarTextLocation.center {
            if viewControllers != nil {
                return "\(index + 1)"
            } else {
                return ""
            }
        }
        return ""
    }
}
