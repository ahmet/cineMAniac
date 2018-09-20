//
//  GenreViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 12.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GenreViewController: UIViewController {
    var genreID: Int?
    var movie: PopMovies?
    var isLoadingMore = false
    var categoryName = ""
    @IBOutlet weak var genreCVC: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        genreCVC.collectionViewLayout = setCollectionViewLayout()
        getJSON()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-4, height: UIScreen.main.bounds.height/3.3-4)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        return layout
    }

    func getJSON() {
        if let genreID = self.genreID {
            let url = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_genres=\(String(describing: genreID))"

            Alamofire.request(url).responseJSON { (response) -> Void in
                if response.result.isFailure {
                    print("Error")
                } else {
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let jData = try decoder.decode(PopMovies.self, from: data)
                        DispatchQueue.main.async {
                            self.movie = jData
                            self.genreCVC.reloadData()
                        }
                    } catch let err {
                        print("Error", err)
                    }
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

        if let genreID = self.genreID {
            let url = "https://api.themoviedb.org/3/discover/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page!+1)&with_genres=\(String(describing: genreID))"

            Alamofire.request(URL(string: url)!).responseJSON { (response) -> Void in
                if response.result.isFailure {
                    print("Error")
                } else {
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let jData = try decoder.decode(PopMovies.self, from: data)
                        DispatchQueue.main.async {
                            self.movie?.results?.append(contentsOf: (jData.results ?? []))
                            self.genreCVC.reloadData()
                            self.isLoadingMore = false
                        }
                    } catch let err {
                        print("Err", err)
                    }
                }
            }
        }
    }
}

extension GenreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movie?.results?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCellClass", for: indexPath) as! GenreCellClass

        if let movie = self.movie?.results?[indexPath.row] {
            self.title = categoryName
            cell.cellName.text = movie.title
            if let link = movie.poster_path {
                cell.cellImage.af_setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w500" + link)!)
            } else {
                cell.cellImage.af_setImage(withURL: URL(string: "https://images.atomtickets.com/image/upload/h_960,q_auto/ingestion-images-archive-prod/archive/coming_soon_promo.jpg")!)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = self.movie?.results?[indexPath.row] {
            let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVCID") as! MovieDetailsViewController
            movieDetailsViewController.movieResultsData = movie
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (self.movie?.results?.count)! - 4 {
            loadMoreJSON()
            self.movie?.page? += 1
        }
    }
}
