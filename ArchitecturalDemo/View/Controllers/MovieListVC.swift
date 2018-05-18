//
//  MovieListVC.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTable: UITableView!
    
    var imdbId : String?
    var recentArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTable.delegate = self
        movieTable.dataSource = self
        self.removeFooter()
        self.movieTable.reloadData()
        
        searchBar.delegate = self
        
        recentArray = AppDefaults.default.getStringArray(withKey: Constants.UserDefaults.recentSearches)!
        
        if (recentArray.count==0) {
            recentArray = [String](repeating: "", count: 3)
            AppDefaults.default.storeStringArray(withKey: Constants.UserDefaults.recentSearches, value: recentArray)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetValues() {
        ViewModel.context.movies = []
        self.movieTable.reloadData()
        ViewModel.context.pageNumber = 1
    }
    
    func search(str : String) {
        showLoadingFooter()
        ViewModel.context.getMovies(searchStr: str) { (resultBool) in
            self.removeFooter()
            if (resultBool) {
                self.movieTable.reloadData()
            }
        }
    }
    
    func updateRecentSearchList(str: String) {
        if !recentArray.contains(str) {
        recentArray[2] = recentArray[1]
        recentArray[1] = recentArray[0]
        recentArray[0] = str
        AppDefaults.default.storeStringArray(withKey: Constants.UserDefaults.recentSearches, value: recentArray)
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MovieInfoSegue") {
            let dvc = segue.destination as! MovieInfoVC
            dvc.imdbId = self.imdbId!
            self.imdbId = nil
        }
    }

}

//MARK: - Delegate
extension MovieListVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = true
        self.imdbId = ViewModel.context.movies[indexPath.row].imdbId!
        self.performSegue(withIdentifier: "MovieInfoSegue", sender: self)
    }
}

//MARK: - Datasource
extension MovieListVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewModel.context.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieItemCell") as! MovieItemCell
        cell.selectionStyle = .none
        
        cell.movieTitle.text = ViewModel.context.movies[indexPath.row].title!
        cell.movieImage.loadImage(ViewModel.context.movies[indexPath.row].poster!, tag: indexPath.row)
        
        if(indexPath.row == ViewModel.context.movies.count-1 && indexPath.row+1 < (ViewModel.context.totalMoviesCount ?? 0)) {
            self.search(str: searchBar!.text!)
        }
        
        return cell
    }
}

//MARK: - Search delegate
extension MovieListVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resetValues()
        if(searchText.count>1) {
            self.search(str: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        resetValues()
        updateRecentSearchList(str: searchBar.text!)
        if(searchBar.text!.count > 1) {
            self.search(str: searchBar.text!)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}

extension MovieListVC{
    func showLoadingFooter() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenDimensions.width, height: 60))
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.frame = CGRect(x: view.frame.midX-25, y: view.frame.midY-25, width: 50, height: 50)
        view.addSubview(loader)
        loader.startAnimating()
        movieTable.tableFooterView = view
    }
    func removeFooter() {
        movieTable.tableFooterView = UIView()
    }
}
