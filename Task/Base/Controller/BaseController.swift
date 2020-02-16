//
//  BaseController.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

class BaseController: UIViewController, UIGestureRecognizerDelegate {
    
    func setupTapOnScreen() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(hideKeyboard))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /// Bottom view constraint for keyboard
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    
    var correction: CGFloat = 0.0
    var keyboardHeight: CGFloat = 0.0
    
    var isShowKeyboard = false
    var isHideTabBar = false
    var isPortrait = true
    var isHideNavigationBarBottomLine = false
    var isHideNavigationBar = false
    var isDisappearShowNavigationBar = true
    var navBarColor = Constant.Color.navigationBar
    
    var isSetWillAppearColor = true
    var isSetWillDisappearColor = true

    var addTapOnScreen: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = true
        }
        
        if isHideNavigationBarBottomLine {
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
        navigationController?.setNavigationBarHidden(isHideNavigationBar, animated: false)
        
        if isSetWillAppearColor && UIApplication.topViewController() == self {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
        
        UIViewController.attemptRotationToDeviceOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UIApplication.topViewController() == self {
            navigationController?.navigationBar.barTintColor = navBarColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = false
        }
        
        if isHideNavigationBar && isDisappearShowNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
    }
    
    /// Keyboard will hide
    ///
    /// - parameter notification: object notification
    @objc func keyboardWillHide(_ notification : Notification) {
        if bottomViewConstraint != nil {
            bottomViewConstraint!.constant = 0
            keyboardHeight = 0
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /// Keyboard will show
    ///
    /// - parameter notification: object notification
    @objc func keyboardWillShow(_ notification: Notification) {
        isShowKeyboard = true
        
        if bottomViewConstraint != nil {
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let bottomPadding: CGFloat = {
                
                let tabBarHieght: CGFloat = tabBarController?.tabBar.frame.size.height ?? 0
                
                if tabBarHieght == 0 || (tabBarController?.tabBar.isHidden ?? false) {
                    if #available(iOS 11.0, *) {
                        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                    } else {
                        return 0
                    }
                } else {
                    return tabBarHieght
                }
                
            } ()
            

            keyboardHeight = keyboardFrame.size.height
            
            bottomViewConstraint.constant = keyboardHeight - bottomPadding + correction

            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: -
    // MARK: setup
    
    private func setup() {
        
        if addTapOnScreen {
            setupTapOnScreen()
        }
        
        navigationItem.backBarButtonItem?.title = ""
        
        backBarButton()
        
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func backBarButton() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_icon"), style: .plain, target: self, action: #selector(actionBack))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    @objc func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /// Hide keyboard
    @objc func hideKeyboard() {
        isShowKeyboard = false
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        debugPrint(" didReceiveMemoryWarning ----->>>> \(viewControllerName)")
    }
    
    deinit {
        debugPrint(" deinit ----->>>> \(viewControllerName)")
        NotificationCenter.default.removeObserver(self)
    }
}
