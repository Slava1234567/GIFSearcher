//
//  ViewModel.swift
//  GIFSearch
//
//  Created by Slava on 8/23/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import Foundation
import UIKit

struct ConstantUrl {
    static let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
    static let searchUrl = "http://api.giphy.com/v1/gifs/search?q=Name&api_key=dc6zaTOxFJmzC"
    static let raitingUrl = "https://i.pinimg.com/originals/9c/d2/e2/9cd2e2ae4078ddc69f69c4a6a65dc358.gif"
}

struct DetailData {
    let title: String
    let url: String
    let date: String
    let size: String
}

//struct CreateImage {
//    let image: UIImage
//    let url: String
//}

class ViewModel {
    
    var arrayPreviewUrl = [String]()
    var arrayModel = [Model]()
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
    
    func wasReting(index:Int) -> Bool {
        guard self.arrayModel.count != 0 else {return false}
        var bool:Bool?
        let model = self.arrayModel[index]
            if model.trending_datetime != "0000-00-00 00:00:00" {
                bool = true
        }
        return bool ?? false
    }
    
    func getDataForDetail(url: String) -> DetailData? {
        var detail: DetailData?
        let filterArray = self.arrayModel.filter { (model) -> Bool in
            return model.preview_url == url
        }
        if filterArray.count > 0 {
            let model = filterArray[0]
            detail = DetailData(title: model.title, url: model.original_url, date: model.trending_datetime,size: model.size)
        }
        return detail ?? nil
    }
    
    func createUIImage(complition: @escaping (UIImage,String) -> ()) {
        let tempUrls = self.getTempArrayUrls()
        self.resumeDownloadTask(urls: tempUrls, complition: { (data,url) in
            guard let image = UIImage.gifImageWithData(data) else { return }
            
            complition(image,url)
        })
    }
    
    func getSearchUrl(text:String?) -> String {
        guard text != nil else {return ""}
        var search = text
        if let newSearch = search?.components(separatedBy: " ") {
            if newSearch.count == 2 {
                search = newSearch[0] + newSearch[1]
            }
        }
        let newSearchUrl = ConstantUrl.searchUrl.replacingOccurrences(of: "Name", with: search! )
        return newSearchUrl
    }
    
    func downloadRaitingImage(complition:@escaping (Data) -> ()) {
        let downloadManager = DownLoadManager()
        downloadManager.resumeDownloadPreviewGit(ConstantUrl.raitingUrl) { (data) in
            guard data != nil else {return}
            complition(data!)
        }
    }
    
    func getRatingImageView(index: Int, frameCell: CGRect, frameView: CGRect) -> UIImageView? {
        var imageView: UIImageView?
        if self.wasReting(index: index) {
            let width = min(frameView.size.width / 12,
                            frameView.size.height / 12)
            let newFrame = CGRect(x: frameCell.origin.x + 5,
                                  y: frameCell.origin.y + 5,
                                  width: width,
                                  height: width)
            imageView = UIImageView(frame: newFrame)
           imageView?.layer.cornerRadius = width / 2
            imageView?.layer.masksToBounds = true
        }
        return imageView ?? nil
    }
    
//    func createUIImageForSearch(complition: @escaping (UIImage,String) -> ()) {
//        let tempUrls = self.getTempArrayUrls()
//      //  self.alertEnter(count: tempUrls.count)
//        self.resumeDownloadTask(urls: tempUrls, complition: { (data,url) in
//            guard let image = UIImage.gifImageWithData(data) else { return }
//
//            complition(image,url)
//        })
//    }
//    func alertEnter(vC: UICollectionViewController) {
//
//            let ac = UIAlertController(title: "It's all that was found", message: nil,
//                                       preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            ac.addAction(cancel)
//            vC.present(ac, animated: true, completion: nil)
//
//    }
//        func createUIImageForSearch() {
//            guard let tempUrls = self.viewModel?.getTempArrayUrls() else { return }
//            self.alertEnter(count: tempUrls.count)
//            self.viewModel?.resumeDownloadTask(urls: tempUrls, complition: { (data,url) in
//                guard let image = UIImage.gifImageWithData(data) else { return }
//                self.arrayImages.append(image)
//                self.urls.append(url)
//            })
//        }
}
