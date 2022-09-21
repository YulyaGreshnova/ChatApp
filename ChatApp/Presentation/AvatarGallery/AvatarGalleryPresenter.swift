//
//  AvatarGalleryPresenter.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 26.04.2022.
//

import UIKit

protocol IAvatarGalleryPresenter: AnyObject {
    func viewLoaded()
    func loadMoreImages()
    func selectImage(at index: Int)
}

final class AvatarGalleryPresenter: IAvatarGalleryPresenter {
    weak var viewController: IAvatarGalleryViewController?
    private let avatarRequestSender = AvatarRequestSender()
    private var isLoading: Bool = false
    private var currentPage: Int = 1
    private var images: [AvatarImageModel] = []
    
    private struct Constants {
        static let perPage = 100
        static let page = 1
    }
    
    private func loadImages(page: Int,
                            perPage: Int,
                            completion: @escaping(Result<[AvatarImageModel], Error>) -> Void) {
        avatarRequestSender.loadImages(page: page, perPage: perPage) { result in
            completion(result)
        }
    }
    
    func loadMoreImages() {
        guard !isLoading else { return }
        isLoading = true
        currentPage += 1
        avatarRequestSender.loadImages(page: currentPage,
                                       perPage: Constants.perPage) {  [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let avatarImages):
                    self.images += avatarImages
                    self.viewController?.showMoreImages(images: avatarImages)
                case .failure(let error):
                    self.viewController?.showError(error: error)
                }
                self.isLoading = false
            }
        }
    }
    
    func viewLoaded() {
        loadImages(page: Constants.page, perPage: Constants.perPage) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let avatarImages):
                    self.images = avatarImages
                    self.viewController?.showImages(images: avatarImages)
                case .failure(let error):
                    self.viewController?.showError(error: error)
                }
            }
        }
    }
    
    func selectImage(at index: Int) {
        viewController?.showLoader()
        let url = images[index].imageURL
        ImageLoader.fetchImageFrom(url: url, id: nil) {[weak self] image in
            guard let self = self else { return }
            if let image = image {
                self.viewController?.didSelectImage(image)
                self.viewController?.hideLoader()
            }
        }
    }
}
