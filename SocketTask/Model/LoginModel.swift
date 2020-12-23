//
//  LoginModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import Foundation

// MARK: - LoginModel
class LoginModel: Codable {
    var user: User?
    var token: String?
    
    init() {
        
    }
    
    init(user: User?, token: String?) {
        self.user = user
        self.token = token
    }
    
    func convertToJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self)
        let json = String(data: jsonData!, encoding: .utf8)
        return json ?? ""
    }
}

// MARK: - User
class User: Codable {
    var friends: [Int]?
    var deleted: Bool?
    var fullname, phone, createdAt, updatedAt: String?
    var img: String?
    var id: Int?
    
    init(friends: [Int]?, deleted: Bool?, fullname: String?, img: String?, phone: String?, createdAt: String?, updatedAt: String?, id: Int?) {
        self.friends = friends
        self.deleted = deleted
        self.fullname = fullname
        self.fullname = fullname
        self.img = img
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
    }
}
