//
//  UserRepostory.swift
//  Users
//
//  Created by Sven Svetina on 08/01/2020.
//  Copyright © 2020 Sven Svetina. All rights reserved.
//

import CoreData
import UIKit

class UserStore {
      
    private let coreDataStack: CoreDataStack
    
    init() {
        self.coreDataStack = try! CoreDataStack()
    }

    func save(userModel: UserModel) -> User {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
        let context = coreDataStack.context(forType: .write)
        
        let user: User? = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        
        context.perform {
            user!.setFromModel(model: userModel)

            do {
                try context.save()
            } catch (let error) {
                print("\(error)")
            }
        }
        return user!
    }
    
    
    func queryUser(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> User {
        let context = coreDataStack.context(forType: .read)
        let request = NSFetchRequest<User>(entityName: "User")
        var user: User!
        
        if let predicate = predicate {
            request.predicate = predicate
        }
        request.sortDescriptors = sortDescriptors
        
        do {
            let result = try context.fetch(request)
            for data in result as [User] {
                user = data
                print(user!)
            }
        } catch {
            print("failed")
        }
        return user
    }
}

