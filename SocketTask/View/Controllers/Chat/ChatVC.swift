//
//  ChatVC.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import UIKit
import RxCocoa
import RxSwift

class ChatVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var chatMessagesTableView: UITableView!
    @IBOutlet weak var messgeTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    //MARK: - End Outlets
    
    //MARK: - Vars
    let disposeBag = DisposeBag()
    let messageCellTxt = "MessageCellTxt"
    let messageCellTxt_ = "MessageCellTxt_"
    
    var friend: Friend?
    var chatViewModel = ChatViewModel()
    
    var imageView = UIImageView()
    //MARK: - End Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.friend?.fullname ?? ""
        setupTableView()
        bindTextFieldsToViewModel()
        subscribeToLoading()
        subsribeToResponse()
        subscribeToDataSelection()
        subscribeToSendButton()
        subsribeIsSendEnabled()
        subscribeToScroll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getFriendMessages()
    }
    
    private func setupTableView() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        chatMessagesTableView
            .register(UINib(nibName: messageCellTxt_, bundle: nil), forCellReuseIdentifier: messageCellTxt_)
        chatMessagesTableView
            .register(UINib(nibName: messageCellTxt, bundle: nil), forCellReuseIdentifier: messageCellTxt)
    }
    
    private func bindTextFieldsToViewModel() {
        self.messgeTxt.rx
            .text
            .orEmpty
            .bind(to: self.chatViewModel.messageBehavior)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToSendButton() {
        self.sendBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.chatViewModel.sendNewMessage(id: self.friend?.id ?? 0)
                self.messgeTxt.text = ""
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
    }
    
    private func subsribeIsSendEnabled() {
        self.chatViewModel.isSendButtonEnabled
            .bind(to: sendBtn.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToLoading() {
        self.chatViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if (isLoading) {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subscribeToScroll() {
        self.chatViewModel.scrollBehavior.subscribe(onNext: { (row) in
            if (row > 0) {
                self.chatMessagesTableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeToResponse() {
        self.chatViewModel.chatMessagesModelObservable
            .bind(to: chatMessagesTableView.rx.items) { [weak self] (table, row, item) -> UITableViewCell in
                let user = UIApplication.converToUserLoginModel()
                if (item.user?.id == user?.user?.id) {
                    let cell = table.dequeueReusableCell(withIdentifier: self?.messageCellTxt_ ?? "", for: IndexPath.init(row: row, section: 0)) as! MessageCellTxt_
                    cell.cellConfigure(msg: item)
                    return cell
                } else {
                    let cell = table.dequeueReusableCell(withIdentifier: self?.messageCellTxt ?? "", for: IndexPath.init(row: row, section: 0)) as! MessageCellTxt
                    cell.cellConfigure(msg: item)
                    return cell
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToDataSelection() {
        Observable
            .zip(chatMessagesTableView.rx.itemSelected, chatMessagesTableView.rx.modelSelected(Datum.self))
            .bind { [weak self] _, friend in
                
            }
            .disposed(by: disposeBag)
    }
    
    func getFriendMessages() {
        self.chatViewModel.getFriendMessages(friendId: friend?.id ?? 0)
    }
    
}
