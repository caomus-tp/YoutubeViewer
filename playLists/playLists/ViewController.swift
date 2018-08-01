//
//  ViewController.swift
//  playLists
//
//  Created by TANET PORNSIRIRAT on 23/7/2561 BE.
//  Copyright © 2561 caomus. All rights reserved.
//

import UIKit
import YouTubePlayer

class PlaylistsController: UITableViewController {
    
    @IBOutlet var tableViewPlaylists: UITableView!
    
    var tableData = PlayLists()
    var tabelIsOpened = IsExplaneind()
    var imageThumbnail:UIImage!
    var titleName:String!
    var linkVideo:String!
    
    var currentTime:Float!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let videoPlayerController = segue.destination as! VideoPlayerCV
        videoPlayerController.commonInit(pathTitle: self.titleName, pathThumb: self.imageThumbnail, pathLink: self.linkVideo)
        videoPlayerController.delegate = self as? Delegate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        onLoadData()
        onLoadAPI("https://demo0937961.mockable.io/playlists")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.playlists.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabelIsOpened.isOpen[section] == true {
            return tableData.playlists[section].list_items.count + 1
        }
        else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell()}
            cell.textLabel?.text = tableData.playlists[indexPath.section].list_title
            return cell
        }
        else {
            let dataIndex = indexPath.row - 1
            let cell = Bundle.main.loadNibNamed("ThumbnailViewCell", owner: self, options: nil)?.first as! ThumbnailViewCell
            DispatchQueue.main.async {
                let url = URL(string: self.tableData.playlists[indexPath.section].list_items[dataIndex].thumb)
                let data = try? Data(contentsOf: url!)
                self.imageThumbnail = UIImage(data: data!)
                cell.imgThumbnail.image = self.imageThumbnail
            }
            cell.txtTitle.text = tableData.playlists[indexPath.section].list_items[dataIndex].title
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            if tabelIsOpened.isOpen[indexPath.section] == true {
                tabelIsOpened.isOpen[indexPath.section] = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                tabelIsOpened.isOpen[indexPath.section] = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        else {
            let dataIndex = indexPath.row - 1
//            self.imageThumbnail = tableData.playlists[indexPath.section].list_items[dataIndex].thumb
            self.titleName = tableData.playlists[indexPath.section].list_items[dataIndex].title
            self.linkVideo = tableData.playlists[indexPath.section].list_items[dataIndex].link
            performSegue(withIdentifier: "segue", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row > 0) ? 80 : 40
    }

    func onLoadData() {
        tableData = PlayLists(playlists: [
            PlayLists.ListDetail(list_title: "My Playlist", list_items: [
                PlayLists.VideoInfo(title: "Maroon 5 - Girls Like You ft. Cardi B", link: "https://www.youtube.com/watch?v=aJOTlE1K90k", thumb: "https://i.ytimg.com/vi/aJOTlE1K90k/hqdefault.jpg"),
                PlayLists.VideoInfo(title: "Charlie Puth - Attention [Official Video]", link: "https://www.youtube.com/watch?v=nfs8NYg7yQM", thumb: "https://i.ytimg.com/vi/nfs8NYg7yQM/hqdefault.jpg"),
                PlayLists.VideoInfo(title: "Charlie Puth - We Don't Talk Anymore (feat. Selena Gomez) [Official Video]", link: "https://www.youtube.com/watch?v=3AtDnEC4zak", thumb: "https://i.ytimg.com/vi/3AtDnEC4zak/hqdefault.jpg")]),
            PlayLists.ListDetail(list_title: "My Playlist", list_items: [
                PlayLists.VideoInfo(title: "Maroon 5 - Girls Like You ft. Cardi B", link: "https://www.youtube.com/watch?v=aJOTlE1K90k", thumb: "https://i.ytimg.com/vi/aJOTlE1K90k/hqdefault.jpg"),
                PlayLists.VideoInfo(title: "Charlie Puth - Attention [Official Video]", link: "https://www.youtube.com/watch?v=nfs8NYg7yQM", thumb: "https://i.ytimg.com/vi/nfs8NYg7yQM/hqdefault.jpg"),
                PlayLists.VideoInfo(title: "Charlie Puth - We Don't Talk Anymore (feat. Selena Gomez) [Official Video]", link: "https://www.youtube.com/watch?v=3AtDnEC4zak", thumb: "https://i.ytimg.com/vi/3AtDnEC4zak/hqdefault.jpg")])
            ])
        tabelIsOpened = IsExplaneind(isOpen: [false, false])
//        currentTime = CurrentTime(currentTiem: [0.0f, 0.0f, ])
    }
    
    func onLoadAPI(_ url:String) {
        guard let url = URL(string: url) else { print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        // set up seccion
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // request api
        let task = session.dataTask(with: urlRequest) { (data, responds, err) in
            guard err == nil else {
                print("error calling GET on ", url)
                print(err!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let jsonString = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                self.tableData = try JSONDecoder().decode(PlayLists.self, from: data!)
                DispatchQueue.main.async {
//                     self.tabelIsOpened = 
//                    for index in 0...self.tableData.playlists.count {
//                        self.tabelIsOpened.isOpen[index] = false
//                    }
                    self.tableViewPlaylists.reloadData()
                }
                
               
                print("The jsonString is: " + jsonString.description)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func callBackMainList(with _currentTaime:Float) {
        print("callback delegate \(_currentTaime)")
        self.currentTime = _currentTaime
    }
    
}

