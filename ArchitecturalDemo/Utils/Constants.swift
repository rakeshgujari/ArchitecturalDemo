//
//  Constants.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

struct Constants {
    
    static let API_KEY = "c77de484"
    
    struct URL {
        static let baseURL = "http://www.omdbapi.com/"
        static let getMoviesList = "?s=%@&page=%d&apikey=\(Constants.API_KEY)"
        static let getMovieInfo = "?i=%@&apikey=\(Constants.API_KEY)"
    }
    
    struct  ScreenDimensions {
        static let width = UIScreen.main.bounds.width
        static let height = UIScreen.main.bounds.height
    }
    
    struct UserDefaults {
        static let recentSearches = "RecentSearches"
    }
}
