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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail Gif"
        
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickBackButton))
        let saveButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickSaveButton))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        self.navigationItem.setRightBarButton(saveButton, animated: true)
        
        
        self.titleImage.text = self.detailData?.title
        self.date.text = self.detailData?.date
        self.imageView.backgroundColor = UIColor.gray
        self.activityIndicator.startAnimating()
        
        guard self.detailData?.url != nil else {return}
        
        let downloadManager = DownLoadManager()
        downloadManager.resumeDownloadPreviewGit((self.detailData?.url)!) { (data) in
            let image = UIImage.gifImageWithData(data!)
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        }
    }
    
    @objc func clickSaveButton() {
        
        guard self.imageView.image != nil else {return}
        let imageData = UIImagePNGRepresentation(self.imageView.image!)
        let title = self.detailData?.title
        let file = SFileManager()
        let path = file.saveData(data: imageData!, title: title!)
        
        let saveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaveCollectionViewController") as? SaveCollectionViewController
        saveVC?.path = path
        
        self.navigationController?.pushViewController(saveVC!, animated: true)
    }
    
    @objc func clickBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
