//
//  ProfileView.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.02.2022.
//

import UIKit

protocol ProfileViewDelegate: AnyObject {
    func didPressEditAvatarButton()
    func didPressSaveGCDButton(avatarImage: UIImage?, fullname: String?, detailInfo: String?)
    func didPressCancelButton()
}

final class ProfileView: UIView {
    private let avatarView = AvatarView(style: .large)

    // Сделала данную кнопку internal, чтобы можно было распечатать ее frame в VC
    let editAvatarButton = UIButton(type: .system)
    private let scrollView = UIScrollView()
    private let nameTextField = UITextField()
    private let userDetailInfoTextField = UITextView()
    private let stackView = UIStackView()
    private let editAndCancelButton = UIButton(type: .system)
    private let saveButtonsView = UIView()
    private let saveGCDButton = UIButton(type: .system)
    private let placeholderForTextView = "О себе"

     var isEditing: Bool = false {
        didSet {
            if isEditing {
                showEditForm()
            } else {
                hideEditForm()
            }
        }
    }

    var isSaveButtonsEnabled: Bool = false {
        didSet {
            if isSaveButtonsEnabled {
                saveGCDButton.isEnabled = true
            } else {
                saveGCDButton.isEnabled = false
            }
        }
    }

    weak var delegate: ProfileViewDelegate?

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        accessibilityIdentifier = "ProfileView"
        subscribeKeyboardNotifications()

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false

        scrollView.addGestureRecognizer(tapGesture)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        avatarView.backgroundColor = UIColor(red: 228 / 255, green: 232 / 255, blue: 43 / 255, alpha: 1)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(avatarView)

        editAvatarButton.setTitle("Edit", for: .normal)
        editAvatarButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        editAvatarButton.addTarget(self, action: #selector(pressEditAvatarButton), for: .touchUpInside)
        editAvatarButton.isHidden = true
        editAvatarButton.accessibilityIdentifier = "EditAvatarButton"
        editAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(editAvatarButton)

        nameTextField.placeholder = "Имя Фамилия"
        nameTextField.textAlignment = .center
        nameTextField.isEnabled = false
        nameTextField.delegate = self
        nameTextField.font = UIFont.boldSystemFont(ofSize: 24)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameTextField)

        userDetailInfoTextField.text = placeholderForTextView
        userDetailInfoTextField.font = .italicSystemFont(ofSize: 16)
        userDetailInfoTextField.textColor = .black
        userDetailInfoTextField.delegate = self
        userDetailInfoTextField.textContainer.maximumNumberOfLines = 3
        userDetailInfoTextField.isEditable = false
        userDetailInfoTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(userDetailInfoTextField)

        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        editAndCancelButton.setTitle("Edit", for: .normal)
        editAndCancelButton.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        editAndCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        editAndCancelButton.layer.cornerRadius = 10
        editAndCancelButton.addTarget(self, action: #selector(tapEditButton), for: .touchUpInside)
        stackView.addArrangedSubview(editAndCancelButton)

        saveButtonsView.isHidden = true
        stackView.addArrangedSubview(saveButtonsView)

        saveGCDButton.setTitle("Save GCD", for: .normal)
        saveGCDButton.isEnabled = false
        saveGCDButton.backgroundColor = UIColor(red: 246 / 255, green: 246 / 255, blue: 246 / 255, alpha: 1)
        saveGCDButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        saveGCDButton.layer.cornerRadius = 10
        saveGCDButton.addTarget(self, action: #selector(pressSaveGCDButton), for: .touchUpInside)
        saveGCDButton.translatesAutoresizingMaskIntoConstraints = false
        saveButtonsView.addSubview(saveGCDButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            avatarView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -68),
            avatarView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 68),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            avatarView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 6),

            editAvatarButton.centerYAnchor.constraint(equalTo: avatarView.bottomAnchor),
            editAvatarButton.centerXAnchor.constraint(equalTo: avatarView.trailingAnchor),
            editAvatarButton.heightAnchor.constraint(equalToConstant: 40),

            nameTextField.topAnchor.constraint(equalTo: editAvatarButton.bottomAnchor, constant: 10),
            // сделала так, чтобы при длинном имени текст не вылезал за границы экрана
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8),

            userDetailInfoTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 32),
            userDetailInfoTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 8),
            userDetailInfoTextField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -8),
            userDetailInfoTextField.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: userDetailInfoTextField.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -50),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -8),

            saveGCDButton.topAnchor.constraint(equalTo: saveButtonsView.topAnchor),
            saveGCDButton.leadingAnchor.constraint(equalTo: saveButtonsView.leadingAnchor),
            saveGCDButton.trailingAnchor.constraint(equalTo: saveButtonsView.trailingAnchor),
            saveGCDButton.bottomAnchor.constraint(equalTo: saveButtonsView.bottomAnchor)
        ])
    }

    @objc func pressEditAvatarButton() {
        editAvatarButton.stopShakingAnimation()
        delegate?.didPressEditAvatarButton()
    }

    @objc func pressSaveGCDButton() {
        delegate?.didPressSaveGCDButton(avatarImage: avatarView.image,
                                        fullname: nameTextField.text,
                                        detailInfo: userDetailInfoTextField.text)
    }

    func updateAvatarImage(image: UIImage?) {
        avatarView.showImage(image: image)
        if isEditing {
            isSaveButtonsEnabled = true
        }
    }

    func updateUserInfo(fullName: String?, detailInfo: String?) {
        nameTextField.text = fullName
        userDetailInfoTextField.text = detailInfo
    }
}

// MARK: - Internal Methods
private extension ProfileView {
    func hideEditForm() {
        editAvatarButton.isHidden = true
        saveButtonsView.isHidden = true
        editAndCancelButton.setTitle("Edit", for: .normal)
    }

    func showEditForm() {
        editAvatarButton.isHidden = false
        editAvatarButton.startShakingAnimation()
        editAndCancelButton.setTitle("Cancel", for: .normal)
        saveButtonsView.isHidden = false
        nameTextField.isEnabled = true
        userDetailInfoTextField.isEditable = true
        nameTextField.becomeFirstResponder()
    }

    @objc func tapEditButton() {
        isEditing.toggle()
        if !isEditing {
            delegate?.didPressCancelButton()
        }
    }

    @objc func hideKeyboard() {
        endEditing(false)
    }

    @objc func textFieldDidChange() {
        isSaveButtonsEnabled = true
    }
}

// MARK: - TextViewDelegate
extension ProfileView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        isSaveButtonsEnabled = true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
    }
}

// MARK: - TextFieldDelegate
extension ProfileView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.scrollView.endEditing(true)
        return false
    }
}

// MARK: - Notification
extension ProfileView {
    func subscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(notification:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide(notification:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }
}

// MARK: - Keyboard
private extension ProfileView {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        var contentInsets = scrollView.contentInset
        let keyboardViewEndFrame = scrollView.convert(keyboardFrame, from: self.window)
        let bottomInset = scrollView.bounds.height - keyboardViewEndFrame.origin.y + scrollView.contentOffset.y
        contentInsets.bottom = bottomInset

        let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
}
