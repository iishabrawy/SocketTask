//
//  AllContactsViewModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Alamofire

class AllContactsViewModel {
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var allContactsModelSubject = PublishSubject<[ContactsData]>()

    var allContactsModelObservable: Observable<[ContactsData]> {
        return allContactsModelSubject
    }
    
    var allContactsViewModel: AllContactsModel
    
    init() {
        self.allContactsViewModel = AllContactsModel()
    }
    
    func getAllContacts() {
        self.loadingBehavior.accept(true)
        let user = UIApplication.converToUserLoginModel()

        let infoResource = Resource<AllContactsModel>(url: URL(string: Utils().parseConfig().BaseURL)!, endPoint: "/api/v1/getAll")
        let heads = ["Content-Type": "application/json",
                     "Accept": "application/json",
                     "Authorization": "Bearer \(user?.token ?? "")"]
        let headers = HTTPHeaders(heads)
        let prams = ["limit": 1000]

        Webservice().load(resource: infoResource, method: .get, prams: prams, headers: headers, encoding: .queryString) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let contactsData):
                if (contactsData != nil && contactsData.data != nil) {
                    self.allContactsViewModel = contactsData
                    self.allContactsModelSubject.onNext(contactsData.data ?? [])
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
}
