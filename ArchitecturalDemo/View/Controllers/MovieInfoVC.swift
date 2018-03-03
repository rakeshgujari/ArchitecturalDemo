//
//  MovieInfoVC.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

class MovieInfoVC: UIViewController {

    var imdbId : String!
    var scrollView : UIScrollView?
    
    var loaderView : UIView?
    var container : UIView?
    var width = Constants.ScreenDimensions.width
    let height = Constants.ScreenDimensions.height
    
    let keyFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    let valueFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        loaderView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.ScreenDimensions.width, height: 60))
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loader.frame = CGRect(x: view.frame.midX-25, y: view.frame.midY-25, width: 50, height: 50)
        loaderView!.addSubview(loader)
        loader.startAnimating()
        self.view.addSubview(loaderView!)
        
        callAPI()
    }
    
    func callAPI() {
        ViewModel.context.getMovieInfo(imdbId: imdbId!) { (status) in
            if(status) {
                self.createViews(data: ViewModel.context.movieData!)
            } else {
                let alert = UIAlertController(title: "", message: "Unable to load data", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func createViews(data : NSDictionary) {
        loaderView?.removeFromSuperview()
        loaderView = nil
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        container = UIView(frame: scrollView!.frame)
        scrollView?.addSubview(container!)
        
        let poster = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width/2+50))
        poster.loadImage(data.object(forKey: "Poster") as? String ?? "")
        container?.addSubview(poster)
        
        let x : CGFloat = 16
        var y : CGFloat = poster.frame.size.height+16
        width = width-32
        
        let title = UILabel(frame: CGRect(x: x, y: y, width: width, height: 20))
        title.text = data.object(forKey: "Title") as? String ?? ""
        title.font = UIFont.boldSystemFont(ofSize: 15)
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.sizeToFit()
        title.frame = CGRect(x: x, y: y, width: width, height: title.frame.size.height+10)
        container?.addSubview(title)
        
        y = y+title.frame.size.height+16
        
        let line1 = UIView(frame: CGRect(x: 0, y: y-10, width: Constants.ScreenDimensions.width, height: 0.5))
        line1.backgroundColor = .lightGray
        container?.addSubview(line1)
        
        let ratingsHeader = UILabel(frame: CGRect(x: x, y: y, width: width, height: 30))
        ratingsHeader.text = "Ratings:"
        ratingsHeader.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        container?.addSubview(ratingsHeader)
        
        y = y+30
        
        let ratingsArray = data.object(forKey: "Ratings") as! [NSDictionary]
        var ratingKeys: [String] = []
        var ratingValues: [String] = []
        
        for i in 0..<ratingsArray.count {
            let rating = ratingsArray[i]
            ratingKeys.append(rating.object(forKey: "Source") as? String ?? "")
            ratingValues.append(rating.object(forKey: "Value") as? String ?? "")
        }
        
        ratingKeys.append("imdbRating")
        ratingValues.append(data.object(forKey: "imdbRating") as? String ?? "")
        ratingKeys.append("imdbVotes")
        ratingValues.append(data.object(forKey: "imdbVotes") as? String ?? "")
        
        y = y + setKeyValuePairs(startY: y, x: x, keys: ratingKeys, values: ratingValues, data: nil)
        
        y = y+26
        
        let line2 = UIView(frame: CGRect(x: 0, y: y-10, width: Constants.ScreenDimensions.width, height: 0.5))
        line2.backgroundColor = .lightGray
        container?.addSubview(line2)
        
        let detailsHeader = UILabel(frame: CGRect(x: x, y: y, width: width, height: 30))
        detailsHeader.text = "Details:"
        detailsHeader.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        container?.addSubview(detailsHeader)
        
        y = y+35
        
        let keys = ["Year","Rated","Released","Runtime","Genre","Director","Writer","Actors","Plot","Language","Country","Awards","Metascore","Type","DVD","BoxOffice","Production","Website"]
        
        y = y + setKeyValuePairs(startY: y, x: x, keys: keys, values: nil, data: data)
        
        
        
        scrollView?.contentSize = CGSize(width: container!.frame.size.width, height: y+20)
        self.view.addSubview(scrollView!)
    }
    
    func getLabelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.size.height+10
    }
    
    func setKeyValuePairs(startY: CGFloat, x: CGFloat, keys: [String], values: [String]?, data: NSDictionary?) -> CGFloat {
        var y = startY
        
        for i in 0..<keys.count {
        let keyHeight = getLabelHeight(text: keys[i], font: keyFont, width: width/2-16)
        
        let keyL = UILabel(frame: CGRect(x: x, y: y, width: width/2-16, height: keyHeight))
        keyL.text = keys[i]
        keyL.font = keyFont
        keyL.numberOfLines = 0
        keyL.lineBreakMode = .byWordWrapping
        container?.addSubview(keyL)
        
        let value = values?[i] ?? (data?.object(forKey: keys[i]) as! String)
        let valueHeight = getLabelHeight(text: value, font: valueFont, width: width/2-16)
        
        let valueL = UILabel(frame: CGRect(x: x+width/2+4, y: y, width: width/2-20, height: valueHeight))
        valueL.text = value
        valueL.font = valueFont
        valueL.numberOfLines = 0
        valueL.lineBreakMode = .byWordWrapping
        container?.addSubview(valueL)
        
        if(valueHeight>keyHeight) {
            y = y+valueHeight+5
        } else {
            y = y+keyHeight+5
        }
        }
        
        return y-startY
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
