//
//  ProblemChooserViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 22.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit

class ProblemChooserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ProblemProvider {
    
    var user: User?
    var problems = Array<Problem>()
    var isProblemSelected: Bool = false
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var problemsCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.retrieveData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureUI()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.problems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "problemCell", for: indexPath) as? ProblemCollectionViewCell else {
            
            return  UICollectionViewCell()
        }
        
        cell.problemLabel.text = (self.problems[indexPath.row] as Problem).title
        cell.problemImageView.image = (self.problems[indexPath.row] as Problem).image
        
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        return cell;
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: ProblemCollectionViewCell = collectionView.cellForItem(at: indexPath) as! ProblemCollectionViewCell
        
        guard let problem = self.problems[indexPath.row] as? Problem else { return }
        
        print("Problem type = \(problem.type)")
        
        var x: Double = 0
        var y: Double = 0
        var problemTitle: String = ""
        var problemImage: String = ""
        
        self.provideRandomCoordinates(X: &x,
                                   Y: &y,
                                   withTitle: &problemTitle,
                                   andImageName: &problemImage,
                                   forType: problem.type)
        
        cell.layer.backgroundColor = UIColor.red.cgColor
        
        if !isProblemSelected {
            let alertController = UIAlertController(title: cell.problemLabel.text, message: NSLocalizedString(Constants.CONFIRM_HELP_REQUEST_TITLE, comment: ""), preferredStyle: .alert)
            
            var text: String = ""
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Optional description"
            }
            
            let okAction = UIAlertAction(title: NSLocalizedString(Constants.ASK_FOR_HELP, comment: ""), style: .default) {
                [weak self] (action) in
                
                self?.isProblemSelected = !(self?.isProblemSelected)!
                
                FIRFirestoreService.shared.createHelpRequest(
                    id: "1",
                    type: "\(problem.type)",
                    title: problemTitle,
                    image: problemImage,
                    xCoordinate: "\(x)",
                    yCoordinate: "\(y)",
                    description: alertController.textFields?.first?.text ?? ""
                )
                
                self?.performSegue(withIdentifier: "iNeedHelp", sender: nil)                
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString(Constants.CANCEL_HELP_REQUEST, comment: ""), style: .cancel, handler: {
                (action) in
                cell.layer.backgroundColor = UIColor.clear.cgColor
            })
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            cell.layer.backgroundColor = UIColor.clear.cgColor
            self.isProblemSelected = !isProblemSelected
        }
        
    }
    
    private func configureUI() {
        
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = UIColor.clear
        }
        
        self.backgroundImageView.image = UIImage(named: "beaconman")
        self.backgroundImageView.alpha = 0.1
        
        self.titleLabel.text = NSLocalizedString(Constants.WHAT_HAPPENED, comment: "")
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseInOut, animations: {
            [weak self] in
            self?.titleLabel.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 100, 0)
        }, completion: nil)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    private func retrieveData() {
        self.problems = self.provideProblemsDefault() // how often happens
    }
    
    private func provideRandomCoordinates(X x: inout Double, Y y: inout Double, withTitle title: inout String, andImageName image: inout String, forType type: Int){
        
        x = 53.901837 + Double(arc4random_uniform(10)) / 10
        y = 27.458999 + Double(arc4random_uniform(10)) / 10
        
        if (type < Problem.typesDescription.count){
            title = Problem.typesDescription[type]["title"]!
            image = Problem.typesDescription[type]["image"]!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let destinationVC as HelpViewController = segue.destination,
            segue.identifier == "iNeedHelp" {
            destinationVC.role = 0
        }
    }
}
