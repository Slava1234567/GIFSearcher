//
//  Model.swift
//  GIFSearch
//
//  Created by Slava on 8/23/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation

class Model {
    
    let rating: String
    let import_datetime: String
    let trending_datetime: String
    let title: String
    let preview_url: String
    let original_url: String
    
    init (dictinary: [String:String]) {
        self.rating = dictinary["rating"] ?? ""
        self.import_datetime = dictinary["import_datetime"] ?? ""
        self.trending_datetime = dictinary["trending_datetime"] ?? ""
        self.title = dictinary["title"] ?? ""
        self.preview_url = dictinary["preview_url"] ?? ""
        self.original_url = dictinary["original_url"] ?? ""
        
    }
}
