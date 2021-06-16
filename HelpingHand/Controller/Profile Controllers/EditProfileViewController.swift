//
//  EditProfileViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 02.09.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var firstNameTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTitleLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var ageTitleLabel: UILabel!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var sexTitleLabel: UILabel!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var phoneNumberTitleLabel: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var applyChangesButton: UIButton!
    
    var user = User.initiateUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureUI()
    }
    
    @IBAction func applyChanges(_ sender: UIButton) {
        
        var newFirstName = ""
        
        if let firsName = self.firstNameTextField.text {
            newFirstName = firsName
        }
        
        var newLastname = ""
        if let lastName = self.lastNameTextField.text {
            newLastname = lastName
        }
        
        
        var newAge : UInt?
        if let age = ageTextField.text {
            newAge = UInt(age) ?? 0
        }
        
        let newSex = self.sexSegmentedControl.selectedSegmentIndex
        var newSexString = ""
        switch newSex {
        case 0:
            newSexString = NSLocalizedString(Constants.MALE, comment: "")
        case 1:
            newSexString = NSLocalizedString(Constants.FEMALE, comment: "")
        default:
            newSexString = NSLocalizedString(Constants.MALE, comment: "")
        }
        
        var newEmail = ""
        if let email = self.emailTextField.text {
            newEmail = email
        }
        
        let newAvatar = self.avatarImageView.image
        
        
        var newPhoneNumber = ""
        if let phone = self.phoneNumberTextField.text {
            newPhoneNumber = phone
        }
        
        self.updateUser(firstname: newFirstName, lastName: newLastname, age: newAge!, sex: newSexString, email: newEmail, phoneNumber: newPhoneNumber)
    }
    
    private func configureUI(){
        
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = UIColor.clear
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.backgroundImageView.image = UIImage(named: "beaconman")
        self.backgroundImageView.alpha = 0.1
        
        self.avatarImageView.image = self.user.avatar
        self.setBlackRoundedBorders(toView: avatarImageView)
        self.avatarImageView.layer.masksToBounds = true
        
        
        self.fullNameLabel.text = self.user.fullName
        
        self.firstNameTextField.text = self.user.firstName
        self.setBlackRoundedBorders(toView: firstNameTextField)
        
        self.lastNameTextField.text = self.user.lastName
        self.setBlackRoundedBorders(toView: lastNameTextField)
        
        if let sureAge = self.user.age {
            self.ageTextField.text = "\(sureAge)"
        } else {
            self.ageTextField.text = "0"
        }
        
        self.setBlackRoundedBorders(toView: ageTextField)
        
        self.emailTextField.text = self.user.email
        self.setBlackRoundedBorders(toView: emailTextField)
        
        self.phoneNumberTextField.text = self.user.phoneNumber
        self.setBlackRoundedBorders(toView: phoneNumberTextField)
        
        switch self.user.sex! {
        case User.Sex.male:
            self.sexSegmentedControl.setEnabled(true, forSegmentAt: 0)
        case User.Sex.female:
            self.sexSegmentedControl.setEnabled(true, forSegmentAt: 1)
        default:
            self.sexSegmentedControl.setEnabled(true, forSegmentAt: 0)
        }
        
        self.sexSegmentedControl.setTitle(NSLocalizedString(Constants.MALE, comment: ""), forSegmentAt: 0)
        self.sexSegmentedControl.setTitle(NSLocalizedString(Constants.FEMALE, comment: ""), forSegmentAt: 1)
        self.sexSegmentedControl.layer.cornerRadius = 8
        
        self.applyChangesButton.setTitle(NSLocalizedString(Constants.APPLY_CHANGES_BUTTON, comment: ""), for: .normal)
        self.setBlackRoundedBorders(toView: applyChangesButton)
        
    }
    
    private func updateUser(firstname: String,
                            lastName: String,
                            age: UInt,
                            sex: String,
                            email: String,
                            phoneNumber: String){
        
        let defaults = UserDefaults.standard
        
        let contacts = [
            ["name":"Мама", "phoneNumber":"телефон мамы"],
            ["name":"Папа", "phoneNumber":"телефон папы"],
            ["name":"Колян", "phoneNumber":"телефон Коляна"]
        ]
        
        defaults.set(firstname, forKey: "firstName")
        defaults.set(lastName, forKey: "lastName")
        defaults.set("advent", forKey: "avatar")
        defaults.set(age, forKey: "age")
        defaults.set(sex, forKey: "sex")
        defaults.set(email, forKey: "email")
        defaults.set(phoneNumber, forKey: "phoneNumber")
        defaults.set(contacts, forKey: "contacts")
    }
    
    private func setBlackRoundedBorders(toView view: UIView){
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
    }

}
