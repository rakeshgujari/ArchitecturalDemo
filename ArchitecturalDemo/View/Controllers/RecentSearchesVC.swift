//
//  RecenrSearchesVC.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class RecentSearchesVC: UIViewController {

    var recentTable : UITableView?
    var recentArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recentTable = UITableView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenDimensions.width, height: Constants.ScreenDimensions.height))
        recentTable?.delegate = self
        recentTable?.dataSource = self
        recentTable?.tableFooterView = UIView()
        self.view.addSubview(recentTable!)
    }

    func refreshDataSource() {
        recentArray = AppDefaults.default.getStringArray(withKey: Constants.UserDefaults.recentSearches)!
        
        if (recentArray.count==0) {
            recentArray = [String](repeating: "", count: 3)
            AppDefaults.default.storeStringArray(withKey: Constants.UserDefaults.recentSearches, value: recentArray)
        }
        self.recentTable?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension RecentSearchesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (recentArray[indexPath.row]=="") {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
}

extension RecentSearchesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell")
        if (cell == nil) {
            cell = UITableViewCell(style: .default, reuseIdentifier: "RecentCell")
        }
        cell?.textLabel?.text = recentArray[indexPath.row]
        return cell!
    }
}
