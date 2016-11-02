//
//  Prase.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 22/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation
import UIKit

class NetPrase
{
    func getMethod(procedure: String , range: Int , completionHandler: @escaping (_ dataDictionary : Any, _ errors :String)-> Void){
        let procedure = procedure
        
        let URL = NSURL(string: procedure)
        let request = NSMutableURLRequest(url: URL as! URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest)
        {(data,response,error) in
            var error1 = ""
            guard error == nil else
            {
                error1 = "\(error)"
                print("Error appeared while getting user info:\(error)")
                completionHandler("", error1)
                return
            }
            guard let oldData = data else
            {
                print("There is no data")
                return
            }
            let p = Range(range...oldData.count)
            let freshData = oldData.subdata(in: p)
            var resultJsonData: NSDictionary!
            do{
                resultJsonData = try JSONSerialization .jsonObject(with: freshData, options: .allowFragments) as!
                NSDictionary
            }
            catch
            {
                print("Data result are not shown")
            }
            completionHandler(resultJsonData,error1)
        }
        task.resume()
    
    }

    
    func pudacityApiMethod(procedure: String , httpBody: String , range: Int , completionHandler:@escaping (_ dataDictionary : Any, _ errors : String) -> Void){
        let procedure = procedure
        let url = NSURL(string: procedure)
        let request = NSMutableURLRequest(url: url as! URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){(data , response , error) in
            var error1 = ""
            guard error == nil else
            {
                error1 = "\((error?.localizedDescription)!)"
                print("Appears an error while accessing data")
                completionHandler("",error1)
                return
            }
            guard let oldData = data else
            {
                print("There is no data")
                return
            }
            let p=Range(range...oldData.count)
            
            let freshData = NSString(data: oldData.subdata(in: p), encoding: String.Encoding.utf8.rawValue)
            
            guard let freshdata = freshData?.data(using: String.Encoding.utf8.rawValue) else
            {
                print(" data unable to convert")
                return
            }
            var resultJsonData: NSDictionary!
            do{
                resultJsonData = try JSONSerialization .jsonObject(with: freshdata, options: .allowFragments) as!
                NSDictionary
            }
            catch
            {
                print("Data result are not shown")
            }
            completionHandler(resultJsonData,error1)
        }
        task.resume()
        }

func postApiMethod(procedure: String, httpBody: String, range: Int, completionHandler:@escaping (_ dataDictionary : Any, _ errors : String) -> Void)
{
let procedure = procedure
    let url = NSURL(string: procedure)
    let request = NSMutableURLRequest(url: url as! URL)
    request.httpMethod = "POST"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = httpBody.data(using: String.Encoding.utf8)
let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
    var error1 = ""
    guard error == nil else{
        error1 = "\((error?.localizedDescription)!)"
        print("data could not access")
        completionHandler("", error1)
        return
    }
    guard let oldData = data else
    {
        print("Cant get the data")
        return
    }
    
    let p=Range(range...oldData.count)
    
    let freshData = NSString(data: oldData.subdata(in: p), encoding: String.Encoding.utf8.rawValue)
    
    guard let freshdata = freshData?.data(using: String.Encoding.utf8.rawValue) else
    {
        print(" data cannot be converted")
        return
    }
    
    var resultJsonData: NSDictionary!
    do
    {
        resultJsonData = try JSONSerialization.jsonObject(with: freshdata, options: .allowFragments) as! NSDictionary
    }
    catch
    {
        print("Unable to parse data")
        return
    }
    
    
    
    completionHandler(resultJsonData,error1)
    
    }
    
    task.resume()
    
}




func getLocationOfStudents(completionHandler: @escaping (_ sucess: Bool, _ error: String)-> Void)

{
    let procedure = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updateAt"
    let url = NSURL(string: procedure)
    let request = NSMutableURLRequest(url: url as! URL)
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
        guard error == nil else{
            print("Student location could not find")
            completionHandler(false, (error?.localizedDescription)!)
            return
        }
        guard let oldData = data else
        {
            print ("student data not found")
            return
        }
        let p = Range(0...oldData.count)
        let freshData = oldData.subdata(in : p)
        var resultJsonData: NSDictionary!
        do
        {
            resultJsonData = try JSONSerialization.jsonObject(with: freshData, options: .allowFragments) as! NSDictionary
        }
        catch
        {
            print("data not prase")
            return
        }
        guard let locationsOfStudents = resultJsonData["results"] as?
        [[String:AnyObject]] else
        {
            print("location of student not found")
            return
        }
        members.result.locationsOfStudents = locationsOfStudents
        completionHandler(true,"")
    }
    task.resume()
    }
func logoutButton(completionHandler:@escaping (_ success: Bool,_ error: String)-> Void)
{
    let procedure = procedures.LogInUdacityAccount
    let url = NSURL(string: procedure)
    let request = NSMutableURLRequest(url: url as! URL)
    request.httpMethod = "DELETE"
    
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        guard error == nil else
        {
            completionHandler(false,(error?.localizedDescription)!)
            return
        }
        guard let oldData = data else
        {
            print("Cant get the data")
            return
        }
        
        let p=Range(5...oldData.count)
        
        let freshData = NSString(data: oldData.subdata(in: p), encoding: String.Encoding.utf8.rawValue)
        
        guard let freshdata = freshData?.data(using: String.Encoding.utf8.rawValue) else
        {
            print("unable to convert to data")
            return
        }
        
        var resultJsonData: NSDictionary!
        do
        {
            resultJsonData = try JSONSerialization.jsonObject(with: freshdata, options: .allowFragments) as! NSDictionary
        }
        catch
        {
            print("Unable to parse data")
            return
        }
        print(resultJsonData)
        completionHandler(true,"")
    }
    task.resume()
    
}

func putApiMethod(procedure: String, httpstype: String, range: Int, completionHandler:@escaping (_ dataDictionary :Any, _ errors :String) -> Void)
{
    let procedure = procedure
    let url = NSURL(string: procedure)
    let request = NSMutableURLRequest(url: url as! URL)
    request.httpMethod = "PUT"
    request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = httpstype.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request as URLRequest){(data,response,error) in
        var error1 = ""
        guard error == nil else
        {
            error1 = "\((error?.localizedDescription)!)"
            print("data not access")
            completionHandler("", error1)
            return
        }
        
        guard let oldData = data else
        {
            print("data not found")
            return
        }
        
        let p=Range(range...oldData.count)
        
        let freshData = NSString(data: oldData.subdata(in: p), encoding: String.Encoding.utf8.rawValue)
        
        guard let freshdata = freshData?.data(using: String.Encoding.utf8.rawValue) else
        {
            print( "data not converted")
            return
        }
        
        var resultJsonData: NSDictionary!
        do
        {
            resultJsonData = try JSONSerialization.jsonObject(with: freshdata, options: .allowFragments) as! NSDictionary
        }
        catch
        {
            print("data not prase")
            return
        }
        
        
        
        completionHandler(resultJsonData,error1)
        
    }
    
    task.resume()
    
}
    
    class func sharedInstance() -> NetPrase{
        struct Singleton{
            static var sharedInstance = NetPrase()
        }
        return Singleton.sharedInstance
    }
}

    
    


    
