//
//  HelpViewController.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 22.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import UIKit
import MapKit

class HelpViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
        
    /*
    
     1. ViewController - делегат протокола MKMapViewDelegate;
     2. Установите широту и долготу местоположений;
     3. Создайте объекты - метки, содержащие метки координаты местоположения;
     4. MKMapitems используются для маршрутизации. Этот класс инкапсулирует информацию о конкретной точке на карте;
     5. Добавляются аннотации, которые отображают названия меток;
     6. Аннотации отображаются на карте;
     7 .Класс MKDirectionsRequest используется для вычисления маршрута;
     8. Маршрут будет нарисован с использованием полилинии по наложенному на карту верхнему слою. Область установлена, поэтому будут видны обе локации;
     
    */
    @IBOutlet weak var mapView: MKMapView!
    
    private var choosenProblemId: String = ""
    private var problems: Array<Problem>?
    
    let locationManager = CLLocationManager()
    var role: Int?
    
    var isAlreadyHelping = false {
        didSet{
            let info = UIAlertController(title: NSLocalizedString(Constants.INFO, comment: ""),
                                         message: NSLocalizedString(Constants.NAVIGATE_TO, comment: ""),
                                         preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                [weak self](action) in
                self?.locationManager.startUpdatingLocation()
            }
            info.addAction(okAction)
            self.present(info, animated: true, completion: nil)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        FIRFirestoreService.shared.readHelpRequestCompletion = { problemList in
            self.problems = problemList
        }
        
        if let currentRole = self.role {
            switch currentRole {
            case 0:
                FIRFirestoreService.shared.getSelfHelpRequests()
            case 1:
                FIRFirestoreService.shared.getAllHelpRequests()
            default:
                FIRFirestoreService.shared.getAllHelpRequests()
            }
        }
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }       
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D =
            manager.location?.coordinate else { return }
        
        // MARK: - Change when running on real device!
        let sourceLocation = CLLocationCoordinate2D(latitude: 53.908852, longitude: 27.522740)
        //        let sourceLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = NSLocalizedString(Constants.YOU_ARE_HERE, comment: "")
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        var annotations = [MKAnnotation]()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        ////////////
        
        
        ////////////
        annotations.append(sourceAnnotation)
        
        if !self.isAlreadyHelping {
            guard let problemList = self.problems else { return }
            
            if problemList.count != 0  {
                for problem in problemList {
                    
                    guard let problemX = problem.xCoordinate else { continue }
                    guard let problemY = problem.yCoordinate else { continue }
                    
                    let latitude = CLLocationDegrees.init(problemX)
                    let longitude = CLLocationDegrees.init(problemY)
                    
                    let currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let annotation = MKPointAnnotation()
                    
                    var title = NSLocalizedString(problem.title, comment: "")
                    title += "\n\n"
                    title += problem.description ?? ""
                    annotation.title = NSLocalizedString(title, comment: "")
                    annotation.subtitle = problem.id!
                    
                    let placemark = MKPlacemark(coordinate: currentLocation, addressDictionary: nil)
                    
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                    }
                    
                    annotations.append(annotation)
                }
                
                self.mapView.showAnnotations(annotations, animated: true)
            } else {
                self.mapView.showAnnotations([sourceAnnotation], animated: true)
            }
        } else {
            
            for problem in self.problems! {
                if problem.id == self.choosenProblemId {
                    
                    guard let problemX = problem.xCoordinate else { continue }
                    guard let problemY = problem.yCoordinate else { continue }
                    
                    let latitude = CLLocationDegrees.init(problemX)
                    let longitude = CLLocationDegrees.init(problemY)
                    
                    let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    
                    let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
                    
                    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
                    
                    let destinationAnnotation = MKPointAnnotation()
                    destinationAnnotation.title = NSLocalizedString(problem.title, comment: "")
                    
                    if let location = destinationPlacemark.location {
                        destinationAnnotation.coordinate = location.coordinate
                    }
                    
                    self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
                    
                    let directionRequest = MKDirectionsRequest()
                    directionRequest.source = sourceMapItem
                    directionRequest.destination = destinationMapItem
                    directionRequest.transportType = .automobile
                    
                    // Calculate the direction
                    let directions = MKDirections(request: directionRequest)
                    
                    directions.calculate {
                        (response, error) -> Void in
                        
                        guard let response = response else {
                            if let error = error {
                                print("Error: \(error)")
                            }
                            return
                        }
                        
                        let route = response.routes[0]
                        self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                        
                        let rect = route.polyline.boundingMapRect
                        self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                    }
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let role = self.role else { return }
        guard let annotation = view.annotation else { return }
        
        var alert = UIAlertController()
        
        switch role {
        case 0:
            alert = UIAlertController(title: view.annotation?.title ?? "", message: view.annotation?.subtitle ?? "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
        case 1:
            alert =
                UIAlertController(title: "",
                                  message: "",
                                  preferredStyle: .actionSheet)
            
            let title = NSMutableAttributedString(string: NSLocalizedString(Constants.OFFER_HELP, comment: ""), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
            alert.setValue(title, forKey: "attributedTitle")
            
            let message = NSMutableAttributedString(string: (view.annotation?.title)! ?? "", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16)])
            alert.setValue(message, forKey: "attributedMessage")
            
            let helpAction = UIAlertAction(title: NSLocalizedString(Constants.HELP, comment: "") ,
                                           style: .default) {[weak self](action) in
                FIRFirestoreService.shared.setHelperId(docId: annotation.subtitle as! String)
                self?.isAlreadyHelping = true
                self?.choosenProblemId = annotation.subtitle as! String
                self?.locationManager.stopUpdatingLocation()
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString(Constants.CANCEL_HELP_REQUEST, comment: ""),
                                             style: .destructive, handler: nil)
            
            alert.addAction(helpAction)
            alert.addAction(cancelAction)
            
            if let popoverPresentationController = alert.popoverPresentationController {
                popoverPresentationController.sourceView = view
                popoverPresentationController.sourceRect = view.bounds
            }
            
        default:
            break
        }
       
        
        
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignFirstResponder()
    }
    
    
    
}
