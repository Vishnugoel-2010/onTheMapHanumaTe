//
//  StudentDetails.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 23/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation
import UIKit

struct studentDetail
{
    let name: String
    let location: String
    let mediaURL: String
    
    init(dictionary: [String : AnyObject])
    {
        let firstName = dictionary["firstName"] as! String
        let lastName = dictionary["lastName"] as! String
        self.name = "\(firstName) \(lastName)"
        self.location = dictionary["mapString"] as! String
        self.mediaURL = dictionary["mediaURL"] as! String
    }
}

extension studentDetail
{
    static var studentDetails: [studentDetail] {
        
        var studentArray: [studentDetail] = []
        
        for b in members.result.locationsOfStudents! {
            
            studentArray.append(studentDetail(dictionary: b))
        }
        
        return studentArray
    }
}
