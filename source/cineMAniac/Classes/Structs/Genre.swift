//
//  Genre.swift
//  cineMAniac
//
//  Created by Glny Gl on 11.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import Foundation

struct Genre: Codable{
    var genres: [Genres]?
}

struct Genres: Codable{
    var id: Int?
    var name: String?
}
