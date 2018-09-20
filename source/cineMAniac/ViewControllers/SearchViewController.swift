//
//  SearchViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 12.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController {
    var movie: PopMovies?
    var timer = Timer()
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Close keyboard with tabGesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @objc func getJSON() {
        let url = "https://api.themoviedb.org/3/search/movie?api_key=b155b3b83ec4d1cbb1e9576c41d00503&language=en-US&query=\(self.searchBar.text!)&page=1&include_adult=false"
            .addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        Alamofire.request(url!).responseJSON { (response) -> Void in
            if response.result.isFailure {
                print("Error")
            } else {
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let jData = try decoder.decode(PopMovies.self, from: data)
                    DispatchQueue.main.async {
                        self.movie = jData
                        self.myTableView.reloadData()
                    }
                } catch let err {
                    print("Err", err)
                }
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movie?.results?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = myTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as! SearchCell

        if let movie = self.movie?.results?[indexPath.row] {
            tableCell.cellImage.image = UIImage(named: "soon")
            tableCell.cellName.text = movie.title
            tableCell.cellDate.text = movie.release_date
            tableCell.cellVote.text = String(movie.vote_average ?? 0)
            tableCell.cellView.text = String(movie.popularity ?? 0)
            let link = movie.poster_path

            if link != nil {
                if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500" + link!), let placeholder = UIImage(named: "w2") {
                    tableCell.cellImage.af_setImage(withURL: imageURL, placeholderImage: placeholder)
                }
            }
        }

        return tableCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = self.movie?.results?[indexPath.row] {
            let movieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsVCID") as! MovieDetailsViewController
            movieDetailsViewController.movieResultsData = movie
            self.view.endEditing(true)
            self.navigationController?.pushViewController(movieDetailsViewController, animated: true)
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // textDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.getJSON), userInfo: nil, repeats: true)
    }
}
