//
//  Context.swift
//  Sticky Notes
//
//  Created by Omeesh Sharma on 10/07/20.
//  Copyright © 2020 Omeesh Sharma. All rights reserved.
//

import UIKit
import CoreData

class CoreContext: UIView {
    
    static let shared = CoreContext()
    var lastLocation : NSManagedObject?
    

    ///Save Location in Core Data
    func saveLocation(_ position: CGPoint,_ height: CGFloat) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext) else {return}
        
        let location = NSManagedObject(entity: entity, insertInto: managedContext)
        location.setValue(Float(position.x), forKeyPath: "x")
        location.setValue(Float(position.y), forKeyPath: "y")
        location.setValue(Float(height), forKeyPath: "height")
        
        do {
            try managedContext.save()
            self.lastLocation = location
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    ///Fetch Location from Core Data
    func fetchLocation() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            self.lastLocation = try managedContext.fetch(fetchRequest).last
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
}
