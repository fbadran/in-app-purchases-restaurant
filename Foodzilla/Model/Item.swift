//
//  Item.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-06.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import UIKit

class Item {
    private(set) public var image: UIImage
    private(set) public var name: String
    private(set) public var price: Double
    
    init(image: UIImage, name: String, price: Double) {
        self.image = image
        self.name = name
        self.price = price
    }
}
