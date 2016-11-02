//
//  ViewController.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 22/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import UIKit

class loginIntoUdacity: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var userId: UITextField!

    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var loginUdacity: UIButton!
    @IBOutlet weak var loadingAction: UIActivityIndicatorView!
    
    @IBOutlet weak var signUp: UIButton!
   
    @IBOutlet weak var debugArea: UILabel!
    
    override func viewDidLoad() {
        self.loadingAction.isHidden = true
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
}
    @IBAction func loginUdacity(_ sender: AnyObject) {
        UIEnabled(status: false)
        if userId.text! == "" || userPassword.text! == ""
        {
            debugArea.text = "Enter your UserId ANd UserPassword"
            UIEnabled(status: true)
        }
        else if userId.text! != "" && userPassword.text! != ""
        {
            self.loadingAction.isHidden = false
            debugArea.text = ""
            let connectivity = NetPrase()
            let httpBody = "{\"udacity\": {\"username\": \"\(self.userId.text!)\", \"password\": \"\(self.userPassword.text!)\"}}"
            connectivity.pudacityApiMethod(procedure: procedures.LogInUdacityAccount, httpBody: httpBody,range: 5 ,completionHandler:
                {
                    (datadictionary, error)in
                    guard error == "" else
                    {
                        print(error)
                        if error == "The Internet connection appears to be offline."
                        {
                            performUIUpdatesOnMain {
                                self.debugArea.text = "Check your internet connection"
                                self.UIEnabled(status: true)
                            
                            }
                        }
                        else{
                            self.loginError()
                            self.loadingAction.isHidden = true
                            
                        }
                        return
                    }
                    guard let newData = datadictionary as? NSDictionary else
                    {
                        print("data could not found")
                        
                        self.loginError()
                        return
                    }
                    guard let detailsOfAccount = newData["account"] as? NSDictionary
                    else
                    {
                        print("details of account not found")
                        self.loginError()
                        return
                    }
                    guard let userEmailId = detailsOfAccount["key"] as? String else{
                        print("user emailId not found")
                        return
                    }
                    members.studentinfo.userID = userEmailId
                    guard let detailsOfSession = newData["session"] as? NSDictionary
                    else
                    {
                        print("session id details not found")
                        return
                    }
                    guard let IDSession = detailsOfSession["id"] as? String else
                    {
                        print("session id not found")
                        return
                    }
                    members.studentinfo.sessionID = IDSession
                    connectivity.getMethod(procedure: procedures.getUserDetails,range: 5 , completionHandler: { (datadictionary, error) in
                        guard error == "" else
                        {
                            print(error)
                            self.loginError()
                            return
                        }
                        guard let newData = datadictionary as? NSDictionary else
                        {
                            print("data not found")
                            self.loginError()
                            return
                        }
                        print(newData)
                        guard let userData = newData["user"] as? [String: AnyObject]
                            else{
                                print("user data not found")
                                return
                        }
                        guard let firstName = userData["first_name"] as? String else
                        {
                            print(" first Name not found")
                            return
                        }
                        
                        guard let lastName = userData["last_name"] as? String else
                        {
                            print("last Name not found")
                            return
                        }
                        members.studentinfo.firstName = firstName
                        members.studentinfo.lastName = lastName
                        let fullName = "\(firstName) \(lastName)"
                        members.studentinfo.userName = fullName
                        
                        
                        connectivity.getLocationOfStudents(completionHandler: {(success , errorInLocation) in
                            if success == true
                            {
                                self.LogInCompleted()
                                self.loadingAction.isHidden = true
                                self.UIEnabled(status: true)
                            }
                            else{
                                self.loadingAction.isHidden = true
                                self.loginError()
                                print(errorInLocation)
                            }
                        })
                        })
            })
            
        }
    }
    
    
    @IBAction func signUpAccount(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: "https://www.udacity.com/account/auth#!/signup")!)
        
        
    }
    func UIEnabled(status:Bool)
    {
        userId.isEnabled = status
        userPassword.isEnabled = status
        loginUdacity.isEnabled = status
        loadingAction.isHidden = status
        
    }
    
    func loginError()
    {
        performUIUpdatesOnMain {
            self.debugArea.text = "UserId OR UserPassword does not valid"
            self.UIEnabled(status: true)
        }
    }
    func LogInCompleted()
    {
        performUIUpdatesOnMain {
            let tabViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabViewController") as! UITabBarController
            self.present(tabViewController, animated: true, completion: nil)
        }
    }
}

