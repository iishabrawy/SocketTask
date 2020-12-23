//
//  RegisterViewModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 21/12/2020.
//

import RxSwift
import RxRelay
import Alamofire
import SwiftyJSON

class RegisterViewModel {

    var phoneBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var fullNameBehavior = BehaviorRelay<String>(value: "")

    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    var registerModelSubject = PublishSubject<LoginModel>()
    
    var isPhoneValid: Observable<Bool> {
        return phoneBehavior.asObservable().map { (phone) -> Bool in
            let isPhoneEmpty = phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isPhoneEmpty
        }
    }
    
    var isPasswordValid: Observable<Bool> {
        return passwordBehavior.asObservable().map { (pass) -> Bool in
            let isPassEmpty = pass.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isPassEmpty
        }
    }
    
    var isFullNameValid: Observable<Bool> {
        return fullNameBehavior.asObservable().map { (name) -> Bool in
            let isNameEmpty = name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return isNameEmpty
        }
    }
    
    var isRegisterButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isPhoneValid, isPasswordValid, isFullNameValid) { (isPhoneEmpty, isPasswordEmpty, isFullNameEmpty) in
            let registerValid = !isPhoneEmpty && !isPasswordEmpty && !isFullNameEmpty
            return registerValid
        }
    }
    
    var registerModelObservable: Observable<LoginModel> {
        return registerModelSubject
    }
    
    var registerViewModel: LoginModel {
        didSet {
            self.saveUser()
        }
    }
    
    private var registerModelVar = BehaviorRelay<LoginModel>(value: LoginModel.init())
    var registerModel: Observable<LoginModel> {
        return registerModelVar.asObservable()
    }
    
    init() {
        self.registerViewModel = LoginModel()
    }

    
    func registerUser() {
        self.loadingBehavior.accept(true)
        
        let infoResource = Resource<LoginModel>(url: URL(string: Utils().parseConfig().BaseURL)!, endPoint: "/api/v1/signup")
        let prams = ["phone": phoneBehavior.value,
                     "password": passwordBehavior.value,
                     "fullname": fullNameBehavior.value]
                
        let heads = ["Accept": "application/json"]
        let headers = HTTPHeaders(heads)
        
        
        Webservice().load(resource: infoResource, method: .post, prams: prams, headers: headers, encoding: .default) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let loginData):
                if (loginData != nil && loginData.user != nil && loginData.token != nil) {
                    self.registerViewModel = loginData
                    self.registerModelSubject.onNext(loginData)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func saveUser() {
        KeychainWrapper.standard.set(self.registerViewModel.convertToJson(), forKey: "User")
    }
    
}
