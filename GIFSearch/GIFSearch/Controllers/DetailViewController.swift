//
//  DetailViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/29/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleImage: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var date: UILabel!
    var detailData : DetailData?
    
    
    func addBarButtonItem() {
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickBackButton))
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickSaveButton))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        self.navigationItem.setRightBarButton(saveButton, animated: true)
    }
    
    func setDataOutlets(datailData:DetailData?) {
        guard detailData != nil else {return}
        self.titleImage.text = datailData!.title
        self.date.text = datailData!.date
        if let size =  Int(datailData!.size) {
            let newSize = (size / 1000)
            self.size.text = String(newSize) + "kb"
        }
        self.imageView.backgroundColor = UIColor.gray
        self.activityIndicator.startAnimating()
    }
    
    func downloadImage(url: String?) {
         guard url != nil else {return}
        let downloadManager = DownLoadManager()
        downloadManager.resumeDownloadPreviewGit((self.detailData?.url)!) { (data) in
            let image = UIImage.gifImageWithData(data!)
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail Gif"
        
        self.addBarButtonItem()
        self.setDataOutlets(datailData: self.detailData)
        self.downloadImage(url: self.detailData?.url)
        
    }
    
    @objc func clickSaveButton() {
        
        guard self.imageView.image != nil else {return}
        let imageData = UIImagePNGRepresentation(self.imageView.image!)
        let title = self.detailData?.title
        let file = MyFileManager()
        let path = file.save(imageData!, title: title!)
        
        let saveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaveCollectionViewController") as? SaveCollectionViewController
        saveVC?.path = path
       
        self.navigationController?.pushViewController(saveVC!, animated: true)
    }
    
    @objc func clickBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
