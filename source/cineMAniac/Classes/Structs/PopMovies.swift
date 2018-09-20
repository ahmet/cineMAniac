//
//  PopMovies.swift
//  cineMAniac
//
//  Created by Glny Gl on 4.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PopMovies: Codable {
    var page: Int?
    var results : [PopMovResults]?
    var total_results: Int?
    var total_pages: Int?

//    init(json: JSON) {
//        page = json["page"].intValue
//        total_results = json["total_results"].intValue
//        total_pages = json["total_pages"].intValue
//    }
}

struct PopMovResults: Codable {
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids : [Int]?
    var id: Int?
    var original_title: String?
    var original_language: String?
    var title: String?
    var backdrop_path: String?
    var popularity: Double?
    var vote_count: Int?
    var video: Bool?
    var vote_average: Double?
    
    // SwiftyJSON
//    init(json: JSON) {
//        poster_path = json["poster_path"].stringValue
//        adult = json["adult"].boolValue
//        overview = json["overview"].stringValue
//        release_date = json["release_date"].stringValue
//        genre_ids = json["genre_ids"].arrayValue
//        id = json["id"].intValue
//        original_title = json["original_title"].stringValue
//        original_language = json["original_language"].stringValue
//        title = json["title"].stringValue
//        backdrop_path = json["backdrop_path"].stringValue
//        popularity = json["popularity"].doubleValue
//        vote_count = json["vote_count"].intValue
//        video = json["video"].boolValue
//        vote_average = json["vote_average"].doubleValue
//
//        let genre_ids_array = json["genre_ids"].arrayValue
//        for genre_id_JSON in genre_ids_array
//        {
//           genre_id_JSON.dictionaryValue
//        }
//    }
}
