//
//  CarouselCollectionViewCell.swift
//  InfiniteCarousel
//
//  Created by Mochammad Arief Ridwan on 04/09/22.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var backgroundCell: UIView!
  
  func transformToLarge(){
    UIView.animate(withDuration: 0.2){
      self.transform = CGAffineTransform(scaleX: 1.07, y: 1.07)
    }
  }
  
  func transformToStandard(){
    UIView.animate(withDuration: 0.2){
      self.transform = CGAffineTransform.identity
    }
  }
}
