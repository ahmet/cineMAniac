//
//  MovieDetailsViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 6.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieDetailsViewController: UIViewController {
    var movieResultsData: PopMovResults?
    var likeIMG = UIImage(named: "like")
    var likedIMG = UIImage(named: "liked")
    //    var data = [String:AnyObject]()
    //    var name = ""
    //    var image: URL?
    //    var release = ""
    //    var total = 0.000
    //    var vote = 0.0
    //    var overview = ""
    //    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var textDate: UILabel!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var textVote: UILabel!
    @IBOutlet weak var textOverview: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.checkLikeButton()

        let labelFont = UIFont(name: "HelveticaNeue-Bold", size: 18)
        textDate.font = labelFont
        textView.font = labelFont
        textVote.font = labelFont
        textOverview.font = labelFont
        //   movieName.font = labelFont
        
        if let link = movieResultsData?.poster_path {
            movieImage.af_setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w500" + link)!)
        } else {
            movieImage.af_setImage(withURL: URL(string: "https://images.atomtickets.com/image/upload/h_960,q_auto/ingestion-images-archive-prod/archive/coming_soon_promo.jpg")!)
        }

        self.title = movieResultsData?.title
        // movieName.text = movieResultsData?.title
        releaseDate.text = movieResultsData?.release_date
        totalView.text = String(movieResultsData?.popularity ?? 0)
        voteAverage.text = String(movieResultsData?.vote_average ?? 0)
        movieOverview.text = movieResultsData?.overview

//         let link = data["poster_path"] as? String
//         let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + link!)
//
//         movieName.text = (data["title"] as? String)!
//         movieImage.af_setImage(withURL: imageURL!)
//         releaseDate.text = (data["release_date"] as? String)!
//         totalView.text = String((data["popularity"] as? Double)!)
//         voteAverage.text = String((data["vote_average"] as? Double)!)
//         movieOverview.text = (data["overview"] as? String)!

//         movieOverview.text = (data["overview"] as? String)!
//         movieName.text = name
//         movieImage.af_setImage(withURL: image!)
//         releaseDate.text = release
//         totalView.text = String(total)
//         voteAverage.text = String(vote)
//         movieOverview.text = overview
    }

    func checkLikeButton() {
        if LikedMovies.shared.isLiked(movie: self.movieResultsData!) {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: likedIMG, style: .done, target: self, action: #selector(addFavorite))
            ]
        } else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: likeIMG, style: .done, target: self, action: #selector(addFavorite))
            ]
        }
    }

    @objc func addFavorite() {
        if LikedMovies.shared.isLiked(movie: self.movieResultsData!) {
            LikedMovies.shared.unlike(movie: self.movieResultsData!)
        } else {
            LikedMovies.shared.like(movie: self.movieResultsData!)
        }

        checkLikeButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
