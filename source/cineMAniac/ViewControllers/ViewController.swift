//
//  ViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 28.08.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController{
    var isLoadingMore = false
    var movie: PopMovies?
    //  var movieData = [[String:AnyObject]]()
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // UINavigationBar Configuration
        // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // navigationController?.navigationBar.shadowImage = UIImage()

        // Custom Flow Layout Initialization
        let layout = UICollectionViewFlowLayout()
        // layout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 2)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-4, height: UIScreen.main.bounds.height/3.3-4)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4

        // UICollectionView Configuration
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout

        getJSON()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // Request with Alamofire
    func getJSON(){
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1").responseJSON { (response) -> Void in
            if response.result.isFailure {
                print("Error")
            } else {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(PopMovies.self, from: data)
                    DispatchQueue.main.async {
                        self.movie = jData
                        self.collectionView.reloadData()
                    }
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }

    func loadMoreJSON(){
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
        let page = self.movie?.page

        SVProgressHUD.show()
        Alamofire.request("https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page!+1)").responseJSON { (response) -> Void in
            if response.result.isFailure {
                print("Error")
            } else {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(PopMovies.self, from: data)
                    DispatchQueue.main.async {
                        self.movie?.results?.append(contentsOf: (jData.results ?? []))
                        self.collectionView.reloadData()
                        self.isLoadingMore = false
                    }
                } catch let err {
                    print("Err", err)
                }
            }

            SVProgressHUD.dismiss()
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return movieData.count
        return self.movie?.results?.count ?? 0
    }

    // cellforItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellClass", for: indexPath) as! cellClass

        if let movie = self.movie?.results?[indexPath.row] {
            cell.cellName.text = movie.title
            if let link = movie.poster_path {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + link)
                cell.cellImage.af_setImage(withURL: imageURL!)
            } else {
                let defaultIMG = URL(string: "https://images.atomtickets.com/image/upload/h_960,q_auto/ingestion-images-archive-prod/archive/coming_soon_promo.jpg")
                cell.cellImage.af_setImage(withURL: defaultIMG!)
            }
        }

//        let ip = movieData[indexPath.row]
//        cell.cellName.text = ip["title"] as? String
//        let link = ip["poster_path"] as? String
//        if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + link!), let placeholder = UIImage(named: "L") {
//            cell.cellImage.af_setImage(withURL: imageURL, placeholderImage: placeholder)
//        }

        return cell
    }

    // didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = self.movie?.results?[indexPath.row] {
            let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVCID") as! MovieDetailsViewController
            movieDetailsViewController.movieResultsData = movie
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }

//        let ip = movieData[indexPath.row]
//        movieDetailsViewController.data = ip
//        movieDetailsViewController.name = (ip["title"] as? String)!
//        movieDetailsViewController.release = (ip["release_date"] as? String)!
//        movieDetailsViewController.total = (ip["popularity"] as? Double)!
//        movieDetailsViewController.vote = (ip["vote_average"] as? Double)!
//        movieDetailsViewController.overview = (ip["overview"] as? String)!
//        let link = ip["poster_path"] as? String
//        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + link!)
//        movieDetailsViewController.image = imageURL
    }

    // willDisplay
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.movie?.results?.count)! - 4 {
            loadMoreJSON()
            self.movie?.page? += 1
        }
    }
}
