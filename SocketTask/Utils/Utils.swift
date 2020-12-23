//
//  Utils.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import Foundation

class Utils {
    init() {
        
    }
    
    //Get Base url from config.plist file
    func parseConfig() -> ConfigModel {
        let url = Bundle.main.url(forResource: "Config", withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(ConfigModel.self, from: data)
    }
    
}

