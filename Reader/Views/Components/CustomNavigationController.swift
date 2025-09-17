//
//  CustomNavigationController.swift
//  Reader
//
//  Created by Ashutosh Muraskar on 17/09/25.
//

import UIKit

final class CustomNavigationController: UINavigationController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

  
        interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.hidesBackButton = true
       

        super.pushViewController(viewController, animated: animated)
    }

   
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {}
