//
//  AvatarGallery.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation
import UIKit

protocol AvatarGalleryDelegate: AnyObject {
    func didChooseImage(image: UIImage)
}

protocol IAvatarGalleryViewController: AnyObject {
    func showImages(images: [AvatarImageModel])
    func showError(error: Error)
    func showMoreImages(images: [AvatarImageModel])
    func didSelectImage(_ image: UIImage)
    func showLoader()
    func hideLoader()
}

final class AvatarGalleryViewController: UIViewController {
    private struct Constants {
        static let spacing: CGFloat = 5
    }
    
    private let collectionView: UICollectionView
    private let loaderView: UIView
    private let activityIndicator: UIActivityIndicatorView
    private let avatarGalleryDataSource: AvatarGalleryDataSource
    private var presenter: IAvatarGalleryPresenter
    
    weak var delegate: AvatarGalleryDelegate?
        
    init() {
        loaderView = UIView()
        activityIndicator = UIActivityIndicatorView()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: Constants.spacing,
                                           left: Constants.spacing,
                                           bottom: Constants.spacing,
                                           right: Constants.spacing)
        layout.minimumLineSpacing = Constants.spacing
        layout.minimumInteritemSpacing = Constants.spacing
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        avatarGalleryDataSource = AvatarGalleryDataSource(collectionView: collectionView)
        
        let presenter = AvatarGalleryPresenter()
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupView()
        presenter.viewLoaded()
    }
}

// MARK: - View configuration
private extension AvatarGalleryViewController {
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = avatarGalleryDataSource
        
        collectionView.register(AvatarGalleryCell.self,
                                forCellWithReuseIdentifier: AvatarGalleryCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setupView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.backgroundColor = .white
        loaderView.alpha = 0.7
        loaderView.isHidden = true
        view.addSubview(loaderView)
        
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loaderView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor)
        ])
    }
}

// MARK: - IAvatarGalleryViewController
extension AvatarGalleryViewController: IAvatarGalleryViewController {
    func showImages(images: [AvatarImageModel]) {
        avatarGalleryDataSource.setImages(images)
    }
    
    func showError(error: Error) {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        showAlert(title: "Ошибка!",
                  message: "Не удалось загрузить изображения",
                  actions: [okAction])
    }
    
    func showMoreImages(images: [AvatarImageModel]) {
        avatarGalleryDataSource.addImages(images)
    }
    
    func didSelectImage(_ image: UIImage) {
        delegate?.didChooseImage(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    func showLoader() {
        loaderView.isHidden = false
    }
    
    func hideLoader() {
        loaderView.isHidden = true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
 extension AvatarGalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let totalSpacing = (2 * Constants.spacing) + ((numberOfItemsPerRow - 1) * Constants.spacing)
        
        let totalWidth = collectionView.bounds.size.width
        let itemWidth = (totalWidth - totalSpacing) / numberOfItemsPerRow

        return CGSize(width: itemWidth, height: itemWidth)
    }
 }

// MARK: - UICollectionViewDelegate
extension AvatarGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectImage(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemsCount = avatarGalleryDataSource.getImagesCount()
        if indexPath.item == (itemsCount - 4) {
            presenter.loadMoreImages()
        }
    }
}
