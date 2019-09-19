//
//  LoginViewController.swift
//  SampleProject
//
//  Created by Kacy Weakley on 9/18/19.
//  Copyright © 2019 ashby thornwell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        setupUsernameTextField()
        setupPasswordTextField()
        setupLoginButton()
    }
    
    func setupLabels() {
        logInLabel.font = logInLabel.font.withSize(21)
        logInLabel.text = "Log In"
        usernameLabel.text = "Username"
        usernameLabel.textColor = UIColor.lightGray
        passwordLabel.text = "Password"
        passwordLabel.textColor = UIColor.lightGray
    }
    
    func setupUsernameTextField() {
        usernameTextField.placeholder = "Enter your username"
        usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        usernameTextField.autocorrectionType = UITextAutocorrectionType.no
        usernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        usernameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    func setupPasswordTextField() {
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.autocorrectionType = UITextAutocorrectionType.no
        passwordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        passwordTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    func setupLoginButton() {
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = UIColor.tabItemBlue()
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        doLogin(username: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    func doLogin(username: String, password: String) {
        if isValidUser(username: username, password: password) {
            performSegue(withIdentifier: "loginSegue", sender: self)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Failed to login, please check username/password!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
            usernameTextField.text = ""
            passwordTextField.text = ""
        }
    }
    
    func isValidUser(username: String, password: String) -> Bool {
        return true
//        loginWithUserName(username: username, password: password)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
