//
//  ContactsViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 01.09.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    
    private var isPreparedForQuit: Bool = false;    
    var contacts: Array<Dictionary<String, String>>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User.initiateUser()
        self.contacts = user.contacts
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    private func configureUI() {
        
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = UIColor.black
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
    }
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "contactCell",
                                                      for: indexPath)
            as! ContactsTableViewCell
        
        cell.nameLabel.text = contacts?[indexPath.row]["name"] ?? "You don't have a contacts yet"
        cell.phoneNumberLabel.text = contacts?[indexPath.row]["phoneNumber"] ?? "You can add some by pressing the button at the top"
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let degree: Double = 90
        let rotationAngle = CGFloat(degree * Double.pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 1, 0, 0)
        
        cell.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 0.3, delay: 0.1 * Double (indexPath.row), options: .curveEaseInOut, animations: {
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }    
    
}
