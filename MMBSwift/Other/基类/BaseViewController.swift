//
//  BaseViewController.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/7/30.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    var backBarItem : UIBarButtonItem?{
        willSet{

        }
        didSet{
            self.navigationItem.leftBarButtonItem = backBarItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController != nil {
            if (self.navigationController?.viewControllers.count)! > 1 {
                backBarItem = UIBarButtonItem(image: UIImage(named: "back_white"), style: .plain, target: self, action: #selector(backClick))
                self.navigationItem.leftBarButtonItem = backBarItem
            }
        }
        
        
//        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
//        let pan = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition")))
//        pan.delegate = self
//        self.view.addGestureRecognizer(pan)
//        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
//                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
//        UIGestureRecognizer) -> Bool {
//        if self.children.count == 1 {
//            return false
//        }
//        return true
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension BaseViewController {
    @objc func backClick(){
        self.navigationController?.popViewController(animated: true)
    }
}

