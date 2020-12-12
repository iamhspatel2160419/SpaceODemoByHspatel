//
//  ViewController.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model: Model? = nil
    
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Videos"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        var cellNib = UINib(nibName:shotTableViewCellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: shotTableViewCellIdentifier)
        cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        API.loadData{ [weak self] Model in
            if let model = Model
            {
                self?.model = model
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let m = model
        {
            return m.list.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let m = model
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: shotTableViewCellIdentifier, for: indexPath) as! ShotTableViewCell
            
            let videoURL =  m.baseUrl + m.list[indexPath.row].videoSource
            let imageURL =   m.baseUrl + m.list[indexPath.row].thumb
            cell.configureCell(imageUrl: imageURL,
                               description: m.list[indexPath.row].description,
                               videoUrl: videoURL)
            cell.btnLikeDislike.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell.contentView.tag = indexPath.row
            cell.contentView.isUserInteractionEnabled = true
            cell.contentView.addGestureRecognizer(tapGestureRecognizer)
            
            if checkButtonLikedOrNot(index:indexPath.row) == true
            {
                cell.imgLikeDislike.image = UIImage(named: "like")
                cell.btnLikeDislike.isEnabled = false
            }
            else
            {
                cell.imgLikeDislike.image = UIImage(named: "dislike")
                cell.btnLikeDislike.isEnabled = true
            }
            cell.btnLikeDislike.tag = indexPath.row
            cell.userIcon.sd_setImage(with: URL(string: imageURL))
            
            cell.lblVideoTitle.text = m.list[indexPath.row].title
            return cell
        }
        return UITableViewCell()
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view  as! UIView
        let index = tappedImage.tag
        if let m = model
        {
            if let VideoVC = self.storyboard?.instantiateViewController(identifier: "FullScreenVideo") as? FullScreenVideo
            {
                VideoVC.videoData = m.list[index]
                VideoVC.index = Int16(index)
                VideoVC.videoURL =   m.baseUrl + m.list[index].videoSource
                self.navigationController?.present(VideoVC, animated: false)
            }
        }
    }
    @objc func pressButton(_ button: UIButton)
    {
        if let m = model
        {
            let index = button.tag
            let predicate = NSPredicate(format: "videoid = \(index)")
            DbManager.sharedDbManager.fetchDataFromTable("Video",
                                                         strPredicate: predicate)
            { (result) in
              if result.count > 0
              {
                
              }
              else
              {
                
                let _videoData = NSMutableDictionary()
                let date = Date()
                let videoData = m.list[index]
                _videoData.setValue(videoData.description, forKey: "desc")
                _videoData.setValue(videoData.sources, forKey: "sources")
                _videoData.setValue(videoData.subtitle, forKey: "subtitle")
                _videoData.setValue(videoData.thumb, forKey: "thumb")
                _videoData.setValue(videoData.title, forKey: "title")
                _videoData.setValue(date.format(), forKey: "date")
                _videoData.setValue("yes_", forKey: "like")
                _videoData.setValue(index, forKey: "videoid")
                DbManager.sharedDbManager.insertIntoTable("Video",
                                                          dictInsertData: _videoData)
                tableView.reloadData()
              }
            }
        }
    }
    
    func checkButtonLikedOrNot(index:Int)->Bool
    {
        var isLike = false
        let predicate = NSPredicate(format: "videoid = \(index)")
        DbManager.sharedDbManager.fetchDataFromTable("Video",
                                                     strPredicate: predicate)
        { (result) in
          if result.count > 0
          {
             let obj = result[0] as! Video
             if let likeValue = obj.like
             {
                if !likeValue.isEmpty && likeValue == "yes_"
                {
                    isLike = true
                }
             }
          }
        }
        return isLike
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
    
}

