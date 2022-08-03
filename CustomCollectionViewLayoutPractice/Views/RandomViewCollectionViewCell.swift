//
//  RandomViewCollectionViewCell.swift
//  CustomCollectionViewLayoutPractice
//
//  Created by 나지운 on 2022/08/04.
//

import UIKit

class RandomViewCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      photoImageView.layer.cornerRadius = 6
    }
}
