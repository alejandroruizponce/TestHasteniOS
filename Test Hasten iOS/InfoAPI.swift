//
//  InfoAPI.swift
//  Test Hansen iOS
//
//  Created by Alejandro Ruiz Ponce on 09/01/2020.
//  Copyright © 2020 Alejandro Ruiz Ponce. All rights reserved.
//

import Alamofire

struct InfoAPI {
    
    static let path = Bundle.main.path(forResource: "SportsResources", ofType: "plist")
    static let keys = NSDictionary(contentsOfFile: path!)
    static let urlAPI = keys!["SportsURL"] as! String

    static func getSports(completion: @escaping (_ result: NSArray) -> ()) {

        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(urlAPI, method: .get, parameters : nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                if let JSON = result as? NSArray {
                    completion(JSON)
                    print("GET Sports request successed! Response: \(JSON)")
                }
            case .failure(let error):
                print("GET Sports request ERROR! [CODE: \(response.response!.statusCode) - Response status: \(error)]")
            }
        }
    }
}

