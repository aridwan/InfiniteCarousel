//
//  MainViewController.swift
//  InfiniteCarousel
//
//  Created by Mochammad Arief Ridwan on 04/09/22.
//

import UIKit

class MainViewController: UIViewController {

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var carouselIndicator: UICollectionView!
  
  var centerCell: CarouselCollectionViewCell?
  let carouselItems = [("1", UIColor(red: 1, green: 0, blue: 0, alpha: 1)),("2", UIColor(red: 0, green: 1, blue: 0, alpha: 1)), ("3", UIColor(red: 0, green: 0, blue: 1, alpha: 1))]
  let cellScale: CGFloat = 0.6
  let numberOfItems = 100
  var bannerIndicatorIndex = 1
  
    override func viewDidLoad() {
      super.viewDidLoad()
      collectionView.delegate = self
      collectionView.dataSource = self
      
      carouselIndicator.delegate = self
      carouselIndicator.dataSource = self
      
      let screenSize = UIScreen.main.bounds.size
      let cellWidth = floor(screenSize.width * cellScale)
      let cellHeight = floor(screenSize.height * cellScale)
      let insetX = (view.bounds.width - cellWidth) / 2.0
      let insetY = (view.bounds.height - cellHeight) / 2.0
      
      let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
      collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
      
    }
  
  override func viewDidAppear(_ animated: Bool) {
    collectionView.scrollToItem(at: IndexPath(item: self.numberOfItems/2, section: 0), at: .centeredHorizontally, animated: true)
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == self.collectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CarouselCollectionViewCell
      cell.numberLabel.text = carouselItems[indexPath.row % carouselItems.count].0
      cell.backgroundCell?.backgroundColor = carouselItems[indexPath.row % carouselItems.count].1
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indicatorCell", for: indexPath) as! CarouselIndicatorCollectionViewCell
      cell.bulletView.layer.cornerRadius = 10
      if indexPath.row == self.bannerIndicatorIndex {
        cell.bulletView?.backgroundColor = UIColor.systemBlue
      } else {
        cell.bulletView?.backgroundColor = UIColor.lightGray
      }
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == self.collectionView {
      return numberOfItems
    } else {
      return carouselItems.count
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
    
    var offset = targetContentOffset.pointee
    let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
    
    let roundedIndex = round(index)
    
    offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
    
    targetContentOffset.pointee = offset
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView is UICollectionView else {return}

    let centerPoint = CGPoint(x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                              y: self.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
    if let indexPath = self.collectionView.indexPathForItem(at: centerPoint) {
      self.bannerIndicatorIndex = indexPath.row % carouselItems.count
      self.centerCell = (self.collectionView.cellForItem(at: indexPath) as? CarouselCollectionViewCell)
      self.centerCell?.transformToLarge()
      self.carouselIndicator.reloadData()
    }

    if let cell = self.centerCell {
      let offsetX = centerPoint.x - cell.center.x
      if offsetX < -40 || offsetX > 40 {
        cell.transformToStandard()
        self.centerCell = nil
      }
    }
  }
}

