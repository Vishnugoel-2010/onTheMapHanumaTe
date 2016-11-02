//
//  EnterLocationViewController.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 23/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EnterLocationViewController: UIViewController , UITextFieldDelegate , MKMapViewDelegate{
    
    @IBOutlet weak var whereYouStudying: UILabel!
    
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var enterTheLink: UITextField!
    
    @IBOutlet weak var BackButton: UIBarButtonItem!
    @IBOutlet weak var CancelButton: UIBarButtonItem!
    
    @IBOutlet weak var findOnTheMap: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var LoadingMap: UIActivityIndicatorView!
    @IBOutlet weak var myLocation: UITextField!
    @IBOutlet weak var mapLocationView: MKMapView!
    let connectivity = NetPrase()
    var coordinate: CLLocationCoordinate2D!
    var annotation: [MKPointAnnotation] = []
    
    var userLocation = [CLPlacemark]()
    var studentLocationName = ""
    var studentLat = CLLocationDegrees()
    var studentLon = CLLocationDegrees()
    override func viewDidLoad() {
        LoadingMap.isHidden = true
       

        
    }
    

    @IBAction func findMap(_ sender: AnyObject) {
        let geocoder = CLGeocoder()
        if let stringToGeocode = myLocation.text
        {
            guard stringToGeocode != "" else{
                let alertTitle = "No location provided"
                let alertMessage = "Please enter your location before proceeding"
                let actionTitle = "OK"
                showAlert(alertTitle, alertMessage: alertMessage, actionTitle: actionTitle)
                return
            }
            let activityView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityView.center = view.center
            view.addSubview(activityView)
            let views = [CancelButton, whereYouStudying , myLocation , findOnTheMap] as [Any]
            geocoder.geocodeAddressString(stringToGeocode){ (placemark, error) in
                guard error == nil else
                {
                    let alertTitle = "No location found"
                    let alertMessage = "There was an error while fetching your location"
                    let actionTitle = "Try Again"
                    performUIUpdatesOnMain {
                        self.showAlert(actionTitle , alertMessage: alertMessage, actionTitle: actionTitle)
                        activityView.stopAnimating()
                    }
                    return
                }
                self.secondView()
                self.userLocation = placemark!
                self.configureMap()
                self.mapLocationView.showAnnotations(self.mapLocationView.annotations, animated: true)
                activityView.stopAnimating()
        }
        }
    }
    
    func showAlert(_ alertTitle: String, alertMessage: String, actionTitle: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func configureMap(){
        let topPlacemarkResult = self.userLocation[0]
        let placemarkToPlace = MKPlacemark(placemark: topPlacemarkResult)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemarkToPlace.coordinate
        studentLocationName = placemarkToPlace.name!
        studentLat = annotation.coordinate.latitude
        studentLon = annotation.coordinate.longitude
        let pinCoordinate = CLLocationCoordinate2DMake(studentLat,  studentLon)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegionMake(pinCoordinate, span)
        
        performUIUpdatesOnMain {
            self.mapLocationView.addAnnotation(annotation)
            self.mapLocationView.setRegion(region, animated: true)
            self.mapLocationView.regionThatFits(region)
        }
    }
    func secondView(){
        let newPosition = enterTheLink.beginningOfDocument
        enterTheLink.selectedTextRange = enterTheLink.textRange(from: newPosition, to: newPosition)
    }
    
    
       override func viewWillAppear(_ animated: Bool) {
        
       LoadingMap.isHidden = true
        }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        inputLocation.inputURL = textField.text
        textField.resignFirstResponder()
        return true
    }
    func makeObservation()
    {
        let annotation = MKPointAnnotation()
        annotation.title = members.studentinfo.userName
        
        annotation.subtitle = enterTheLink.text
    
        self.annotation.append(annotation)
        self.mapLocationView.addAnnotations(self.annotation)
    }
    
  
    func UIEnabled(status: Bool)
    {
        submitButton.isEnabled = status
     LoadingMap.isHidden = status
        enterTheLink.isEnabled = status
    }
    func listUpdating(completionHandler: @escaping(_ sucess: Bool) -> Void)
    {
        self.UIEnabled(status: false)
        makeObservation()
        let httpBody = "{\"uniqueKey\": \"\(members.studentinfo.userID)\", \"firstName\": \"\(members.studentinfo.firstName)\", \"lastName\": \"\(members.studentinfo.lastName)\",\"mapString\": \"\(inputLocation.inputLocation!)\", \"mediaURL\": \"\(inputLocation.inputURL!)\",\"latitude\": \(inputLocation.latitide!), \"longitude\": \(inputLocation.longitude!)}"
        if members.studentinfo.objectId == ""
        {
            self.connectivity.postApiMethod(procedure: procedures.postLocationsOfStudents, httpBody: httpBody,range: 0){(data , error) in
                guard error == "" else
                {
                    if error == " You are Offline"
                    {
                        performUIUpdatesOnMain {
                        self.UIEnabled(status: true)
                            let alert = UIAlertController()
                            alert.title = "Cannot Connect To Server"
                            alert.message = "Please Check Your Internet Connection"
                            let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                                
                                action in alert.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(continueAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else{
                        print(error)
                    }
                    return
                }
                guard let oldData = data as? NSDictionary else
                {
                    print("Content Not Updated")
                    return
                }
                guard let objectId = oldData["objectId"] as? String else
                {
                    print("Object Id not available")
                    return
                }
                members.studentinfo.objectId =  objectId
                print(members.studentinfo.objectId)
                self.connectivity.getLocationOfStudents (completionHandler: { (sucess, locationError) in
                    if sucess == true
                    {
                        performUIUpdatesOnMain {
                            self.UIEnabled(status: true)
                            completionHandler(true)
                        }
                    }
                    else
                    {
                        print(locationError)
                    }
                        })
                }
        }
        else
        {
            self.connectivity.putApiMethod(procedure: procedures.updateLocationsOfStudents, httpstype: httpBody, range: 0) { (data, error) in
                guard error == "" else
                {
                    if error == " you are offline"
                    {
                        performUIUpdatesOnMain {
                            self.UIEnabled(status: true)
                            self.UIEnabled(status: true)
                            let alert = UIAlertController()
                            alert.title = "Cannot Connect To Server"
                            alert.message = "Please Check Your Internet Connection"
                            let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                                
                                action in alert.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(continueAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        print(error)
                    }
                    return
                }
                guard let oldData = data as? NSDictionary else
                {
                    print("information not found")
                    return
                }
                print(oldData)
                self.connectivity.getLocationOfStudents(completionHandler: {(sucess, locationError) in
                    if sucess == true
                    {
                        performUIUpdatesOnMain {
                            self.UIEnabled(status: true)
                            completionHandler(true)
                        }
                    }
                    else
                    {
                        print(locationError)
                    }
                })
        }
        
    }
    }
       func mapLocationView(_mapLocationView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapLocationView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func  mapLocationView(_mapLocationView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let reOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: reOpen)!)
            }
        }
    }
    
    
       @IBAction func submitButton(_ sender: AnyObject) {
        self.UIEnabled(status: false)
        if enterTheLink.text == ""
        {
            self.UIEnabled(status: true)
            performUIUpdatesOnMain {
                
                let alert = UIAlertController()
                alert.title = "URL Field is Empty"
                alert.message = "Please Type a URL"
                let continueAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                    
                    action in alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(continueAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.listUpdating(completionHandler: { (sucess) in
                if sucess == true
                {
                    performUIUpdatesOnMain {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "TabViewController") as? UITabBarController
                        self.present(controller!, animated: true, completion: nil)
                    }
                }
                else
                {
                    self.UIEnabled(status: true)
                }
            })
                }
       
        }
    
    
    @IBAction func backButton(_ sender: AnyObject) {
        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
    procedures.cancelispressed = true
    self.dismiss(animated: false, completion: nil)
    }
    
}
