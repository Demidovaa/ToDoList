//
//  UserDefaults+Extension.swift
//  ToDoList
//
//  Created by Anastasia Demidova on 26.03.2021.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: firstLaunchFlag)
        
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: firstLaunchFlag)
        }
        return isFirstLaunch
    }
}
