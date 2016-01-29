//
//  DetailViewController.swift
//  MovieViewerV1
//
//  Created by JP on 1/17/16.
//  Copyright © 2016 tpham44. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var infoView: UIView! //inforView is part extention of scrollview
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary! //store dictionary to movie variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        
        //Casting the text string title
        let title = movie["title"] as? String
        titleLabel.text = title
        //Casting text string overview
        let overview = movie["overview"] as? String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()  //Sizing Overview label text to fit in infoview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if  let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            posterimageView.setImageWithURL(posterUrl!)
        }
        
        
        
       
        
        

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
