//
//  CategoriesViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 10.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesViewController: UIViewController {
    var movieGenre: Genre?
    @IBOutlet weak var categoriesCW: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let widthSize = UIScreen.main.bounds.width/3-4
//        let heightSize = UIScreen.main.bounds.height/3-4
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: widthSize, height: heightSize)
//        layout.minimumInteritemSpacing = 4
//        layout.minimumLineSpacing = 4

//        categoriesCW.collectionViewLayout = layout

        getJSON()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.navigationBar.isHidden = true
//    }

    enum MovieBanner: String {
        case Action
        case Adventure
        case Animation
        case Comedy
        case Crime
        case Documentary
        case Drama
        case Family
        case Fantasy
        case History
        case Horror
        case Music
        case Mystery
        case Romance
        case ScienceFiction
        case Thriller
        case TVMovie
        case War
        case Western
        case Default
    }

    func getJSON() {
        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US").responseJSON { (response) -> Void in
            if response.result.isFailure {
                print("Error")
            } else {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(Genre.self, from: data)
                    DispatchQueue.main.async {
                        self.movieGenre = jData
                        self.categoriesCW.reloadData()
                    }
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }

    func nameTrim(_ name: String) -> String {
        return name.replacingOccurrences(of: " ", with: "")
    }

    func getImage(_ genreName: MovieBanner, _ cell: CategoryCellClass) {
        cell.cellImage.image = UIImage(named: genreName.rawValue)
    }
}

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieGenre?.genres?.count ?? 0 
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCellClass", for: indexPath) as! CategoryCellClass

        if let category = self.movieGenre?.genres?[indexPath.row] {
            cell.cellName.text = category.name
            if let categoryEnum: MovieBanner = MovieBanner(rawValue: nameTrim(category.name ?? ""))- {
                getImage(categoryEnum, cell)
            } else {
                getImage(.Default, cell)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let category = self.movieGenre?.genres?[indexPath.row] {
            let genreViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenreViewControllerID") as! GenreViewController
            genreViewController.genreID = category.id
            genreViewController.categoryName = category.name!
            self.navigationController?.pushViewController(genreViewController, animated: true)
        }
    }
}
