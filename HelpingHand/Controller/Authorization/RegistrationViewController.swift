//
//  RegistrationViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 01.09.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegistrationViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    // MARK: - Registration
    @IBAction func registerTapped(_ sender: UIButton) {
        handleRegister()
    }
    
    func handleRegister() {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let firstName = firstNameTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let lastName = lastNameTextField.text
        else {
            let alertController = UIAlertController(title: NSLocalizedString(Constants.REGISTRATION_ERROR, comment: ""), message: NSLocalizedString(Constants.INCORRECT_INPUT, comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        guard email != "", password != "", firstName != "", lastName != "", phoneNumber != ""
        else {
            let alertController = UIAlertController(title: NSLocalizedString(Constants.REGISTRATION_ERROR, comment: ""), message: NSLocalizedString(Constants.EMPTY_INPUT, comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //User registration
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion:
            { (user, error) in
                if user != nil {
                    let mainTabBarViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController")
                    self.present(mainTabBarViewController!, animated: true)
                    UserDefaults.standard.set(true, forKey: "Logged In")
                    
                    //Adding user to db
                    FIRFirestoreService.shared.createUser(email: email, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
                    
                } else {
                    print(error!)
                }
        })
    }
    
    // Dismiss the keyboard when the view is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
        self.phoneNumberTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
    }
    
    private func configureUI() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.backgroundImageView.image = UIImage(named: "beaconman")
        self.backgroundImageView.alpha = 0.1
        
        self.setBlackRoundedBorders(toView: firstNameTextField)
        self.setBlackRoundedBorders(toView: lastNameTextField)
        self.setBlackRoundedBorders(toView: phoneNumberTextField)
        self.setBlackRoundedBorders(toView: emailTextField)
        self.setBlackRoundedBorders(toView: passwordTextField)
        self.setBlackRoundedBorders(toView: registrationButton)
        
        self.registrationButton.setTitle(NSLocalizedString(Constants.REGISTER, comment: ""), for: .normal)
    }
    
    private func setBlackRoundedBorders(toView view: UIView){
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
    }
    
}
