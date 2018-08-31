//
//  ViewModel.swift
//  GIFSearch
//
//  Created by Slava on 8/23/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation

struct DetailData {
    let title: String
    let url: String
    let date: String
}

class ViewModel {
    
    var arrayPreviewUrl = [String]()
    var arrayModel = [Model]()
    
    var urlName1: String = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
    var index : Int?
    
    func getDataOfModel (url: String,offset: Int, complition: @escaping ([String]) -> ()) {
        let urlName = url + "&offset=" + "\(offset)"
        let pasre = ParseJSON()
        index = self.arrayPreviewUrl.count
        pasre.pasreWithUrl(urlName: urlName) { [weak self] (arrayData) in
            for dict in arrayData {
                let model = Model(dictinary: dict)
                let previewUrl = model.preview_url
                self?.arrayPreviewUrl.append(previewUrl)
                self?.arrayModel.append(model)
            }
            complition((self?.arrayPreviewUrl)!)
        }
    }
    
    func getTempArrayUrls() -> ArraySlice<String>{
        let tempArray = self.arrayPreviewUrl[((index ?? 0)..<self.arrayPreviewUrl.count)]
        return tempArray
    }
    
    func resumeDownloadTask(urls:ArraySlice<String>, complition: @escaping (Data,String) -> ()) {
        for url in urls {
            let downloadTask = DownLoadManager()
            downloadTask.resumeDownloadPreviewGit(url) { (data) in
                complition(data!,url)
            }
        }
    }
    
    //    func getModel(urlName: String,complition: @escaping ([Model]) -> ()) {
    //
    //        let pasre = ParseJSON()
    //        pasre.pasreWithUrl(urlName: urlName) { (arrayData) in
    //            var tmpModel = [Model]()
    //            for dict in arrayData {
    //                let model = Model(dictinary: dict)
    //                tmpModel.append(model)
    //            }
    //            complition((tmpModel))
    //        }
    //    }
    
    func getDataForDetail(url: String) -> DetailData? {
        var detail: DetailData?
        let filterArray = self.arrayModel.filter { (model) -> Bool in
            return model.preview_url == url
        }
        if filterArray.count > 0 {
            let model = filterArray[0]
            detail = DetailData(title: model.title, url: model.original_url, date: model.trending_datetime)
        }
        return detail ?? nil
    }
    
    func getDataForSearch(urlName: String?,offSet: Int ,complition: @escaping ([String]) -> ()) {
        self.getDataOfModel(url: urlName!, offset: offSet) { (urls) in
            let filterModel = self.arrayModel.filter({ (model) -> Bool in
                return model.rating == "y" || model.rating == "g" || model.rating == "pg"
            })
            self.arrayModel = filterModel
        }
    }
}
