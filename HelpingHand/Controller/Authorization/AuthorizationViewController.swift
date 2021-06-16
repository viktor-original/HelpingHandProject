//
//  AuthorizationViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 24.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var greetingPicture: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var currentUser : User?
    
    // MARK: - Authorization
    @IBAction func signInTapped(_ sender: UIButton) {
        handleSignIn()
    }
    
    func handleSignIn() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            
            let alertController = UIAlertController(title: NSLocalizedString(Constants.AUTHORIZATION_ERROR, comment: ""), message: NSLocalizedString(Constants.INCORRECT_INPUT, comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion:
            { [weak self](user, error) in
                if user != nil {
                    
                    FIRFirestoreService.shared.readUserCompletion = { [weak self](user) in
                        self?.currentUser = user                        
                        self?.update(user: self!.currentUser!)
                    }
                    
                    FIRFirestoreService.shared.getUser()                    
                    
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "Logged In")
                    
                    let mainTabBarViewController = self?.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                    self?.present(mainTabBarViewController!, animated: true)
                    
                } else {
                    let alertController = UIAlertController(title: NSLocalizedString(Constants.AUTHORIZATION_ERROR, comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
        })
        
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForKeyboardNotifications()
        self.configureUI()
    }
    
    // MARK: - NSNotifications
    private func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func unregisterForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification){
        let offset = self.loginButton.frame.size.height + self.registerButton.frame.size.height + 40
        
        scrollView.contentOffset = CGPoint(x: 0, y: offset)
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    
    // MARK: - UI configuration
    private func configureUI() {
        
        self.emailTextField.alpha = 0
        self.emailTextField.isHidden = false
        self.emailTextField.isOpaque = false
        self.emailTextField.layer.cornerRadius = 8
        self.emailTextField.layer.borderWidth = 1.0
        self.emailTextField.layer.borderColor = UIColor.black.cgColor
        self.emailTextField.placeholder = NSLocalizedString(Constants.USERNAME, comment: "")
        
        self.passwordTextField.alpha = 0
        self.passwordTextField.isHidden = false
        self.passwordTextField.isOpaque = false
        self.passwordTextField.layer.cornerRadius = 8
        self.passwordTextField.layer.borderWidth = 1.0
        self.passwordTextField.layer.borderColor = UIColor.black.cgColor
        self.passwordTextField.placeholder = NSLocalizedString(Constants.PASSWORD, comment: "")
        
        self.loginButton.alpha = 0
        self.loginButton.isHidden = false
        self.loginButton.isOpaque = false
        
        self.greetingPicture.isOpaque = false
        self.greetingPicture.layer.masksToBounds = true
        
        self.loginButton.layer.cornerRadius = 8
        self.loginButton.layer.backgroundColor = UIColor.black.cgColor
        self.loginButton.setTitle(NSLocalizedString(Constants.SIGN_IN, comment: ""), for: .normal)
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            
            self.backgroundImageView.image = UIImage(named: "beaconman")
            self.backgroundImageView.alpha = 0.1
            
            self.emailTextField.alpha = 1.0
            self.passwordTextField.alpha = 1.0
            self.greetingPicture.alpha = 1.0
            self.loginButton.alpha = 1.0
            
        }, completion: nil)
    }    
    
    private func update(user: User){
        
        let defaults = UserDefaults.standard
        
        defaults.set(user.firstName, forKey: "firstName")
        defaults.set(user.lastName, forKey: "lastName")
        defaults.set("advent", forKey: "avatar")
        defaults.set(user.age, forKey: "age")
        defaults.set(user.sex!.rawValue, forKey: "sex")
        defaults.set(user.email, forKey: "email")
        defaults.set(user.phoneNumber, forKey: "phoneNumber")
        defaults.set(user.contacts, forKey: "contacts")
    }
    
    deinit {
        self.unregisterForKeyboardNotifications()
    }
}
