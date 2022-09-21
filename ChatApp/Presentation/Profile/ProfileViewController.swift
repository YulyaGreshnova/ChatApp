//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let headerView = HeaderView()
    private let profileView = ProfileView()
    private let loadingView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView()
    private let userService: UserService
    var router: ProfileRouterProtocol?
    
    init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        loadUserInfoGCD()
    }
}

// MARK: - View configuration

extension ProfileViewController {
    private func setupView() {
        headerView.delegate = self
        headerView.backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        profileView.delegate = self
        profileView.backgroundColor = .white
        profileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileView)
        
        loadingView.backgroundColor = .white
        loadingView.alpha = 0.7
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        view.addSubview(loadingView)

        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.style = .large
        activityIndicatorView.color = .systemBlue
        loadingView.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicatorView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 96),
            
            profileView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - ProfileViewDelegate
extension ProfileViewController: ProfileViewDelegate {
    func didPressEditAvatarButton() {
        var actions: [UIAlertAction] = []
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) {_ in
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            actions.append(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Установить из галлереи", style: .default) {_ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let loadAction = UIAlertAction(title: "Загрузить", style: .default) { _ in
            self.router?.openRemoteGallery(delegate: self)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        actions.append(contentsOf: [libraryAction, loadAction, cancelAction])
        self.showAlert(title: "Выбери изображение профиля",
                  message: nil,
                  actions: actions,
                  preferredStyle: .actionSheet)
    }

    func didPressSaveGCDButton(avatarImage: UIImage?, fullname: String?, detailInfo: String?) {
        loadingView.isHidden = false
        activityIndicatorView.startAnimating()

        let userInfo = UserInfo(fullName: fullname, detailInfo: detailInfo)
        userService.saveGCD(avatar: avatarImage, userInfo: userInfo) { [weak self] isSuccess in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                
                if isSuccess {
                    self.showSuccessfulMessageSaving()
                } else {
                    self.showFailureMessageSaving(avatarImage: avatarImage, fullname: fullname, detailInfo: detailInfo)
                }
            }
        }
    }
    
    func didPressCancelButton() {
        let user = userService.currentUser
        profileView.updateAvatarImage(image: user.avatar)
        profileView.updateUserInfo(fullName: user.userInfo.fullName,
                                   detailInfo: user.userInfo.detailInfo)
    }
}

// MARK: - HeaderViewDelegate
extension ProfileViewController: HeaderViewDelegate {
    func didPressCloseButton() {
        router?.close()
    }
}

// MARK: - ImagePickerController
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        profileView.updateAvatarImage(image: image)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Internal Methods
private extension ProfileViewController {
    func showSuccessfulMessageSaving() {
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            self.profileView.isEditing = false
        }
        router?.showAlert(title: nil, message: "Данные сохранены", actions: [action])
    }
    
    func showFailureMessageSaving(avatarImage: UIImage?, fullname: String?, detailInfo: String?) {
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.profileView.isEditing = false
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: {_ in
            self.didPressSaveGCDButton(avatarImage: avatarImage, fullname: fullname, detailInfo: detailInfo)
        })
        router?.showAlert(title: "Ошибка",
                          message: "Не удалось сохранить данные",
                          actions: [okAction, repeatAction])
    }
    
    func loadUserInfoGCD() {
        loadingView.isHidden = false
        activityIndicatorView.startAnimating()
        
        userService.fetchGCD { [weak self] user in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.activityIndicatorView.stopAnimating()
                
                self.profileView.updateAvatarImage(image: user.avatar)
                self.profileView.updateUserInfo(fullName: user.userInfo.fullName, detailInfo: user.userInfo.detailInfo)
            }
        }
    }
}

// MARK: - AvatarGalleryDelegate
extension ProfileViewController: AvatarGalleryDelegate {
    func didChooseImage(image: UIImage) {
        profileView.updateAvatarImage(image: image)
    }
}
