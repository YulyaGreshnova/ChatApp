//
//  ChannelsService.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 26.03.2022.
//

import Foundation
import FirebaseFirestore

protocol ChannelsServiceDelegate: AnyObject {
    func didAddNewChannel(channel: Channel)
    func didDeleteChannel(channel: Channel)
    func didUpdateChannel(channel: Channel)
    func didLoadChannels(channels: [Channel])
}

enum ChannelServiceError: Error {
    case invalidState
}

protocol IChannelsService {
    var delegate: ChannelsServiceDelegate? { get set }
    func createNewChannel(name: String, completion: @escaping (Bool) -> Void)
    func startListeningChannels()
    func stopListeningChannels()
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void)
}

final class ChannelsService: IChannelsService {
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    weak var delegate: ChannelsServiceDelegate?
    private(set) var channelListener: ListenerRegistration?
    private var isInitialLoad: Bool = true
    
    func createNewChannel(name: String, completion: @escaping (Bool) -> Void) {
        let id = reference.document().documentID
        let channel = Channel(identifier: id, name: name, lastMessage: nil, lastActivity: Date())
                                
        reference.document(id).setData(channel.toDict) { error in
            completion(error == nil)
        }
    }
        
    func startListeningChannels() {
        channelListener = reference.addSnapshotListener { [weak self] (snapshot, error) in
            guard let self = self else { return }
            guard error == nil else {
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            if self.isInitialLoad {
                self.handleInitialLoad(documents: snapshot.documents)
                self.isInitialLoad = false
            } else {
                snapshot.documentChanges.forEach {
                    self.handleDocumentsChange($0)
                }
            }
        }
    }
    
    func stopListeningChannels() {
        channelListener?.remove()
        isInitialLoad = true
    }
    
    func deleteChannel(id: String, completion: @escaping (Bool) -> Void) {
        reference.document(id).delete { error in
            completion(error == nil)
        }
    }

    private func handleInitialLoad(documents: [QueryDocumentSnapshot]) {
        let channels = documents.compactMap {
            Channel(dict: $0.data(), id: $0.documentID)
        }
        delegate?.didLoadChannels(channels: channels)
    }

    private func handleDocumentsChange(_ change: DocumentChange) {
        guard let channel = Channel(dict: change.document.data(),
                                    id: change.document.documentID)
        else { return }
        
        switch change.type {
        case .added:
            delegate?.didAddNewChannel(channel: channel)
        case .removed:
            delegate?.didDeleteChannel(channel: channel)
        case .modified:
            delegate?.didUpdateChannel(channel: channel)
        }
    }
}
