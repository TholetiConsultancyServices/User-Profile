//
//  LoginViewController.swift
//  
//
//  Created by Appaji Tholeti on 22/03/2017.
//
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginService: LoginServiceProtocol?
    var loginCompletionHandler: (()->Void)?
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var activityindicator: UIActivityIndicatorView!
    
    private func showLoginFailedAlert() {
        let alert = UIAlertController(title: "Login failed",
                                      message: "Please enter correct login details and make sure that internet is working",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        activityindicator.startAnimating()
        view.isUserInteractionEnabled = false
        loginService?.login(withEmail: emailTextField.text!,
                            password: passwordTextField.text!,
                            completionHandler: {[weak self] (result) in
                                
                                DispatchQueue.main.async {
                                    guard let strongSelf = self else {
                                        return
                                    }
                                    strongSelf.view.isUserInteractionEnabled = true
                                    strongSelf.activityindicator.stopAnimating()
                                    switch result {
                                    case .Success(_):
                                        strongSelf.loginCompletionHandler?()
                                    case .Failure(_):
                                        strongSelf.showLoginFailedAlert()
                                    }
                                }
        })
    }
    
    
}
