//
//  tableViewController.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 23/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation
import UIKit


class tableViewCell: UITableViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var location: UILabel!
}
class TableViewController: UIViewController,UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
  
    
    @IBOutlet weak var LogoutButton: UIBarButtonItem!
    
    @IBOutlet weak var PinButton: UIBarButtonItem!
    
    @IBOutlet weak var ReloadButton: UIBarButtonItem!
    
    func UIEnable(Status: Bool)
    {
        LogoutButton.isEnabled = Status
        PinButton.isEnabled = Status
        ReloadButton.isEnabled = Status
    }
    @IBAction func logoutButton(_ sender: AnyObject) {
        self.UIEnable(Status: false)
        let connectivity = NetPrase()
        connectivity.logoutButton {(sucess, error) in
            if sucess == true
            {
                self.dismiss(animated: true, completion: nil)
            }
            else if error == "You are Offline"
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
        

    @IBAction func ReloadButton(_ sender: AnyObject) {
        self.UIEnable(Status: false)
        let connectivity = NetPrase()
        connectivity.getLocationOfStudents {
            (sucess, error) in
                if sucess == true
                {
                    performUIUpdatesOnMain {
                        self.UIEnable(Status: true)
                        self.tableView.reloadData()
                    }
                    }
            else if error == " You are offline"
                {
                    performUIUpdatesOnMain {
                        self.UIEnable(Status: true)
                        let alert = UIAlertController()
                        alert.title = "Cannot Connect To Server"
                        alert.message = "Please Check Your Internet Connection"
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
    
                
            

    @IBAction func PinButton(_ sender: AnyObject) {
        if members.studentinfo.objectId == ""
        {
            performSegue(withIdentifier: "locationViewController" , sender: self)
        }
        else
        {
            let alert = UIAlertController()
            alert.title = "Do you wish to overwrite"
            alert.message = "You have already updated Your Location"
            let overriteAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default){
                
                action in self.performSegue(withIdentifier: "EnterLocationViewController", sender: self)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default){
                
                action in alert.dismiss(animated: true, completion: nil)
                
            }
            alert.addAction(overriteAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)

            
        }
    }
        

    
    
    func tabView(_tabView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return studentDetail.studentDetails.count
    }
    func tabView(_ tabView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tabView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as! tableViewCell
        let student = studentDetail.studentDetails[indexPath.row]
        cell.title.text = student.name
        cell.location.text = student.location
        return cell
    }
    
    private func tabView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        let student = studentDetail.studentDetails[indexPath.row]
        let mediaURL = student.mediaURL
        print(mediaURL)
        
        UIApplication.shared.openURL(URL(string: mediaURL)!)
        
    
    }
    
}
