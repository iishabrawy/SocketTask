//
//  ChatListVC.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 21/12/2020.
//

import UIKit
import RxCocoa
import RxSwift

class ChatListVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var friendsListTableView: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    //MARK: - End Outlets
    
    //MARK: - Vars
    let disposeBag = DisposeBag()
    var chatListViewModel = ChatListViewModel()
    
    let friendsCell = "FriendsCell"
    let myID = UIApplication.converToUserLoginModel()?.user?.id

    //MARK: - End Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindAddButton()
        subscribeToLoading()
        subsribeToResponse()
        subscribeToDataSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        getFriends()
    }
    
    private func setupTableView() {
        friendsListTableView
            .register(UINib(nibName: friendsCell, bundle: nil), forCellReuseIdentifier: friendsCell)
    }
    
    private func subscribeToLoading() {
        self.chatListViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if (isLoading) {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeToResponse() {
        self.chatListViewModel.chatListModelObservable
            .bind(to: friendsListTableView
                    .rx
                    .items(cellIdentifier: friendsCell, cellType: FriendsCell.self)) { (row, friend, cell ) in
                cell.textLabel?.text = friend.friend?.fullname ?? ""
                let bgView = UIView()
                bgView.backgroundColor = UIColor.clear
                cell.backgroundView = bgView
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToDataSelection() {
        Observable
            .zip(friendsListTableView.rx.itemSelected, friendsListTableView.rx.modelSelected(FriendData.self))
            .bind { [weak self] _, friend in
                //Open ChatVC
                let chatVC = ControllerProvider.viewController(className: ChatVC.self, storyBoard: .chatStoryBoard)
                if (friend.friend?.id == self?.myID) {
                    chatVC.friend = friend.user
                } else {
                    chatVC.friend = friend.friend
                }
                self?.navigationController?.pushViewController(chatVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAddButton() {
        addBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                //Show Get All Contacts
                let allContactsVC = ControllerProvider.viewController(className: AllContactsVC.self, storyBoard: .chatStoryBoard)
                self?.navigationController?.pushViewController(allContactsVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func getFriends() {
        self.chatListViewModel.getFriends()
    }
    
}
