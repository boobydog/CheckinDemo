//
//  Checkin+CoreDataProperties.swift
//  Checkin
//
//  Created by j-sys on 2022/06/18.
//
//

import Foundation
import CoreData


extension Checkin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Checkin> {
        return NSFetchRequest<Checkin>(entityName: "Checkin")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var residence_country: String?
    @NSManaged public var name: String?
    @NSManaged public var booking_id: String?
    @NSManaged public var email: String?
    @NSManaged public var tel: String?
    @NSManaged public var nationality: String?
    @NSManaged public var identification: Data?
    @NSManaged public var address: String?
    @NSManaged public var idd_code: String?
    @NSManaged public var insert_at: Date?
    

}

extension Checkin : Identifiable {

}
