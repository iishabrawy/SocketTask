//
//  MessagesModel.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import Foundation

// MARK: - MessagesModel
class MessagesModel: Codable {
    var data: [Datum]?
    var page, pageCount, limit, totalCount: Int?
    var links: Links?

    init(data: [Datum]?, page: Int?, pageCount: Int?, limit: Int?, totalCount: Int?, links: Links?) {
        self.data = data
        self.page = page
        self.pageCount = pageCount
        self.limit = limit
        self.totalCount = totalCount
        self.links = links
    }
    
    init() {
        
    }
}

// MARK: - Datum
class Datum: Codable {
    var seen: Bool?
    var id: Int?
    var content, createdAt: String?
    var user: User?

    enum CodingKeys: String, CodingKey {
        case seen
        case id = "_id"
        case content, createdAt, user
    }

    init(seen: Bool?, id: Int?, content: String?, createdAt: String?, user: User?) {
        self.seen = seen
        self.id = id
        self.content = content
        self.createdAt = createdAt
        self.user = user
    }
}

// MARK: - Links
class Links: Codable {
    var linksSelf: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }

    init(linksSelf: String?) {
        self.linksSelf = linksSelf
    }
}
