//
//  Api.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON


class API: NSObject {

    class func callRequest(completion: @escaping (_ error: Error?,
                                                  _ success: Bool,
                                                  _ model: Model?)->Void) {
        let url = "https://crudpro.php.fmv.cc/ios-practical.php"
        
        
        let parameters = [
            "event_id" : 2667,
            "lang_id" : 2376,
            "time_zone" : "Asia/Kolkata"
        ] as [String : Any]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result
                {
                case .failure(let error):
                    completion(error, false,nil)
                    print(error)
                    
                case .success(let _):
                    
                    if let jsonData = response.data
                    {
                        let json = JSON(jsonData)
                        let model = Model(json:json)
                        completion (nil,true,model)
                    }
                }
        }
    }
    
   
 
    
    
}

