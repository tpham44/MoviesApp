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

      // MoviesViewcontroller contains 3 protocols
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
 
    @IBOutlet weak var tableView: UITableView!
  
    
    var refreshControl: UIRefreshControl!

    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        //User sees a loading state while waiting for the movies API (you can use any 3rd party library available to do this).
        // Display HUD right before the request is made
        self.delay(4.0, closure: {MBProgressHUD.showHUDAddedTo(self.view, animated: true)})
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print ("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            self.delay(4.0, closure: {MBProgressHUD.hideHUDForView(self.view, animated: true)})
                            //onRefresh()
                            
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
        //let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell -- ORIGINAL FROM WEEK 1
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        // the Statement below saying that if movie["poster_path"] as? String =is= nill then do nothing but return the cells only otherwise it will pass movie poster_path value into posterPath variable
        if  let posterPath = movie["poster_path"] as? String {
        let posterUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView.setImageWithURL(posterUrl!)
        }
        //let imageUrl = NSURL(string: baseUrl + posterPath) -- week1 why change imageUrl to PosterPathURL
        //cell.posterView.setImageWithURL(imageUrl!) -- week1 was using imageUrl
       
       
        
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.item]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movies = movie
        
        print("prepare for seque called ")
        
        
        
    }
    

}
