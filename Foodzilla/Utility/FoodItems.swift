//
//  FoodItems.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-06.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import UIKit

let defaultPrice = 9.99

let salmon = Item(image: UIImage(named: "food1")!, name: "Salmon", price: defaultPrice)
let cheeseburger = Item(image: UIImage(named: "food2")!, name: "Cheeseburger", price: defaultPrice)
let burrito = Item(image: UIImage(named: "food3")!, name: "burrito", price: defaultPrice)
let spaghetti = Item(image: UIImage(named: "food4")!, name: "spaghetti", price: defaultPrice)
let pizza = Item(image: UIImage(named: "food5")!, name: "pizza", price: defaultPrice)
let salad = Item(image: UIImage(named: "food6")!, name: "salad", price: defaultPrice)

let foodItems: [Item] = [salmon, cheeseburger, burrito, spaghetti, pizza, salad]
