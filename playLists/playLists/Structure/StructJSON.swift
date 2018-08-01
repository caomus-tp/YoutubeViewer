//
//  Struct.swift
//  playLists
//
//  Created by TANET PORNSIRIRAT on 23/7/2561 BE.
//  Copyright © 2561 caomus. All rights reserved.
//

struct playListsData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

struct PlayLists: Decodable {
    var playlists = [ListDetail]()
    
    struct ListDetail: Decodable {
        var list_title = String()
        var list_items = [VideoInfo]()
    }
    
    struct VideoInfo: Decodable {
        var title = String()
        var link = String()
        var thumb = String()
    }
}

struct IsExplaneind {
    var isOpen = [Bool]()
}

struct CurrentTime {
    var currentTiem = [Float]()
}
