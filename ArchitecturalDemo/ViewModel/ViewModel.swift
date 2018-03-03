//
//  ViewModel.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

class ViewModel: NSObject {

    private override init() {}
    public static let context = ViewModel()
    
    ///Holds data for tableview
    var movies : [Movie] = []
    var totalMoviesCount : Int?
    var pageNumber : Int = 1
    var movieData: NSDictionary?
    /// Trigerrs network manager to get movies from server
    ///
    /// - Parameter completionHandler: throws response back to calling controller
    func getMovies(searchStr: String, completionHandler: @escaping (Bool) -> Void) {
        
        if !AppHelper.context.isConnectedToNetwork() {
            let alert = UIAlertController(title: "", message: "Device is offline. Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            (UIApplication.shared.delegate?.window??.rootViewController)?.present(alert, animated: true, completion: nil)
            completionHandler(false)
            return
        }
        
        let pathParam = String(format:Constants.URL.getMoviesList,searchStr,pageNumber)
        
        NetworkManager.context.getDataFromServer(Constants.URL.baseURL+pathParam) { (data,status) in
            if data != nil && status == "SUCCESS" {
                self.totalMoviesCount = Int(data?.value(forKey: "totalResults") as? String ?? "0")
                if data?.value(forKey: "Response") as? String == "False"{
                    completionHandler(false)
                    return
                }
                
                if let moviesData = data?.value(forKey: "Search") as? [NSDictionary] {
                    
                    for i in 0..<moviesData.count {
                        let model = Movie()
                        model.title = moviesData[i].object(forKey: "Title") as? String ?? ""
                        model.poster = moviesData[i].object(forKey: "Poster") as? String ?? ""
                        model.imdbId = moviesData[i].object(forKey: "imdbID") as? String ?? ""
                        self.movies.append(model)
                    }
                    if (moviesData.count==10) {
                        self.pageNumber+=1
                    }
                    completionHandler(true)
                    return
                }
            }
            completionHandler(false)
        }
    }
    
    func getMovieInfo(imdbId : String,completionHandler: @escaping (Bool) -> Void) {
        if !AppHelper.context.isConnectedToNetwork() {
            let alert = UIAlertController(title: "", message: "Device is offline. Please connect to internet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            (UIApplication.shared.delegate?.window??.rootViewController)?.present(alert, animated: true, completion: nil)
            completionHandler(false)
            return
        }
        
        let pathParam = String(format:Constants.URL.getMovieInfo,imdbId)
        NetworkManager.context.getDataFromServer(Constants.URL.baseURL+pathParam) { (response, status) in
            if(response != nil && status == "SUCCESS") {
                self.movieData = response!
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
        
    }
    
    
}
