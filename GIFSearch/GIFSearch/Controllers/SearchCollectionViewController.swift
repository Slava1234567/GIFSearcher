//
//  SearchCollectionViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/28/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//


import UIKit

class SearchCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var viewModel: ViewModel?
    var searchName: String?
    var urls = [String]()
    var index = 0
    
    var ratingImage: UIImage? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    var previewUrls = [String]() {
        didSet {
            self.index = self.previewUrls.count
            self.viewModel?.createUIImage(complition: { (image, url) in
                self.arrayImages.append(image)
                self.urls.append(url)
            })
        }
    }
    var arrayImages = [UIImage]() {
        didSet {
            self.collectionView?.backgroundColor = UIColor.black
            self.collectionView?.reloadData()
        }
    }
    
    func alertEnter() {
        if self.arrayImages.count == 0 {
            let ac = UIAlertController(title: "It's all that was found", message: nil,
                                       preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancel)
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ViewModel()
        self.viewModel?.downloadRaitingImage(complition: { (data) in
            self.ratingImage = UIImage.gifImageWithData(data)
        })
        self.viewModel?.getDataOfModel(url: self.searchName!, offset: index, complition: {[weak self] (urls) in
            self?.previewUrls = urls
            self?.collectionView?.reloadData()
        })
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickBackButton))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
    }
    
    @objc func clickBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.previewUrls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifire1", for: indexPath) as? SearchCollectionViewCell
        
        if arrayImages.count > indexPath.row {
            cell?.imageView.image = self.arrayImages[indexPath.row]
            if let imageView = self.viewModel?.getRatingImageView(index: indexPath.row, frameCell: (cell?.imageView.bounds)!, frameView: self.view.frame) {
                guard self.ratingImage != nil else {return cell!}
                imageView.image = self.ratingImage
                cell?.imageView.addSubview(imageView)
            }
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
            self.viewModel?.getDataOfModel(url: self.searchName!, offset: self.index, complition: {[weak self] (newPreviewUrls) in
                self?.previewUrls = newPreviewUrls
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widht = self.view.frame.size.width / 2 - 7.5
        let hight = self.view.frame.size.height / 5
        
        return CGSize(width: widht, height: CGFloat(hight))
    }
}


