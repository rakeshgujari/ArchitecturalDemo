//
//  NetworkManager.swift
//  ArchitecturalDemo
//
//  Created by Rakesh on 2/3/18.
//  Copyright © 2017 Rakesh Gujari. All rights reserved.
//

import UIKit

///Interacts with server and gets data
class NetworkManager {

    private init() {}
    
    public static let context = NetworkManager()
    private static var dataTask : URLSessionDataTask?
    /// Gets data from server
    ///
    /// - Parameters:
    ///   - url: server url
    ///   - completion: Throws response in dictionary format after data is recieved from server.
    func getDataFromServer(_ url: String,completion: @escaping (NSDictionary?,String) -> Void) {
        
        if(NetworkManager.dataTask?.state == .running) {
            NetworkManager.dataTask?.cancel()
        }
        
        guard let url = URL(string: url) else {
            print("Error in converting string to url");
            completion(nil,"ERROR");
            return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let session = URLSession.shared
        NetworkManager.dataTask = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            guard let responseData = data else { print("Data is nil"); return }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? NSDictionary {
                        print("Data recieved is : \(responseJSON)")
                        completion(responseJSON,"SUCCESS")
                }
            } catch {
                completion(nil,"ERROR")
                print("Error getting data from server: \(error.localizedDescription)")
            }
            }
        }
        NetworkManager.dataTask?.resume()
    }
    
}
