//
//  VideoPlayerCV.swift
//  playLists
//
//  Created by TANET PORNSIRIRAT on 24/7/2561 BE.
//  Copyright © 2561 caomus. All rights reserved.
//

import UIKit
import AVKit
import YouTubePlayer

protocol Delegate {
    func callBackMainList(with currentTime: Float)
}

class VideoPlayerCV: UIViewController, YouTubePlayerDelegate {

    var delegate: Delegate?
    
    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnCurrent: UIButton!
    
    var pathThumb:UIImage!
    var urlVideo: String!
    var pathTitle:String!
    var currentTime:Float!
    var seekTime:Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.thumbnail.image = self.pathThumb
        let urlLink = URL(string: self.urlVideo)
        self.videoPlayer.delegate = self
        self.videoPlayer.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls" : "0" as AnyObject,
            "autohide" : "1" as AnyObject,
            "showinfo" : "0" as AnyObject,
            "autoplay" : "0" as AnyObject,
            "fs" : "0" as AnyObject,
            "rel" : "0" as AnyObject,
            "loop" : "0" as AnyObject,
            "enablejsapi" : "1" as AnyObject,
            "modestbranding" : "1" as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
        
        self.videoPlayer.loadVideoURL(urlLink!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonInit(pathTitle:String, pathThumb:UIImage, pathLink:String) {
        self.pathThumb = pathThumb
        self.pathTitle = pathTitle
        self.urlVideo = pathLink
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        self.videoPlayer.backgroundColor = UIColor(white: 1, alpha: 1.0)
//        videoPlayer.play()
        self.videoPlayer.backgroundColor = UIColor.black.withAlphaComponent(1)
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("Player state changed!")
    }
    
    func playerQualityChanged(videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("Player quality changed!")
    }
    
    func passDataBackwards() {        
        delegate?.callBackMainList(with: self.currentTime)
    }
    
    @IBAction func play(_ sender: Any) {
        if self.videoPlayer.ready {
            if self.videoPlayer.playerState != YouTubePlayerState.Playing {
                self.videoPlayer.play()
//                print("Player Ready!")
//                let urlLink = URL(string: self.urlVideo)
//                print(urlLink!.absoluteURL)
//                let video = AVPlayer(url: urlLink!)
//                let videoPlayer = AVPlayerViewController()
//                videoPlayer.player = video
//
//                present(videoPlayer, animated: true, completion:
//                {
//                    video.play()
//                })
                self.btnPlay.setTitle("Pasue", for: .normal)
            } else {
                self.videoPlayer.pause()
                self.btnPlay.setTitle("Play", for: .normal)
            }
        }
    }
    @IBAction func onGetDurationTime(_ sender: Any) {
        let title = String(format: "Duration %@", self.videoPlayer.getDuration() ?? "0")
        self.btnDuration.setTitle(title, for: .normal)
    }
    
    @IBAction func onGetCurrentTime(_ sender: Any) {
        let title = String(format: "Current Time %@", self.videoPlayer.getCurrentTime() ?? "0")
        self.btnCurrent.setTitle(title, for: .normal)
    }

    @IBAction func onCloseVideo(_ sender: Any) {
        //
        self.currentTime = 30.0
        print("back\(self.currentTime)")
        passDataBackwards()
    }
    
}
