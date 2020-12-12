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

    
    class func loadData(completion: @escaping (_ model: Model?)->Void)
    {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
          
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                  
                  let json = JSON(jsonResult)
                  let model = Model(json: json)
                  completion(model)
              } catch {
                  completion(nil)
              }
        }
    }
   
 
    
    
}

