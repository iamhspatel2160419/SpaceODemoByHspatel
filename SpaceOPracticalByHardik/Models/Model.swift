import Foundation
import SwiftyJSON

class FilterModel: NSObject {
    var list = [videoData]()
    
    init(items:[videoData])
    {
        self.list = items
    }
}


class Model:NSObject
{
    var list = [videoData]()
    var baseUrl = ""
    
    init?(json: JSON)
    {
        
        if let categories = json["categories"].array
        {
          for category in categories {
            
            self.baseUrl = category["baseurl"].string ?? ""
            Helper.sharedHelper.imageUrl = category["baseurl"].string ?? ""
            
              if let videos = category["videos"].array
              {
                  for video in videos {
                    let description = video["description"].string ?? "-"
                    
                    var videoURl = ""
                    if let sources = video["sources"].array
                    {
                        for source in sources {
                            if let description = source.string ?? ""
                           {
                               videoURl = description
                           }
                       }
                    }
                    let subtitle = video["subtitle"].string ?? "-"
                    let thumb = video["thumb"].string ?? "-"
                    let title = video["title"].string ?? "-"
                    let Object = videoData(description: description,
                                           sources: videoURl,
                                           subtitle: subtitle,
                                           thumb: thumb,
                                           title: title, videoSource: videoURl)
                    list.append(Object)
                  }
              }
          }
        }
    }
}


struct videoData {
    var description:String
    var sources:String
    var subtitle:String
    var thumb:String
    var title:String
    var videoSource:String
}
