import Foundation
import CoreData
import UIKit

protocol StorageProtocol {
    func save(phone: CellPhone)
    func fetch() -> [CellPhone]
}

final class CoreDataHandler: StorageProtocol {
    
    private var managedObjectContext: NSManagedObjectContext? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }
    
    func save(phone: CellPhone) {
        guard let context = self.managedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: CoreDataKeys.entityName, in: context) else { return }
        
        let newPhone = NSManagedObject(entity: entity, insertInto: context)
        newPhone.setValue(phone.title, forKey: CoreDataKeys.title)
        newPhone.setValue(phone.subcategory, forKey: CoreDataKeys.subcategory)
        let popularity = (phone.popularity as NSString).doubleValue
        newPhone.setValue(popularity, forKey: CoreDataKeys.popularity)
        let price = (phone.price as NSString).doubleValue
        newPhone.setValue(price, forKey: CoreDataKeys.price)
        try? context.save()
    }
    
    func fetch() -> [CellPhone] {
        guard let context = managedObjectContext else { return [] }
        var cellPhones = [CellPhone]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataKeys.entityName)
        let sortDescriptor = NSSortDescriptor(key: CoreDataKeys.popularity, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        let result = try? context.fetch(request) as? [NSManagedObject]
        if let data = result {
            for items in data {
                if let title = items.value(forKey: CoreDataKeys.title) as? String,
                    let price = items.value(forKey: CoreDataKeys.price) as? Double,
                    let subcategory = items.value(forKey: CoreDataKeys.subcategory) as? String,
                    let popularity = items.value(forKey: CoreDataKeys.popularity) as? Double {
                    let cellPhone = CellPhone(subcategory: subcategory, title: title, price: "\(price)", popularity: "\(popularity)")
                    cellPhones.append(cellPhone)
                }
            }
        }
        return cellPhones
    }
}


