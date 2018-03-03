//
//  AppDefaults.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

///Stores and retrieves data from UserDefaults
class AppDefaults {

    private init() {}
    public static let `default` = AppDefaults()
    
    let userDefaults = UserDefaults.standard
    
    func getString(withKey: String) -> String? {
        return userDefaults.object(forKey: withKey) as? String
    }
    
    func getStringArray(withKey: String) -> [String]? {
        return userDefaults.object(forKey: withKey) as? [String] ?? []
    }
    
    func storeString(withKey: String, value: String) {
        userDefaults.set(value, forKey: withKey)
        userDefaults.synchronize()
    }
    
    func storeStringArray(withKey: String, value: [String]) {
        userDefaults.set(value, forKey: withKey)
        userDefaults.synchronize()
    }
}
