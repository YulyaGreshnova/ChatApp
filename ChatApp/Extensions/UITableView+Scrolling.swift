//
//  UITableView+Scrolling.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 13.04.2022.
//

import Foundation
import UIKit

// Решение нашла
// https://stackoverflow.com/questions/33705371/how-to-scroll-to-the-exact-end-of-the-uitableview

extension UITableView {
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }

            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)

            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)

                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }

            guard self.indexPathIsValid(indexPath) else { return }

            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }

    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}
