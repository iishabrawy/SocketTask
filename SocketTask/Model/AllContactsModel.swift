//
//  AllContactsModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 22/12/2020.
//

import Foundation

// MARK: - AllContactsModel
class AllContactsModel: Codable {
    var data: [ContactsData]?
    var page, pageCount, limit, totalCount: Int?
    var links: Links?

    init() {
        
    }
    
    init(data: [ContactsData]?, page: Int?, pageCount: Int?, limit: Int?, totalCount: Int?, links: Links?) {
        self.data = data
        self.page = page
        self.pageCount = pageCount
        self.limit = limit
        self.totalCount = totalCount
        self.links = links
    }
}

// MARK: - Datum
class ContactsData: Codable {
    var friends: [Int]?
    var deleted: Bool?
    var fullname, phone, createdAt, updatedAt: String?
    var id: Int?
    var img: String?

    init(friends: [Int]?, deleted: Bool?, fullname: String?, phone: String?, createdAt: String?, updatedAt: String?, id: Int?, img: String?) {
        self.friends = friends
        self.deleted = deleted
        self.fullname = fullname
        self.phone = phone
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.img = img
    }
}
