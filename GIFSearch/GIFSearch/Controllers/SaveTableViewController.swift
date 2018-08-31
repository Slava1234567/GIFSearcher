//
//  SaveTableViewController.swift
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

//import UIKit
//import CoreData
//
//class SaveTableViewController: UITableViewController {
//    
//    var images = [UIImage]()
//    var context : NSManagedObjectContext!
//    var path: String?
//    var arrayGifs = [Gifs]()
//    
//    
//    func saveGifs() {
//        
//        let gifs = self.getGifts()
//        
//        let entity = NSEntityDescription.entity(forEntityName: "Gifs", in: self.context)
//        let gif = NSManagedObject(entity: entity!, insertInto: self.context) as? Gifs
//        guard path != nil else {return}
//        guard !gifs.contains(where: { (gif) -> Bool in gif.ulr == path }) else { return }
//        
//        gif?.ulr = path
//        
//        do {
//            try self.context?.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func getGifts() -> [Gifs] {
//        var gifs = [Gifs]()
//        let fetchRequest : NSFetchRequest<Gifs> = Gifs.fetchRequest()
//        do{
//            gifs = try self.context.fetch(fetchRequest)
//        } catch {
//            print(error.localizedDescription)
//        }
//        return gifs
//    }
//    
//    func getUIImage(gifs: [Gifs]) {
//        
//        for gif in gifs {
//            let path = gif.ulr
//            DispatchQueue.global(qos: .userInitiated).async {
//                guard path != nil else {return}
//                let image = UIImage(contentsOfFile: path!)
//                DispatchQueue.main.async {
//                    guard image != nil else {return}
//                    self.images.append(image!)
//                    self.tableView.reloadData()
//                    print(self.images.count)
//                    print(gifs)
//                }
//            }
//            
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        self.context = appDelegate?.persistentContainer.viewContext
//        
//        self.saveGifs()
//        let gifs = self.getGifts()
//        self.getUIImage(gifs: gifs)
//    }
//    
//    
//    // MARK: - Table view data source
//    
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.images.count
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? STableViewCell
//        
//        cell?.imageView?.image = self.images[indexPath.row]
//        cell?.backgroundColor = UIColor.black
//        
//        return cell!
//    }
//}
