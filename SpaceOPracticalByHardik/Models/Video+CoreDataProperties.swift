//
//  Video+CoreDataProperties.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 12/12/20.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var desc: String?
    @NSManaged public var sources: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var thumb: String?
    @NSManaged public var title: String?
    @NSManaged public var like: String?
    @NSManaged public var videoid: Int16
    @NSManaged public var date: String?
    @NSManaged public var videoWatched: String?
    
}

extension Video : Identifiable {

}
