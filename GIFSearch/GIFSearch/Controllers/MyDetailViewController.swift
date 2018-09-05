//
//  MyDetailViewController.swift
//  GIFSearch
//
//  Created by Slava on 9/3/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//

import UIKit

class MyDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    
    var image: UIImage?
    var path : String?
    var delClouse: ((String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
        
        
        if let imageN = self.image {
            self.imageView.image = imageN
        }
        
       
        
        let delete = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteAction))
        self.navigationItem.setRightBarButton(delete, animated: true)

       
    }

    
    @objc func deleteAction() {
        
        let fileManager = MyFileManager()
        
        guard self.path != nil else {return}
        fileManager.deletePath(self.path!)
        self.delClouse?(self.path!)
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
   
}
