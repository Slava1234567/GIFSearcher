//
//  SFileManager.swift
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation
import UIKit


class SFileManager {
    
    func saveData(data: Data, title: String) -> String {
        
        let fileManager = FileManager.default
        let last =  "Gif + \(title)"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] + last
        
        if !(fileManager .fileExists(atPath: path)) {
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
        }
        
        print("PATH ___ \(path)")
        return path
    }
    
    func deletePath(path:String) {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) {
           try? fileManager.removeItem(atPath: path)
        }
        
    }
}
