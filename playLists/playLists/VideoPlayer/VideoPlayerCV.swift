//
//  VideoPlayerCV.swift
//  playLists
//
//  Created by TANET PORNSIRIRAT on 24/7/2561 BE.
//  Copyright © 2561 caomus. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerCV: UIViewController, YouTubePlayerDelegate {

    @IBOutlet weak var videoPlayer: YouTubePlayerView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var btnCurrent: UIButton!
    
    var pathThumb:String!
    var urlVideo: String!
    var pathTitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            let urlImage = URL(string: self.pathThumb)
            let data = try? Data(contentsOf: urlImage!)
            self.thumbnail.image = UIImage(data: data!)
        }
        let urlLink = URL(string: self.urlVideo)
        self.videoPlayer.delegate = self
        self.videoPlayer.playerVars = [
            "playsinline": "1" as AnyObject,
            "controls" : "0" as AnyObject,
            "autohide" : "1" as AnyObject,
            "showinfo" : "1" as AnyObject,
            "autoplay" : "0" as AnyObject,
            "fs" : "1" as AnyObject,
            "rel" : "1" as AnyObject,
            "loop" : "0" as AnyObject,
            "enablejsapi" : "1" as AnyObject,
            "modestbranding" : "0" as AnyObject] as YouTubePlayerView.YouTubePlayerParameters
        
        self.videoPlayer.loadVideoURL(urlLink!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonInit(pathTitle:String, pathThumb:String, pathLink:String) {
        self.pathThumb = pathThumb
        self.pathTitle = pathTitle
        self.urlVideo = pathLink
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print("Player Ready!")
        videoPlayer.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("Player state changed!")
    }
    
    @IBAction func play(_ sender: Any) {
        if self.videoPlayer.ready {
            if self.videoPlayer.playerState != YouTubePlayerState.Playing {
                self.videoPlayer.play()
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
    }
    
}
