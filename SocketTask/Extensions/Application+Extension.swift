//
//  Application+Extension.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func jsonString(from object:Any) -> String? {
        
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object:Any) -> Data? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
    
    static func converToUserLoginModel() -> LoginModel? {
        let userStr = KeychainWrapper.standard.string(forKey: "User") ?? ""
        let data = Data(userStr.utf8)
        let decoder = JSONDecoder()
        do {
            let userData = try decoder.decode(LoginModel.self, from: data)
            return userData
        } catch {
            return nil
        }
    }
}

