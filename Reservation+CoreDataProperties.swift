//
//  Booking+CoreDataProperties.swift
//  Checkin
//
//  Created by j-sys on 2022/06/18.
//
//

import Foundation
import CoreData


extension Reservation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reservation> {
        return NSFetchRequest<Reservation>(entityName: "Reservation")
    }

//    @NSManaged public var id: UUID?
//    @NSManaged public var booking_id: String?
//    @NSManaged public var name: String?
//    @NSManaged public var checkin_at: Date?
//    @NSManaged public var checkout_at: Date?
//    @NSManaged public var room_type: String?
//    @NSManaged public var checkin_flag: Bool
//    @NSManaged public var num_of_people: Int64
//    @NSManaged public var num_of_rooms: Int64

    
    @NSManaged public var id: UUID?
    @NSManaged public var booking_id: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var tel: String?
    @NSManaged public var address: String?
    @NSManaged public var checkin_at: Date?
    @NSManaged public var checkout_at: Date?
    @NSManaged public var room_type: String?
    @NSManaged public var key_code: String?
    @NSManaged public var amount: String?
    @NSManaged public var checkin_flag: Bool
    @NSManaged public var paid_flag: Bool
    @NSManaged public var num_of_people: Int64
    @NSManaged public var num_of_rooms: Int64
}

extension Reservation : Identifiable {

}
