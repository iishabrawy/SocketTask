//
//  RegisterVC.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 21/12/2020.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterVC: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var phoneNumberTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    //MARK: - End Outlets

    
    //MARK: - Vars
    let disposeBag = DisposeBag()
    var registerViewModel = RegisterViewModel()
    
    //MARK: - End Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    

    func setup() {
        self.bindTextFieldsToViewModel()
        self.subsribeToResponse()
        self.subscribeToLoading()
        self.subsribeIsRegisterEnabled()
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
                //Register New User
                self.registerViewModel.registerUser()
            }).disposed(by: disposeBag)
    }
    
    private func subscribeToLoginButton() {
        self.loginBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindTextFieldsToViewModel() {
        self.fullNameTxt.rx
            .text
            .orEmpty
            .bind(to: self.registerViewModel.fullNameBehavior)
            .disposed(by: disposeBag)
        self.phoneNumberTxt.rx
            .text
            .orEmpty
            .bind(to: self.registerViewModel.phoneBehavior)
            .disposed(by: disposeBag)
        self.passwordTxt.rx
            .text
            .orEmpty
            .bind(to: self.registerViewModel.passwordBehavior)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToLoading() {
        self.registerViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if (isLoading) {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeToResponse() {
        self.registerViewModel.registerModelObservable.subscribe(onNext: {
            if ($0.user != nil) {
                //Open Chat List View Controller
                SocketHelper.shared.establishConnection()
                let chatListVC = ControllerProvider.viewController(className: ChatsNavigationVC.self, storyBoard: .chatStoryBoard)
                self.present(chatListVC, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeIsRegisterEnabled() {
        self.registerViewModel
            .isRegisterButtonEnabled
            .bind(to: registerBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }

}
