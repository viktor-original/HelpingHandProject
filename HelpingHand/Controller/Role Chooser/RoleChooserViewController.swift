//
//  RoleChooserViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov  on 24.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class RoleChooserViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seekHelpImageView: UIImageView!
    @IBOutlet weak var helpSomeOneImageView: UIImageView!
    
    private var isFirstAppear: Bool = true
    var user: User?
    
    enum Role: String {
        case helper
        case seeker
    }
    
    var seekHelpRecognizer: UITapGestureRecognizer?
    var helpSomeOneRecognizer: UITapGestureRecognizer?
    
    @objc func seekHelp(_ recognizer: UITapGestureRecognizer){
        performSegue(withIdentifier: "seekHelpSegue", sender: nil)
    }
    
    @objc func helpSomeOne(_ recognizer: UITapGestureRecognizer){        
        performSegue(withIdentifier: "helpSomeoneSegue", sender: nil)
    }
    
    override func awakeFromNib() {
        FIRFirestoreService.shared.readUserCompletion = { [weak self](user) in
            self?.user = user            
            User.update(user: user)
        }
        
        FIRFirestoreService.shared.getUser()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()      
        
        self.seekHelpRecognizer = UITapGestureRecognizer(target: self, action: #selector(seekHelp))
        self.helpSomeOneRecognizer = UITapGestureRecognizer(target: self, action: #selector(helpSomeOne))
        
        self.seekHelpImageView.addGestureRecognizer(seekHelpRecognizer!)
        self.helpSomeOneImageView.addGestureRecognizer(helpSomeOneRecognizer!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.isFirstAppear = false
    }
    
    func configureUI(){
        
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = UIColor.clear
        }
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.backgroundImageView.image = UIImage(named: "beaconman")
        self.backgroundImageView.alpha = 0.1
        
        self.seekHelpImageView.layer.cornerRadius = 8
        self.helpSomeOneImageView.layer.cornerRadius = 8
        
        self.titleLabel.text = NSLocalizedString(Constants.CHOOSE_ROLE, comment: "")
        
        if (self.isFirstAppear){
            self.seekHelpImageView.alpha = 0
            self.helpSomeOneImageView.alpha = 0
            let translationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -self.titleContainerView.frame.size.height, 0)
            self.titleLabel.layer.transform = translationTransform
            
            UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                [weak self] in
                self?.titleLabel.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, (self?.titleContainerView.frame.size.height)! * 0.75, 0)
            }, completion: { [weak self] (true) in
                self?.highlight(imageViews: [self!.seekHelpImageView , self!.helpSomeOneImageView])
            })
        }
        
    }
    
    private func highlight(imageViews: [UIImageView]){
        
        for counter in stride(from: 0, to: imageViews.count, by: 1) {
            
            let imageView = imageViews[counter]
            UIView.animate(withDuration: 0.5, delay: TimeInterval(Double(counter) + 0.5), options: .curveEaseInOut, animations: {
                imageView.alpha = 1
                //                imageView.backgroundColor = UIColor.orange
            }, completion: {
                (true) in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    imageView.alpha = 0.5
                    //                    imageView.backgroundColor = UIColor.clear
                }, completion: {
                    (true) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                        imageView.alpha = 1
                    }, completion: nil)
                })
            })
            
            
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let destinationVC as HelpViewController = segue.destination,
            segue.identifier == "helpSomeoneSegue" {
            destinationVC.role = 1
        }
    }
    
}
