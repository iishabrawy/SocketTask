//
//  LoginViewModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import RxSwift
import RxRelay
import Alamofire
import SwiftyJSON

class LoginViewModel {
    
    var phoneBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    var loginModelSubject = PublishSubject<LoginModel>()
    
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
    
    var isLoginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(isPhoneValid, isPasswordValid) { (isPhoneEmpty, isPasswordEmpty) in
            let loginValid = !isPhoneEmpty && !isPasswordEmpty
            return loginValid
        }
    }
    
    var loginModelObservable: Observable<LoginModel> {
        return loginModelSubject
    }
    
    var loginViewModel: LoginModel {
        didSet {
            self.saveUser()
        }
    }
    
    private var loginModelVar = BehaviorRelay<LoginModel>(value: LoginModel.init())
    var loginModel: Observable<LoginModel> {
        return loginModelVar.asObservable()
    }
    
    init() {
        self.loginViewModel = LoginModel()
    }
    
    func loginUser() {
        self.loadingBehavior.accept(true)
        
        let infoResource = Resource<LoginModel>(url: URL(string: Utils().parseConfig().BaseURL)!, endPoint: "/api/v1/signin")
        let prams = ["phone": phoneBehavior.value,
                     "password": passwordBehavior.value]
                
        let heads = ["Content-Type": "application/json",
                     "Accept": "application/json"]
        let headers = HTTPHeaders(heads)
        
        
        Webservice().load(resource: infoResource, method: .post, prams: prams, headers: headers, encoding: .queryString) { [weak self] result in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            switch result {
            case .success(let loginData):
                if (loginData != nil && loginData.user != nil && loginData.token != nil) {
                    self.loginViewModel = loginData
                    self.loginModelSubject.onNext(loginData)
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func saveUser() {
        KeychainWrapper.standard.set(self.loginViewModel.convertToJson(), forKey: "User")
    }
    
}
