//
//  ItemCell.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-06.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    
    func configureCell(forItem item: Item) {
        itemImageView.image = item.image
        itemNameLbl.text = item.name
        itemPriceLbl.text = String(describing: item.price)
    }
}
