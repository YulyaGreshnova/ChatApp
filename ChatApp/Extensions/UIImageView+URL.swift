//
//  UIImageView + URL.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 26.04.2022.
//

import UIKit

extension UIImageView {
    func loadFromUrl(url: URL, completion: @escaping(Bool) -> Void) {
        ImageLoader.cancelLoad(id: self)
        ImageLoader.fetchImageFrom(url: url, id: self) {[weak self] image in
            guard let self = self else { return }
            guard let image = image else {
                completion(false)
                return
            }
            self.image = image
            completion(true)
        }
    }
}
