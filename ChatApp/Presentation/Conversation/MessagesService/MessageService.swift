//
//  MessageService.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 28.03.2022.
//

import Foundation
import FirebaseFirestore

enum MessageServerError: Error {
    case invalidState
}

protocol MessagesServiceDelegate: AnyObject {
    func didAddNewMessage(message: Message)
    func didLoadMessages(messages: [Message])
}

protocol IMessageService {
    var delegate: MessagesServiceDelegate? { get set }
    func createNewMessage(text: String, completion: @escaping (Bool) -> Void)
    func startListeningMessages()
}

class MessageService: IMessageService {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels/\(channelId)/messages")
    private var messageListener: ListenerRegistration?
    private var isInitialLoad: Bool = true
    
    private let userService = UserService.shared
    
    weak var delegate: MessagesServiceDelegate?
    
    private let channelId: String
       
    init(channelId: String) {
        self.channelId = channelId
    }
    func createNewMessage(text: String, completion: @escaping (Bool) -> Void) {
        let mes = Message(content: text,
                          created: Date(),
                          senderID: userService.userId,
                          senderName: userService.currentUser.userInfo.fullName ?? "Аноним")
        reference.addDocument(data: mes.toDict) { error in
            completion(error == nil)
        }
    }
    
    func startListeningMessages() {
        messageListener = reference.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            guard error == nil else {
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            if self.isInitialLoad {
                self.handleInitialLoad(documents: snapshot.documents)
                self.isInitialLoad = false
            } else {
                snapshot.documentChanges.forEach { change in
                    self.handleDocumentChange(change)
                }
            }
        }
    }
    
    private func handleInitialLoad(documents: [QueryDocumentSnapshot]) {
        let messages = documents.compactMap {
            Message(dict: $0.data())
        }
        delegate?.didLoadMessages(messages: messages)
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(dict: change.document.data()) else { return }

        switch change.type {
        case .added:
            delegate?.didAddNewMessage(message: message)
        default:
            break
        }
    }
}
