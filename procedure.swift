//
//  procedure.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 22/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation

struct procedures
{
    static var LogInUdacityAccount = "https://www.udacity.com/api/session"
    static var getUserDetails = "https://www.udacity.com/api/users/\(members.studentinfo.userID)"
    static var getLocationsOfStudents = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt"
    static var postLocationsOfStudents = "https://parse.udacity.com/parse/classes/StudentLocation"
    static var updateLocationsOfStudents = "https://parse.udacity.com/parse/classes/StudentLocation/\(members.studentinfo.objectId)"
    static var cancelispressed = false
}
