//
//  FavoritesViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 17.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import AlamofireImage

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoriteVC: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        favoriteVC.collectionViewLayout = setCollectionViewLayout()
    }

    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-4, height: UIScreen.main.bounds.height/3.3-4)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        return layout
    }

    override func viewWillAppear(_ animated: Bool) {
        favoriteVC.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LikedMovies.shared.likedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell

        let movie = LikedMovies.shared.likedMovies[indexPath.row]
        cell.cellName.text = movie.title
        
        if let link = movie.poster_path {
            cell.cellImage.af_setImage(withURL: URL(string: "https://image.tmdb.org/t/p/w500" + link)!)
        } else {
            cell.cellImage.af_setImage(withURL: URL(string: "https://images.atomtickets.com/image/upload/h_960,q_auto/ingestion-images-archive-prod/archive/coming_soon_promo.jpg")!)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let likedMovie = LikedMovies.shared.likedMovies[indexPath.row] {
            let movieViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVCID") as! MovieDetailsViewController
            movieViewController.movieResultsData = likedMovie
                self.navigationController?.pushViewController(movieViewController, animated: true)
        }
    }
}
