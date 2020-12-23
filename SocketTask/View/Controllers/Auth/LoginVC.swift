//
//  LoginVC.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import UIKit
import RxCocoa
import RxSwift


class LoginVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    //MARK: - End Outlets
    
    
    //MARK: - Vars
    let disposeBag = DisposeBag()
    var loginViewModel = LoginViewModel()
    
    //MARK: - End Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.bindTextFieldsToViewModel()
        self.subsribeToResponse()
        self.subscribeToLoading()
        self.subsribeIsLoginEnabled()
        self.subscribeToLoginButton()
        self.subscribeToRegisterButton()
    }
    
    private func subscribeToRegisterButton() {
        self.registerBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                //Show Register ViewController
                let registerVC = ControllerProvider.viewController(className: RegisterVC.self, storyBoard: .homeStoryBoard)
                self.present(registerVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func subscribeToLoginButton() {
        self.loginBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.loginViewModel.loginUser()
            }).disposed(by: disposeBag)
    }
    
    private func bindTextFieldsToViewModel() {
        self.phoneNumberTxt.rx
            .text
            .orEmpty
            .bind(to: self.loginViewModel.phoneBehavior)
            .disposed(by: disposeBag)
        self.passwordTxt.rx
            .text
            .orEmpty
            .bind(to: self.loginViewModel.passwordBehavior)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToLoading() {
        self.loginViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if (isLoading) {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeToResponse() {
        self.loginViewModel.loginModelObservable.subscribe(onNext: {
            if ($0.user != nil) {
                //Open Chat List View Controller
                SocketHelper.shared.establishConnection()
                let chatListVC = ControllerProvider.viewController(className: ChatsNavigationVC.self, storyBoard: .chatStoryBoard)
                self.present(chatListVC, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeIsLoginEnabled() {
        self.loginViewModel.isLoginButtonEnabled.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
    }
    
}

