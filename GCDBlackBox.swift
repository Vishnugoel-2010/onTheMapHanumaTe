//
//  GCDBlackBox.swift
//  On The Map Hanumate
//
//  Created by Vishnu Goel on 23/10/16.
//  Copyright © 2016 Vishnu Goel. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: @escaping () -> Void)
{
    DispatchQueue.main.async {
        updates()
    }
}
