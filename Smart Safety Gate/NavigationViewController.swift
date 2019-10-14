//
//  NavigationViewController.swift
//  Smart Safety Gate
//
//  Created by Joseph Shonle on 10/14/19.
//  Copyright © 2019 Joseph Shonle. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    let settings = UserDefaults.standard
    var closeButton: [UIBarButtonItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.leftBarButtonItems = closeButton
    }
    
    func initCloseButton(){
        let leftButton = UIButton(type: .custom)
        //let image = UIImage(named: "backbutton")?.withRenderingMode(.alwaysTemplate)
        //let image = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        //leftButton.setImage(image, for: .normal)
        leftButton.tintColor = UIColor.white
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.addTarget(self, action: #selector(dismissRegion), for: .touchUpInside)
        leftButton.setTitle("Close", for: .normal)
        //leftButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 6.0, 0.0, -6.0)
        //leftButton.contentEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 6.0)
        leftButton.sizeToFit()
        
        let negativeSpacer : UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //negativeSpacer.width = -7
        
        closeButton = [negativeSpacer, UIBarButtonItem(customView: leftButton) ]
    }

    @objc func dismissRegion() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

