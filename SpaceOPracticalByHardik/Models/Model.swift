//
//  Model.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import Foundation
import SwiftyJSON

class FilterModel: NSObject {
    var list = [Item]()
    
    init(items:[Item])
    {
        self.list = items
    }
}


class Model:NSObject
{
    var list = [Item]()
   
    init?(json: JSON)
    {
        if let agenda_list = json["data"]["agenda_list"].array
        {
            for agenda in agenda_list {
                
                
                
                let Start_date = agenda["Start_date"].string ?? "-"
                let End_date = agenda["End_date"].string ?? "-"
                let Heading = agenda["Heading"].string ?? "-"
                let location = agenda["location"].string ?? "-"
                let agenda_id = agenda["agenda_id"].string ?? "-"
                let tagColor = agenda["type_ids"][0]["color"].string ?? "-"
                let tagName = agenda["type_ids"][0]["name"].string ?? "-----"
                
                let startTime = agenda["Start_time"].string ?? "-"
                let endTime = agenda["End_time"].string ?? "-"
                
                
                let item = Item(Start_date:Start_date,
                                End_date:End_date,
                                Heading:Heading,
                                location:location,
                                tagName:tagName,
                                tagColor:tagColor,
                                agenda_id:agenda_id,
                                startTime:startTime,
                                endTime:endTime
                                )
                list.append(item)
               
            }
        }
        
    }
    
}


class Item : NSObject {
    var Start_date :String
    var End_date : String
    var Heading : String
    var location : String
    var tagName:String
    var tagColor:String
    var agenda_id:String
    var StartDateInt:Int = 0
    var EndDateInt:Int = 0
    
    var startTime:String
    var endTime:String
    
    var startTimeInt:Int64 = 0
    var endTimeInt:Int64 = 0
    
    init(Start_date:String,
         End_date:String,
         Heading:String,
         location:String,
         tagName:String,
         tagColor:String,
         agenda_id:String,
         startTime:String,
         endTime:String
         )
    {
        self.startTime = startTime
        self.endTime = endTime
        self.Start_date = Start_date
        self.End_date = End_date
        self.Heading = Heading
        self.location = location
        self.agenda_id = agenda_id
        self.tagName = tagName
        self.tagColor = tagColor
        
        let objDateformatter = DateFormatter()
        objDateformatter.dateFormat = "yyyy-MM-dd"
        objDateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
        let date = objDateformatter.date(from: Start_date)
        let timeInterval1 = date!.timeIntervalSince1970
        self.startTimeInt = Int64(timeInterval1)
        
        
        let _objDateformatter = DateFormatter()
        _objDateformatter.dateFormat = "yyyy-MM-dd"
        _objDateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
        let E_date = _objDateformatter.date(from: End_date)
        let timeIntervalEndDate = E_date!.timeIntervalSince1970
        self.endTimeInt =  Int64(timeIntervalEndDate)
        
        super.init()
    }
 
}


