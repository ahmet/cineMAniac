//
//  TabBarViewController.swift
//  cineMAniac
//
//  Created by Glny Gl on 14.09.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    let items: [[String:String]] = [
        ["title": "Popular", "image": "top"],
        ["title": "Search", "image": "search"],
        ["title": "Categories", "image": "category"],
        ["title": "Favorites", "image": "favorite"],
    ]

    var tabItem1 = UITabBarItem()
    var tabItem2 = UITabBarItem()
    var tabItem3 = UITabBarItem()
    var tabItem4 = UITabBarItem()

    let topIMG = UIImage(named: "top")
    let searchIMG = UIImage(named: "search")
    let categoryIMG = UIImage(named: "category")
    let favoriteIMG = UIImage(named: "favorite")

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let tabBarItems = self.tabBar.items else { return }

        for (index, item) in items.enumerated() {
            tabBarItems[index].title = item["title"]
            tabBarItems[index].image = UIImage(named:item["image"])
        }
    }
}
