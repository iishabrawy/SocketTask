//
//  SocketHelper.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import UIKit
import Foundation
import SocketIO

let kNewFriend = "newFriend"
let kUserList = "userList"
let kAddMessage = "newMessage"

final class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    override init() {
        super.init()
        configureSocketClient()
    }
    
    private func configureSocketClient() {
        
        guard let url = URL(string: Utils().parseConfig().BaseURL) else {
            return
        }
        
        let myID = UIApplication.converToUserLoginModel()?.user?.id ?? 0
        manager = SocketManager(socketURL: url, config: [
                                    .connectParams(["id": myID]),
                                    .secure(true),
                                    .forceWebsockets(true),
                                    .reconnects(true),
                                    .compress,
                                    .log(true)])
        
        guard let manager = manager else {
            return
        }
        
        socket = manager.socket(forNamespace: "/chat")
    }
    
    func establishConnection() {
        
        guard let socket = manager?.socket(forNamespace: "/chat") else{
            return
        }
                
        socket.on(clientEvent: .connect) { (data, ackm) in
            print(data)
        }
        socket.on(clientEvent: .error) { (data, ackm) in
            print(data)
        }
        socket.on(clientEvent: .disconnect) { (data, ackm) in
            print(data)
        }
        
        socket.on("addFriend") { (dataArray, socketAck) in
            print(dataArray)
        }
        
        socket.connect()
    }
    
    func closeConnection() {
        
        guard let socket = manager?.socket(forNamespace: "/chat") else{
            return
        }
        
        socket.disconnect()
    }
    
    func addNewFriend(friendId: Int, completion: () -> Void) {
        
        guard let socket = manager?.socket(forNamespace: "/chat") else {
            return
        }
        
        let myID = UIApplication.converToUserLoginModel()?.user?.id ?? 0
        let jsonDict: [String : Any] = [
            "myId": myID,
            "friendId": friendId]
        
        socket.emit("addFriend", jsonDict)
        completion()
    }
    
    func addMessage(toID: Int, content: String?, msgType: String? = "txt", completion: () -> Void) {
        
        guard let socket = manager?.socket(forNamespace: "/chat") else{
            return
        }
        
        let myID = UIApplication.converToUserLoginModel()?.user?.id ?? 0
        
        let user: [String: Any] = [
            "_id" : myID
        ]
        
        var msgData: [String: Any] = [
            "msgType": msgType,
            "user": user
        ]
        if (content != nil) {
            msgData["content"] = content
        }
        
        var jsonDict: [String : Any] = [
            "toId": toID,
            "data": msgData]
        
        socket.emit("newMessage", jsonDict)
        completion()
    }
    
    func getMessage(completion: @escaping (_ messageInfo: Datum?) -> Void) {
        
        guard let socket = manager?.socket(forNamespace: "/chat") else {
            return
        }
        
        socket.on("newMessage") { (dataArray, socketAck) in
            
            var messageInfo = [String: Any]()
            
            guard let msgItem = dataArray[0] as? [String: Any] else{
                return
            }
            
            
//            messageInfo["content"] = msgItem["content"]
//            messageInfo["message"] = message
//            messageInfo["date"] = date
            
            guard let data = UIApplication.jsonData(from: msgItem) else {
                return
            }
            
            do {
                let messageModel = try JSONDecoder().decode(Datum.self, from: data)
                completion(messageModel)
            } catch let error {
                print("Something happen wrong here...\(error)")
                completion(nil)
            }
        }
    }
    
}
