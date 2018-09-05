//
//  SaveCollectionViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import UIKit
import CoreData

class SaveCollectionViewController: UICollectionViewController {
    
    var images = [UIImage]()
    var context : NSManagedObjectContext!
    var path: String?
    var arrayGifs = [Gifs]()
    
    //MARK: - Funcs
    func saveGifs() {
        let gifs = self.getGifts()
        
        let entity = NSEntityDescription.entity(forEntityName: "Gifs", in: self.context)
        let gif = NSManagedObject(entity: entity!, insertInto: self.context) as? Gifs
        guard self.path != nil else {return}
        guard !gifs.contains(where: { (gif) -> Bool in
            gif.ulr == path
        }) else { return }
        gif?.ulr = path
        do {
            try self.context?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getGifts() -> [Gifs] {
        var gifs = [Gifs]()
        let fetchRequest : NSFetchRequest<Gifs> = Gifs.fetchRequest()
        
        do{
            gifs = try self.context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        return gifs
    }
    
    func getUIImage(gifs: [Gifs]) {
        
        for gif in gifs {
            let path = gif.ulr
            DispatchQueue.global(qos: .userInitiated).async {
                guard path != nil else {return}
                
                let image = UIImage(contentsOfFile: path!)
                DispatchQueue.main.async {
                    guard image != nil else {return}
                    self.images.append(image!)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    //MARK: - Actions
    @objc func clickBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteAllAction() {
        let gifs = self.getGifts()
        
        for gif in gifs {
            self.context.delete(gif)
        }
       try? self.context.save()
        self.images = []
        self.collectionView?.reloadData()
    }
    
    func addBarButtonItem() {
        let backButton = UIBarButtonItem(title: "< back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickBack))
        self.navigationItem.setLeftBarButton(backButton, animated: true)
        
        let deleteAll = UIBarButtonItem(title: "Delete All", style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteAllAction))
        self.navigationItem.setRightBarButton(deleteAll, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "My Gifs"
        self.collectionView?.backgroundColor = UIColor.lightGray
        self.addBarButtonItem()
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = appDelegate?.persistentContainer.viewContext
        
        self.saveGifs()
        self.arrayGifs = self.getGifts()
        self.getUIImage(gifs: self.arrayGifs)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SaveCollectionViewCell", for: indexPath) as? SaveCollectionViewCell
        cell?.imageView.image = self.images[indexPath.row]
        cell?.layer.borderColor = UIColor.customColor().cgColor
        cell?.layer.borderWidth = 2
        cell?.layer.cornerRadius = 5
        cell?.layer.masksToBounds = true
        
        return cell!
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyDetailViewController") as? MyDetailViewController
       
        vc?.image = self.images[indexPath.row]
        vc?.path = self.arrayGifs[indexPath.row].ulr
        vc?.delClouse = { [weak self] path in
            for (index,gif) in (self?.arrayGifs)!.enumerated() {
                if gif.ulr == path {
                    self?.context.delete(gif)
                    self?.images.remove(at: index)
                    self?.collectionView?.reloadData()
                }
            }
        }
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
}









