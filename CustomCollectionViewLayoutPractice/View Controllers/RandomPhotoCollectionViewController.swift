//
//  RandomPhotoCollectionViewController.swift
//  CustomCollectionViewLayoutPractice
//
//  Created by 나지운 on 2022/08/04.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class RandomPhotoCollectionViewController: UICollectionViewController {
    var photos: [Photo] = []
    var photoSizes: [CGSize] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let layout = collectionView.collectionViewLayout as? PhotoLayout {
            layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 16, bottom: 10, right: 16)
        setPhotos()
    }
    
    func setPhotos() {
        let url = EndPoint.unsplash + "?client_id=\(APIKeys.unsplashAccessKey)&count=30"

        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let jsonArray = JSON(value).arrayValue

                    for json in jsonArray {
                        let thumbURL = json["urls"]["thumb"].stringValue
                        let height = CGFloat(json["height"].intValue)
                        let width = CGFloat(json["width"].intValue)
                        
                        self.photos.append(Photo(imageURL: URL(string: thumbURL)!))
                        self.photoSizes.append(CGSize(width: width, height: height))
                    }
                    self.collectionView.reloadData()
                    break

                case .failure(let error):
                    print(error)
                    break
                }
            }
    }
}

extension RandomPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomViewCollectionViewCell.reuseIdenfier, for: indexPath) as? RandomViewCollectionViewCell else { return UICollectionViewCell() }
        cell.photoImageView.kf.setImage(with: photos[indexPath.item].imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension RandomPhotoCollectionViewController: PhotoLayoutDelgate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return photoSizes[indexPath.item]
    }
}
