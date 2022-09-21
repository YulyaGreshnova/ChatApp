//
//  AvatarGalleryDataSource.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation
import UIKit

final class AvatarGalleryDataSource: NSObject {
    private let collectionView: UICollectionView
    private var avatarViewModels: [AvatarImageModel] = []
   
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func setImages(_ images: [AvatarImageModel]) {
        avatarViewModels = images
        collectionView.reloadData()
    }
    func addImages(_ images: [AvatarImageModel]) {
        let preCount = avatarViewModels.count
        avatarViewModels.append(contentsOf: images)
        let newCount = preCount + images.count
        let insertingIndexPath = (preCount ..< newCount).map { IndexPath(item: $0, section: 0) }
        
        collectionView.insertItems(at: insertingIndexPath)
    }
    
    func getImagesCount() -> Int {
        return avatarViewModels.count
    }
}

// MARK: - UICollectionViewDataSource

extension AvatarGalleryDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        avatarViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AvatarGalleryCell.cellIdentifier,
                for: indexPath) as? AvatarGalleryCell
        else { return UICollectionViewCell() }
        
        let viewModel = avatarViewModels[indexPath.item]
        cell.configureWith(viewModel: viewModel)
        
        return cell
    }
}
