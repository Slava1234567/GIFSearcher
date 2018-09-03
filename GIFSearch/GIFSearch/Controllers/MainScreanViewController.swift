//
//  MainScreanViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/23/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import UIKit

class MainScreanViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UISearchBarDelegate,UICollectionViewDelegateFlowLayout {
    
   // let trandigUrl = "http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC"
   // let searchUrl = "http://api.giphy.com/v1/gifs/search?q=Name&api_key=dc6zaTOxFJmzC"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var buttonAll: UIButton!
    
    var viewModel: ViewModel?
    var index = 0
    var urls = [String]()
    
    var arrayPreviewUrl = [String]() {
        didSet {
            index = self.arrayPreviewUrl.count
            self.createUIImage()
        }
    }
    var arrayImages = [UIImage]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func AllButton(_ sender: Any) {
        let saveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SaveCollectionViewController") as? SaveCollectionViewController
        let nvc = UINavigationController(rootViewController: saveVC!)
        self.present(nvc, animated: true, completion: nil)
    }
    
    func createUIImage() {
        guard let tempUrls = self.viewModel?.getTempArrayUrls() else { return }
        self.viewModel?.resumeDownloadTask(urls: tempUrls, complition: { (data,url) in
            guard let image = UIImage.gifImageWithData(data) else { return }
            self.arrayImages.append(image)
            self.urls.append(url)
        })
    }
    
    override func viewWillLayoutSubviews() {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let widht = self.view.frame.size.width / 2 - 7.5
            let hight = max(self.view.frame.size.width / 5, self.view.frame.size.height / 5)
            return CGSize(width: widht, height: hight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.logoView.image = UIImage(named: "1")
        self.logoView.contentMode = .scaleToFill
        
        self.buttonAll.layer.cornerRadius = 5
        self.buttonAll.layer.masksToBounds = true
        self.buttonAll.layer.borderColor = UIColor.white.cgColor
        self.buttonAll.layer.borderWidth = 1
       // self.buttonAll.bounds.size.width = self.view.frame.size.width / 5
        
        self.view.backgroundColor = UIColor.black
        self.collectionView.backgroundColor = UIColor.black
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.searchBar.delegate = self
        
        self.viewModel = ViewModel()
        self.viewModel?.getDataOfModel(url: ConstantUrl.trandigUrl, offset: index, complition: { (urls) in
            self.arrayPreviewUrl = urls
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayPreviewUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifire = "identifier"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifire, for: indexPath) as? MainCollectionViewCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.index - 20 {
            self.viewModel?.getDataOfModel(url: ConstantUrl.trandigUrl, offset: self.index, complition: { (newPreviewUrls) in
                self.arrayPreviewUrl = newPreviewUrls
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        guard self.arrayImages.count > 0 else {return}
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        let nvc = UINavigationController(rootViewController: detailVC!)
        detailVC?.detailData = self.viewModel?.getDataForDetail(url: self.urls[indexPath.row])
        
        self.present(nvc, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {return}
        var search = searchBar.text
        if let newSearch = search?.components(separatedBy: " ") {
            if newSearch.count == 2 {
            search = newSearch[0] + newSearch[1]
            }
        }
        let newSearchUrl = ConstantUrl.searchUrl.replacingOccurrences(of: "Name", with: search! )
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCollectionViewController") as? SearchCollectionViewController
        let nvc = UINavigationController(rootViewController: searchVC!)
        
        searchVC?.title = searchBar.text
        searchVC?.searchName = newSearchUrl
        self.present(nvc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widht = self.view.frame.size.width / 2 - 7.5
        let hight = max(self.view.frame.size.width / 5, self.view.frame.size.height / 5)   //self.view.frame.size.height / 5 
        
        return CGSize(width: widht, height: CGFloat(hight))
    }
}




extension UIColor {
    class func customColor() -> UIColor {
        
        let one = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        let two = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let three = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        let four = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        let five = #colorLiteral(red: 0.8932850506, green: 1, blue: 0.2616665644, alpha: 1)
        
        let arrayCollor = [one,two,three,four,five]
        let value = Int(arc4random_uniform(4))
        
        return arrayCollor[value]
    }
}
