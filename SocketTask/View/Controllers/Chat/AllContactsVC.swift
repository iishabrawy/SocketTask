//
//  AllContactsVC.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import UIKit
import RxSwift
import RxCocoa

class AllContactsVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var allContactsListTableView: UITableView!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    //MARK: - End Outlets
    
    //MARK: - Vars
    let disposeBag = DisposeBag()
    var allContactsViewModel = AllContactsViewModel()
    
    let friendsCell = "FriendsCell"
    
    var selectedFriend: ContactsData?
    
    //MARK: - End Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add New Friends"
        
        setupTableView()
        subscribeToLoading()
        subsribeToResponse()
        subscribeToDataSelection()
        bindAddFriendButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        getAllContacts()
    }
    
    private func setupTableView() {
        allContactsListTableView
            .register(UINib(nibName: friendsCell, bundle: nil), forCellReuseIdentifier: friendsCell)
    }
    
    private func subscribeToLoading() {
        self.allContactsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if (isLoading) {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    
    private func subsribeToResponse() {
        self.allContactsViewModel.allContactsModelObservable
            .bind(to: allContactsListTableView
                    .rx
                    .items(cellIdentifier: friendsCell, cellType: FriendsCell.self)) { (row, item, cell ) in
                cell.textLabel?.text = item.fullname ?? ""
                let bgView = UIView()
                bgView.backgroundColor = UIColor.clear
                cell.backgroundView = bgView
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeToDataSelection() {
        Observable
            .zip(allContactsListTableView.rx.itemSelected, allContactsListTableView.rx.modelSelected(ContactsData.self))
            .bind { [weak self] index, friend in
                self?.selectedFriend = friend
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAddFriendButton() {
        addFriendBtn
            .rx
            .tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if (self?.selectedFriend != nil) {
                    //Send Add Friend Socket
                    SocketHelper.shared.addNewFriend(friendId: self?.selectedFriend?.id ?? 0) {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func getAllContacts() {
        self.allContactsViewModel.getAllContacts()
    }
    
}
