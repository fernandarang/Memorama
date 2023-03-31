//
//  ItemCollectionViewCell.swift
//  Memorama
//
//  Created by MacBookMBA5 on 20/01/23.
//

import UIKit

weak var backView: UIImageView!
weak var frontView: UIImageView!


class ItemCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var backView: UIImageView!
    @IBOutlet weak var frontView: UIImageView!
    
    var resuelto : Bool = false
    var match : Int = -1
    
}
