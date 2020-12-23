//
//  ChatListViewModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import RxSwift
import RxRelay
import Alamofire
import SwiftyJSON

class ChatListViewModel {
 
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
 
    private var chatListModelSubject = PublishSubject<[FriendData]>()

    var chatListModelObservable: Observable<[FriendData]> {
        return chatListModelSubject
    }
    
    var friendsViewModel: FriendsModel
    
    init() {
        self.friendsViewModel = FriendsModel()
    }
    
    func getFriends() {
        self.loadingBehavior.accept(true)
        let user = UIApplication.converToUserLoginModel()

        let infoResource = Resource<FriendsModel>(url: URL(string: Utils().parseConfig().BaseURL)!, endPoint: "/api/v1/friends/\(user?.user?.id ?? 0)/friends")
        let heads = ["Content-Type": "application/json",
                     "Accept": "application/json",
                     "Authorization": "Bearer \(user?.token ?? "")"]
        let headers = HTTPHeaders(heads)
        let prams = ["limit": 1000]

        
        Webservice().load(resource: infoResource, method: .get, prams: prams, headers: headers, encoding: .queryString) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let friendsData):
                if (friendsData != nil && friendsData.data != nil) {
                    self.friendsViewModel = friendsData
                    self.chatListModelSubject.onNext(friendsData.data ?? [])
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
}
