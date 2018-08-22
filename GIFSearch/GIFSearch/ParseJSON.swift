//
//  ParseJSON.swift
//  GIFSearch
//
//  Created by Viachaslau Shyla on 22.08.2018.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation

class ParseJSON {
    
    let urlName = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
    var dictionary = [[String:Any]]()
    
    func dataFromKeyImages(key: String, dict: [String: Any]) -> [String:Any] {
        var dictiary = [String:Any]()
        let array = dict[key]
        for dict in (array as? [[String:Any]])! {
            let arrayNext = dict["preview_gif"]
            for dict1 in (arrayNext as? [[String:Any]])! {
                let value = dict1["url"]
                dictiary["url"] = value
            }
        }
        return dictiary
    }
    
    func pasreWithUrl() {
        
        let url = URL(string: urlName)
        guard (url != nil) else { return }
        
        DispatchQueue.global(qos: .default).async {
            let data = NSData(contentsOf: url!)
            guard data != nil else { return }
            let dictJson = try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as? Dictionary<String,Any>
            guard dictJson != nil else { return }
        
            if let array = dictJson!["data"] as? [[String:Any]] {
                print(array[0])
                DispatchQueue.main.async {
                    for dict in array {
                      let keys = dict.keys
                        for key in keys {
                            switch key {
                            case "rating" : guard let value = dict["rating"] else { return }
                                                  let dicty = ["rating":value]
                                                  self.dictionary.append(dicty )
                            case "import_datetime" : guard let value = dict["import_datetime"] else { return }
                                                           let dicty = ["import_datetime":value]
                                                           self.dictionary.append(dicty )
                            case "trending_datetime" : guard let value = dict["trending_datetime"] else { return }
                                                             let dicty = ["trending_datetime":value]
                                                              self.dictionary.append(dicty )
                            case "title" : guard let value = dict["title"] else { return }
                                                 let dicty = ["title":value]
                                                 self.dictionary.append(dicty )
                            case "images" : guard let array = dict["images"] as? [[String:Any]] else {return}
                            for dic in array {
                                let arrayN = dic.keys
                                for key in arrayN {
                                    switch key {
                                    case "preview_gif": guard let array = dic["preview_gif"] else { return }
                                    for dict in array {
                                        let newDictionary = ["ulr":dict["url"]]
                                        }
                                    }
                                }
                                }
                            }
                        }
                        
                    }
                }
            
            }
        }
//        do {
//            let data = try Data(contentsOf: url!)
//        } catch {
//            print(error.localizedDescription)
//        }
        
    }
}
