//
// ChatInputView.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 29.03.2022.
//

import UIKit

protocol ChatInputViewDelegate: AnyObject {
    func didPressSendButton(text: String)
}

final class ChatInputView: UIView {
    private let textView = UITextView()
    private let sendMessageButton = UIButton()
    weak var delegate: ChatInputViewDelegate?
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor(red: 247 / 255, green: 247 / 255, blue: 247 / 255, alpha: 1)
        autoresizingMask = .flexibleHeight
        
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 0.5
        textView.delegate = self        
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        sendMessageButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendMessageButton.isEnabled = false
        sendMessageButton.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 8)
        sendMessageButton.layer.cornerRadius = 4
        sendMessageButton.addTarget(self, action: #selector(tapSendMessageButton), for: .touchUpInside)
        sendMessageButton.setContentCompressionResistancePriority(.required - 1, for: .horizontal)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sendMessageButton)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                             constant: -8),
            
            sendMessageButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            sendMessageButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 8),
            sendMessageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sendMessageButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
    }
    
    override var intrinsicContentSize: CGSize {
        let minimumHeight = 48 + safeAreaInsets.bottom
        let currentHeight: CGFloat = max(textView.contentSize.height, minimumHeight)
        let height: CGFloat = min(currentHeight, 200)
        return .init(width: self.bounds.width, height: height)
    }
    
    @objc func tapSendMessageButton() {
        guard let text = textView.text else { return }
        textView.resignFirstResponder()
        delegate?.didPressSendButton(text: text)
    }
    
    func updateMessageText(text: String) {
        textView.text = text
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - TextViewDelegate
extension ChatInputView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        invalidateIntrinsicContentSize()
        sendMessageButton.isEnabled = !textView.text.isEmpty
    }
}
