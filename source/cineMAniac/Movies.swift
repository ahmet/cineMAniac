//
//  Movies.swift
//  cineMAniac
//
//  Created by Glny Gl on 31.08.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import Foundation

struct movies {
    let page: Int
    let results: Array<Any>
    let total_results: Int
    let total_pages: Int

    init(json:[String:Any]){
        guard let page = json["page"] as? Int
        guard let results = json["results"] as? Array<Any>
        guard let total_results = json["total_results"] as? Int
        guard let total_pages = json["total_pages"] as? Int
    }

    // let poster_path: String
    // let overview: String
    // let release_date: Date
    // let title: String
    // let vote_average: Double
    // let id: Int
    // let genre_ids: Array<Any>

    // enum serializationError: Error {
    //     case missing(String)
    //     case invalid(String, Any)
    // }

    // init(json:[String:Any]) throws {
    //     guard let poster_path = json["poster_path"] as? String else {throw serializationError.missing("Poster is missing")}
    //     guard let overview = json["overview"] as? String else {throw serializationError.missing("Overview is missing")}
    //     guard let release_date = json["release_date"] as? Date else {throw serializationError.missing("Date is missing")}
    //     guard let title = json["title"] as? String else {throw serializationError.missing("Title is missing")}
    //     guard let vote_average = json["vote_average"] as? Double else {throw serializationError.missing("Vote is missing")}
    //     guard let id = json["id"] as? Int else {throw serializationError.missing("genre is missing")}
    //     guard let genre_ids = json["poster_path"] as? Array<Any> else {throw serializationError.missing("genre is missing")}

    //     self.poster_path = poster_path
    //     self.overview = overview
    //     self.release_date = release_date
    //     self.title = title
    //     self.vote_average = vote_average
    //     self.id = id
    //     self.genre_ids = genre_ids
    // }

    // static let basePath = "https://api.themoviedb.org/3/movie/157336?b155b3b83ec4d1cbb1e9576c41d00503={b155b3b83ec4d1cbb1e9576c41d00503}"
}
