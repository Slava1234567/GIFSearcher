//
//  ParseJSON.swift
//  GIFSearch
//
//  Created by Viachaslau Shyla on 22.08.2018.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation

class ParseJSON {
    
    var arrayData = [[String:String]]() 
    
    private func dataFromKeyImages(dict: [String: Any]) -> [String:String] {
        var dictiary1 = [String:String]()
        
        let keys = dict.keys
        for key in keys {
            switch key {
            case "preview_gif":
                if let newDict = dict["preview_gif"] as? [String: Any] {
                    if let value = newDict["url"] as? String {
                        dictiary1["preview_url"] = value
                    }
                }
            case "original":
                if let newDict = dict["original"] as? [String:Any] {
                    if let value = newDict["url"] as? String {
                        dictiary1["original_url"] = value
                    }
                }
            default: break
            }
        }
        return dictiary1
    }
    
    
    func pasreWithUrl(urlName: String,complition: @escaping ([[String:String]]) -> ()) {
        
        let url = URL(string: urlName)
        guard (url != nil) else { return }
        
        DispatchQueue.global(qos: .default).async {
            let data = NSData(contentsOf: url!)
            guard data != nil else { return }
            
            guard let dictJson = try! JSONSerialization.jsonObject(with: data! as Data , options: .allowFragments) as? Dictionary<String,Any> else {return}
            
            
            guard let array = dictJson["data"] as? [[String:Any]] else {return}
            
            var tempArrayData = [[String:String]]()
            for dict in array {
                
                
                var dictionaryData = [String:String]()
                let keys = dict.keys
                for key in keys {
                    switch key {
                    case "rating" :
                        guard let value = dict["rating"] as? String else { return }
                        dictionaryData["rating"] = value
                    case "import_datetime" :
                        guard let value = dict["import_datetime"] as? String else { return }
                        dictionaryData["import_datetime"] = value
                    case "trending_datetime" :
                        guard let value = dict["trending_datetime"] as? String else { return }
                        dictionaryData["trending_datetime"] = value
                    case "title" :
                        guard let value = dict["title"] as? String else { return }
                        dictionaryData["title"] = value
                    case "images" :
                        guard let dictionary = dict["images"] as? [String: Any] else { return }
                        dictionaryData.merge(dict: self.dataFromKeyImages(dict: dictionary))
                        
                    default: break
                    }
                }
                tempArrayData.append(dictionaryData)
            }
            DispatchQueue.main.async {
                self.arrayData = tempArrayData
                complition(self.arrayData)
            }
        }
    }
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
