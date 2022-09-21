//
//  PanGestureAnimator.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 29.04.2022.
//

import UIKit

final class PanGestureAnimator: NSObject {
    weak var view: UIView?
    
    private lazy var cell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "gerb")?.cgImage
        cell.birthRate = 10
        cell.lifetime = 0.5
        cell.velocity = 70
        cell.scale = 0.4
        cell.scaleRange = 0.01
        cell.alphaSpeed = -1
        cell.emissionRange = CGFloat.pi * 2
        return cell
    }()
    
    private lazy var imageLayer: CAEmitterLayer = {
        let imageLayer = CAEmitterLayer()
        imageLayer.emitterSize = CGSize(width: 30, height: 30)
        imageLayer.emitterShape = .circle
        imageLayer.emitterCells = [cell]
        return imageLayer
    }()
    
    init(view: UIView) {
        self.view = view
        super.init()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tap(recogniser:) ))
        tapGesture.minimumPressDuration = 0
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view?.addGestureRecognizer(tapGesture)
    }
    
    @objc func tap(recogniser: UILongPressGestureRecognizer) {
        switch recogniser.state {
        case .began:
            showSalut()
            imageLayer.emitterPosition = recogniser.location(in: view)
        case .changed:
            imageLayer.emitterPosition = recogniser.location(in: view)
        case .ended:
            hideSalut()
        default: return
        }
    }
    
    private func showSalut() {
        view?.layer.addSublayer(imageLayer)
    }

    private func hideSalut() {
        imageLayer.removeFromSuperlayer()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension PanGestureAnimator: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
