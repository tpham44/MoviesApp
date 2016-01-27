//
//  DetailViewController.swift
//  MovieViewerV1
//
//  Created by JP on 1/17/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movies: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movies!["title"] as! String
        let overview = movies!["overview"] as! String
        titleLabel.text = title
        overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if  let posterPath = movies!["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            posterimageView.setImageWithURL(posterUrl!)
        }
        
        
        
        
        //let posterPath = movies!["poster_path"] as! String
        
  
        
        //let imageUrl = NSURL(string: baseUrl + posterPath)
        
        //posterimageView.setImageWithURL(imageUrl!)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("prepare for seque called ")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
