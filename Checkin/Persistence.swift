//
//  Persistence.swift
//  Checkin
//
//  Created by j-sys on 2022/06/17.
//
import UIKit
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
            let newReservation = Reservation(context: viewContext)
            newReservation.id = UUID()
            newReservation.booking_id = "B\(String(format: "%06d", index + 1))"
            newReservation.name = "TEST\(index + 1)"
            newReservation.email = "test\(index + 1)@test.jp"
            newReservation.tel = "123-456-789"
            newReservation.address = "神奈川県XXXXXX2-22-222"
            newReservation.checkin_at = Date()
            newReservation.checkout_at = Date()+1
            newReservation.room_type = "和室"
            newReservation.num_of_people = 2
            newReservation.num_of_rooms = 1
            newReservation.checkin_flag = false
            newReservation.paid_flag = false
            newReservation.amount = "5000"
            newReservation.key_code = "000000"
            
        }
        
        for index in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
            let image = UIImage(systemName: "image_logo")
            let newCheckin = Checkin(context: viewContext)
            newCheckin.id = UUID()
            newCheckin.booking_id = "B\(String(format: "%06d", index + 1))"
            newCheckin.name = "TEST\(index + 1)"
            newCheckin.insert_at = Date()
            newCheckin.email = "test\(index + 1)@test.jp"
            newCheckin.tel = "08022806737"
            newCheckin.nationality =  "日本"
            newCheckin.identification =  image!.jpegData(compressionQuality: 0.8)
            newCheckin.address =  "神奈川県XXXXXX2-22-222"
            newCheckin.idd_code =  "+81"
            newCheckin.residence_country =  "日本国内在住"
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Checkin")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
