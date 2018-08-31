//
//  SearchCollectionViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/28/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UICollectionViewController {
    
    var viewModel: ViewModel?
    var searchName: String?
    var urls = [String]()
    var index = 0
    
    var previewUrls = [String]() {
        didSet {
            self.index = self.previewUrls.count
            self.createUIImage()
        }
    }
    var arrayImages = [UIImage]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    func createUIImage() {
        guard let tempUrls = self.viewModel?.getTempArrayUrls() else { return }
        self.viewModel?.resumeDownloadTask(urls: tempUrls, complition: { (data,url) in
            guard let image = UIImage.gifImageWithData(data) else { return }
            self.arrayImages.append(image)
            self.urls.append(url)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ViewModel()
        self.viewModel?.getDataOfModel(url: self.searchName!, offset: index, complition: { (urls) in
            self.previewUrls = urls
            self.collectionView?.reloadData()
        })
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickBackButton))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        self.collectionView?.backgroundColor = UIColor.black
    }
    
    @objc func clickBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return  self.previewUrls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifire1", for: indexPath) as? SearchCollectionViewCell
        
        if arrayImages.count > indexPath.row {
            cell?.imageView.image = self.arrayImages[indexPath.row]
            cell?.activityIndicator.stopAnimating()
            cell?.activityIndicator.hidesWhenStopped = true
        } else {
            cell?.backgroundColor = UIColor.customColor()
            cell?.activityIndicator.startAnimating()
        }
        return cell!
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detailVC?.detailData = self.viewModel?.getDataForDetail(url: self.urls[indexPath.row])
        
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.index - 1 {
            self.viewModel?.getDataOfModel(url: self.searchName!, offset: self.index, complition: { (newPreviewUrls) in
                self.previewUrls = newPreviewUrls
            })
        }
    }
}
