//
//  FullScreenVideo.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 12/12/20.
//
import Foundation
import UIKit
import AVFoundation
class FullScreenVideo: UIViewController {
    var videoURL: String?
    
    func visibleVideoHeight() -> CGFloat {
        return videoView.frame.size.height
    }
    
    var videoData:videoData!
    var index:Int16 = 0

    @IBOutlet weak var videoView: UIView!
   
    @IBAction func closeVideo(_ sender: UIButton) {
        
        if let _player_ = _player
        {
            let currentItem = AVPlayer.currentTime(_player_)
           // let duration = AVPlayer.currentTime(_player_)
            
            let predicate = NSPredicate(format: "videoid = \(index) AND videoWatched = %@","yes")
            DbManager.sharedDbManager.fetchDataFromTable("Video",
                                                         strPredicate: predicate)
            { (result) in
              if result.count > 0
              {
                
              }
              else
              {
                let seconds:Double = currentItem().seconds
                if seconds > 2.0
                  {
                    let _videoData = NSMutableDictionary()
                    let date = Date()
                    _videoData.setValue(videoData.description, forKey: "desc")
                    _videoData.setValue(videoData.sources, forKey: "sources")
                    _videoData.setValue(videoData.subtitle, forKey: "subtitle")
                    _videoData.setValue(videoData.thumb, forKey: "thumb")
                    _videoData.setValue(videoData.title, forKey: "title")
                    _videoData.setValue("yes", forKey: "videoWatched")
                    _videoData.setValue(date.format(), forKey: "date")
                    _videoData.setValue(index, forKey: "videoid")
                    DbManager.sharedDbManager.insertIntoTable("Video",
                                                              dictInsertData: _videoData)
                  }
              }
            }
            
        }
        self.dismiss(animated: false)
    }
    var _player:AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        if let videoURL_ = videoURL
        {
            let videoURL = URL(string: videoURL_)
            let player = AVPlayer(url: videoURL!)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds
            self.view.layer.addSublayer(playerLayer)
            player.play()
            
            _player = player
            
        }
       
    }
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
   
    

}
extension Date {
    func format(format:String = "dd-MM-yyyy hh-mm-ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
