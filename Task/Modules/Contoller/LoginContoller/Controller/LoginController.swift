//
//  LoginController.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

class LoginController: BaseController {
    
    
    @IBOutlet weak var registerOrLoginSwith: UISwitch!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - Setup
    private func setup() {
        title = "Login"
        navigationItem.leftBarButtonItem = nil
    }
    
    //MARK: - Actions
    @IBAction func actionLogin(_ sender: UIButton) {
        if registerOrLoginSwith.isOn {
            RestAuth().register(withСallName: viewControllerName,
                            body: ["email":emailTextField.text ?? "",
                                   "password":passwordTextField.text ?? ""],
                            success: { [weak self] (model) in
                                guard let `self` = self else { return }
                                TaskRouter(presenter: self.navigationController).pushTaskController()
                                
                })
        } else {
            RestAuth().auth(withСallName: viewControllerName,
                            body: ["email":emailTextField.text ?? "",
                                   "password":passwordTextField.text ?? ""],
                            success: { [weak self] (model) in
                                guard let `self` = self else { return }
                                TaskRouter(presenter: self.navigationController).pushTaskController()
            })
        }
    }
}

// MARK: - UITextFieldDelegate

/// TODO: добавить валидацию для TextField
extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField{
            textField.resignFirstResponder()
            return true
        } else {
            passwordTextField.becomeFirstResponder()
            return false
        }
    }
}
