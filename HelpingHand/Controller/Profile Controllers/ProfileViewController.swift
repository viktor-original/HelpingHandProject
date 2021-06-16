//
//  ProfileViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 27.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var fullNameLabel: UILabel!    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var requisitesTableView: UITableView!
    @IBOutlet weak var requisitesTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        
        UserDefaults.standard.set(false, forKey: "Logged In")       
        
        self.dismiss(animated: true)
        present((self.storyboard?.instantiateViewController(withIdentifier: "AuthNavigationViewController"))!, animated: true, completion: nil)
    }
    
    var user : User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.user = User.initiateUser()
        self.configureUI()
        self.requisitesTableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return user!.filledRequisitesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            self.requisitesTableView.dequeueReusableCell(withIdentifier: "profileCell",
                                                         for: indexPath)
                as! ProfileTableViewCell
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        
        switch indexPath.row {
        case 0:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.EMAIL, comment: "")
            cell.requisiteLabel.text = "\(self.user!.email)"
        case 1:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.FIRST_NAME, comment: "")
            cell.requisiteLabel.text = self.user!.firstName!
        case 2:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.LAST_NAME, comment: "")
            cell.requisiteLabel.text = self.user!.lastName!
        case 3:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.AGE, comment: "")
            cell.requisiteLabel.text = "\(self.user!.age!)"
        case 4:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.SEX, comment: "")
            cell.requisiteLabel.text = "\(self.user!.sex!.rawValue)"
        case 5:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.PHONE_NUMBER, comment: "")
            cell.requisiteLabel.text = "\(self.user!.phoneNumber!)"
        default:
            cell.requisiteTitleLabel.text  = NSLocalizedString(Constants.DEFAULT_TITLE, comment: "")
            cell.requisiteLabel.text = ""
        }
        
        return cell;
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {     
        
        let translationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -500, 0)
        cell.layer.transform = translationTransform
        
        UIView.animate(withDuration: 0.6, delay: 0.2 * Double (indexPath.row), options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    private func configureUI() {
        
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = UIColor.clear
        }
        
        self.requisitesTableView.tableFooterView = UIView()
        
        self.backgroundImageView.image = UIImage(named: "beaconman")
        self.backgroundImageView.alpha = 0.1
        
        self.requisitesTableView.estimatedRowHeight = 20
        self.requisitesTableView.rowHeight = UITableViewAutomaticDimension
        self.requisitesTableView.backgroundView?.layer.backgroundColor = UIColor.clear.cgColor
        
        self.fullNameLabel.text = user!.fullName
        
        self.avatarImageView.image = user!.avatar
        self.avatarImageView.layer.borderWidth = 1
        self.avatarImageView.layer.cornerRadius = 8
        self.avatarImageView.layer.masksToBounds = true
        self.avatarImageView.layer.borderColor = UIColor.black.cgColor
        
        
        self.settingsButton.layer.borderWidth = 1
        self.settingsButton.layer.borderColor = UIColor.black.cgColor
        self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2
        
        self.logOutButton.layer.borderWidth = 1
        self.logOutButton.layer.borderColor = UIColor.black.cgColor
        self.logOutButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2
    }
    
    private func retrieveData (){
        
    }
}
