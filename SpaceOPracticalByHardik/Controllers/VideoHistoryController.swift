//
//  VideoHistoryController.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 12/12/20.
//

import UIKit

class VideoHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var list = [Video]()
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watch History"
        tableview.dataSource = self
        tableview.delegate = self
        fetchData()
    }
    
    func fetchData()
    {
        let predicate = NSPredicate(format: "videoWatched = %@","yes")
        DbManager.sharedDbManager.fetchDataFromTable("Video",strPredicate: predicate)
        { (result) in
            if result.count > 0
            {
                for k in 0..<result.count
                {
                    let Video = result[k] as! Video
                    list.append(Video)
                }
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : CustomCell
        cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell")! as! CustomCell
        let obj = list[indexPath.row]
        
        if let _thumbLink = obj.thumb
        {
            let imageUrl = Helper.sharedHelper.imageUrl + _thumbLink
            cell.imageView_.sd_setImage(with: URL(string: imageUrl))
        }
        cell.lblVideoTitle.text = obj.title
        cell.selectionStyle = .none
        if let date = obj.date
        {
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeZone = NSTimeZone.local
            timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
            timeFormatter.dateFormat = "dd-MM-yyyy hh-mm-ss"
            let time1 =  timeFormatter.date(from: date)
            let time2 =  timeFormatter.date(from: self.getLocalTimeZone(dateFormat: "dd-MM-yyyy hh-mm-ss") )
            
            let secondsAgo = Int(time2!.timeIntervalSince(time1!))
            var duration = ""
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day
            
            if secondsAgo < minute  {
                if secondsAgo < 2{
                    duration = "just now"
                }else{
                    duration = "\(secondsAgo) secs ago"
                }
            } else if secondsAgo < hour {
                let min = secondsAgo/minute
                if min == 1{
                    duration = "\(min) min ago"
                }else{
                    duration = "\(min) mins ago"
                }
            } else if secondsAgo < day {
                let hr = secondsAgo/hour
                if hr == 1{
                    duration = "\(hr) hr ago"
                } else {
                    duration = "\(hr) hrs ago"
                }
            } else if secondsAgo < week {
                let day = secondsAgo/day
                if day == 1{
                    duration = "\(day) day ago"
                }else{
                    duration = "\(day) days ago"
                }
            }
            print(duration)
            cell.lblDate.text = duration
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func getLocalTimeZone(dateFormat:String)->String
    {
        let dateFormatter = DateFormatter()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        //NSTimeZone(name: "UTC") as TimeZone! //
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        let strCurrentTimezone = dateFormatter.string(from: Date())
        return strCurrentTimezone
    }
}
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
