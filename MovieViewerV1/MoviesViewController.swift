//
//  MoviesViewController.swift
//  MovieViewerV1
//
//  Created by JP on 1/10/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//


import UIKit
import AFNetworking

import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var refreshControl: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        //Load State feature add delay of 2 secs
        delay(2.0, closure: {MBProgressHUD.showHUDAddedTo(self.view, animated: true)})
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print ("response: \(responseDictionary)")
                            // After done loading 
                            // Hide HUD once network request comes back (must be done on main UI thread)
                            // delay 2 secs
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                            self.delay(2.0, closure: {MBProgressHUD.hideHUDForView(self.view, animated: true)})
                            
                            
                    }
                }
            
        });
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movies = movies{
            return movies.count
        } else {
            
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        cell.posterView.setImageWithURL(imageUrl!)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
       
        
        print("row \(indexPath.row)")
        return cell
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
