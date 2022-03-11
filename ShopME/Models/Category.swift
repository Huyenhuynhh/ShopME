//
//  Category.swift
//  ShopME
//
//  Created by Huyen on 02/03/2022.
//

import Foundation

struct Category {
    let id: Int
    let name: String
    let image: String? // Image name in assits
    let items: [Item]
    var imageData: Data? // Image data when manager add new category
}
