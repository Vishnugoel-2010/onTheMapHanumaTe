//
//  MapController.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 23/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation
import MapKit

class mapForLocation: UIViewController , MKMapViewDelegate
{
    @IBOutlet weak var mapForlocation: MKMapView!
    
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var ReloadButton: UIBarButtonItem!
    
    var observations = [MKPointAnnotation]()
    func loadObservation ()
    {
        let location = members.result.locationsOfStudents!
        loadingActivity.isHidden = true
        for dict in location
        {
            let lati = CLLocationDegrees(dict["latitude"] as! Double)
            let longi = CLLocationDegrees(dict["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: lati, longitude:longi)
            
            let start = dict["firstName"] as! String
            let end = dict["lastName"] as! String
            let mediaURL = dict["mediaURL"] as! String
            
            let observation = MKPointAnnotation()
            observation.coordinate = coordinate
            observation.title = "\(start)\(end)"
            observation.subtitle = mediaURL
            observations.append(observation)
        }
        self.mapForlocation.addAnnotations(observations)
    }
    override func viewDidLoad() {
        self.loadObservation()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        procedures.cancelispressed = false

    }
    
    func UIEnable(Status:Bool){
        loadingActivity.isHidden = Status
        logoutButton.isEnabled = Status
        pinButton.isEnabled = Status
        ReloadButton.isEnabled = Status
    }
    
    
    @IBAction func pinButton(_ sender: AnyObject) {
        if members.studentinfo.objectId == ""
        {
            performSegue(withIdentifier: "EnterLocationViewController", sender: self)
        }
        else
        {
            let alert = UIAlertController()
            alert.title = " overwrite"
            alert.message = "You have already updated Your Location"
            let overrightAction = UIAlertAction(title: "Overright", style: UIAlertActionStyle.default){
                
                action in self.performSegue(withIdentifier: "locationViewController", sender: self)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){
                
                action in alert.dismiss(animated: true, completion: nil)
                
            }
            alert.addAction(overrightAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)


        }
    }
    
    
    func mapLocationView(_ mapLocationView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinCodeView = mapLocationView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
       
        
        if pinCodeView == nil {
            pinCodeView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinCodeView!.canShowCallout = true
            pinCodeView!.pinTintColor = .red
            pinCodeView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else{
            pinCodeView!.annotation = annotation
        }
        return pinCodeView
    }
    
    func mapLocationView(_mapLocationView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let reopen = view.annotation?.subtitle!{
                app.openURL(URL(string: reopen)!)
            }
        }
    }
    
    
    @IBAction func reloadButton(_ sender: AnyObject) {
        self.UIEnable(Status: false)
        let connectivity = NetPrase()
        connectivity.getLocationOfStudents {(sucess , error) in
            if sucess == true
            {
                performUIUpdatesOnMain {
                    self.mapForlocation.removeAnnotations(self.observations)
                    self.UIEnable(Status: true)
                    self.loadObservation()
                }
            }
            else if error == "You Are Offline"
            {
                performUIUpdatesOnMain {
                    
                self.UIEnable(Status: true)
                    let alert = UIAlertController()
                    alert.title = "Cannot Connect To Server"
                    alert.message = "Please Check your Internet Connection"
                    let overrightAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                        
                        action in alert.dismiss(animated: true, completion: nil)
                        
                    }
                    alert.addAction(overrightAction)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else
            {
                self.UIEnable(Status: true)
                print(error)
            }

                }}
    
    
    @IBAction func logoutButton(_ sender: AnyObject) {
        self.UIEnable(Status: false)
        let connectivity = NetPrase()
        connectivity.logoutButton {
            (sucess, error) in
            if sucess == true
            {
                self.dismiss(animated: true, completion: nil)
            }
            else if error == "you are offline"
            {
                performUIUpdatesOnMain {
                    self.UIEnable(Status: true)
                    let alert = UIAlertController()
                    alert.title = "Cannot Connect To Server"
                    alert.message = "Please Check your Internet Connection"
                    let overrightAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default){
                        
                        action in alert.dismiss(animated: true, completion: nil)
                        
                    }
                    alert.addAction(overrightAction)
                    self.present(alert, animated: true, completion: nil)
                }

                }
            else
            {
                self.UIEnable(Status: true)
                print(error)
            }
            }
            
        }
    
    

}


