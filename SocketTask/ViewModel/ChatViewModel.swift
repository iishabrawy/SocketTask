//
//  ChatViewModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import UIKit
import RxCocoa
import RxSwift
import Alamofire

class ChatViewModel {
    
    var messageBehavior = BehaviorRelay<String>(value: "")
    var scrollBehavior = BehaviorRelay<Int>(value: 0)

    var isMessageValid: Observable<Bool> {
        return messageBehavior.asObservable().map { (phone) -> Bool in
            let isMessageEmpty = phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isMessageEmpty
        }
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)

    private var chatMessagesModelSubject = PublishSubject<[Datum]>()

    var chatMessagesModelObservable: Observable<[Datum]> {
        return chatMessagesModelSubject
    }
    
    var isSendButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isMessageValid, isMessageValid) { (isMessageEmpty, isMessageEmpty_) in
            let sendValid = !isMessageEmpty && !isMessageEmpty_
            return sendValid
        }
    }
    
    var messagesViewModel: MessagesModel
    
    init() {
        self.messagesViewModel = MessagesModel()
        self.getMessages()
    }

    
    func getFriendMessages(friendId: Int) {
        self.loadingBehavior.accept(true)
        let user = UIApplication.converToUserLoginModel()

        let infoResource = Resource<MessagesModel>(url: URL(string: Utils().parseConfig().BaseURL)!, endPoint: "/api/v1/messages")
        let heads = ["Content-Type": "application/json",
                     "Accept": "application/json",
                     "Authorization": "Bearer \(user?.token ?? "")"]
        let headers = HTTPHeaders(heads)
        let prams = ["limit": 1000,
                     "userId": user?.user?.id ?? 0,
                     "friendId": friendId]
        
        
        Webservice().load(resource: infoResource, method: .get, prams: prams, headers: headers, encoding: .queryString) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let friendMessages):
                if (friendMessages != nil && friendMessages.data != nil) {
                    let newData = friendMessages
                    newData.data?.reverse()
                    self.messagesViewModel = newData
                    self.chatMessagesModelSubject.onNext(newData.data ?? [])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.scrollBehavior.accept(self.messagesViewModel.data!.count - 1)
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func sendNewMessage(id: Int) {
        SocketHelper.shared.addMessage(toID: id, content: messageBehavior.value) {

        }
    }
    
    func getMessages() {
        SocketHelper.shared.getMessage { (newMsg) in
            if (newMsg != nil) {
                self.messagesViewModel.data?.append(newMsg!)
                self.chatMessagesModelSubject.onNext(self.messagesViewModel.data ?? [])
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.scrollBehavior.accept(self.messagesViewModel.data!.count - 1)
                }
            }
        }
    }
    
}
