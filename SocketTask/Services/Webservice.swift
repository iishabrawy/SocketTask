//
//  Webservice.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 20/12/2020.
//

import Alamofire

//Enum to Network Error
enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
}

struct Resource<T: Codable> {
    let url: URL
    let endPoint: String
}

class Webservice {
    func load<T>(resource: Resource<T>, method: HTTPMethod,
                 prams: Parameters?,
                 headers: HTTPHeaders?,
                 encoding: URLEncoding, completion: @escaping (Result<T, NetworkError>) -> Void) {
        AF.request(URL(string: "\(resource.url)\(resource.endPoint)")!, method: method, parameters: prams, encoding: encoding, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: response.data!)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    print(error)
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                print(error)
                completion(.failure(.decodingError))
          }
        }
    }
    
}
