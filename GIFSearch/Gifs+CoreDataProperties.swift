//
//  Gifs+CoreDataProperties.swift
//  GIFSearch
//
//  Created by Slava on 8/30/18.
//  Copyright © 2018 Viachaslau Shyla. All rights reserved.
//
//

import Foundation
import CoreData


extension Gifs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gifs> {
        return NSFetchRequest<Gifs>(entityName: "Gifs")
    }

    @NSManaged public var ulr: String?
    @NSManaged public var tag: Int32

}
