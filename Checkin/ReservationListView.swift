//
//  ReservationListView.swift
//  Checkin
//
//  Created by j-sys on 2022/07/09.
//

import SwiftUI
import CoreData

struct ReservationListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest  var items: FetchedResults<Reservation>
//    @FetchRequest  var citems: FetchedResults<Checkin>
    
//    @ObservedObject var checkIn = CheckinModel()
    @State var name = ""
    @State var address = ""
    @State var phone_number = ""
    @State var selected = 0
    @State var birthDate = Date()
    
//    日付のフォーマット
    var dateFormatter = DateFormatter()

//    予約番号からBooking情報の取得
    init() {
        //    日付のフォーマット
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self._items = FetchRequest(
                        entity: Reservation.entity(),
                        sortDescriptors: [NSSortDescriptor(keyPath: \Reservation.booking_id, ascending: true)],
                        predicate:nil,
                        animation: .default
                    )
//        self._citems = FetchRequest(
//                        entity: Checkin.entity(),
//                        sortDescriptors: [NSSortDescriptor(keyPath: \Checkin.booking_id, ascending: true)],
//                        predicate:nil,
//                        animation: .default
//                    )
        
    }
    
    
    
    var body: some View {
        VStack {
            Text("予約一覧")
            List{
                ForEach(items){item in
                    VStack(alignment: .leading) {
                        HStack(alignment: .center){
                            VStack(alignment: .leading) {
                                HStack(alignment: .center){
                                    Text(item.booking_id ?? "Unknown")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .padding()
                                    Spacer()
                                    Text(item.name ?? "Unknown")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .padding()
                                    Spacer()
                                    Text(item.checkin_flag ? "チェックイン済" : "未チェックイン")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .padding()
                                }
                                .accentColor(Color.white)
                                .foregroundColor(item.checkin_flag ? Color.white : Color.gray)
                                .background(item.checkin_flag ? Color.blue : Color.primary)
                                .frame(alignment: .leading)
                                
                                
                                HStack(alignment: .center){
                                VStack(alignment: .leading) {
                                
                                    HStack(alignment: .center){
                                        Text("部屋タイプ")
                                            .font(.title3)
                                            .frame(width:100,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
//                                            .accentColor(Color.white)
                                            //.background(Color.blue)
                                       
                                        Text(item.room_type ?? "Unknown")
                                            .font(.title3)
                                        Spacer()
                                    }
                                    HStack(alignment: .center){
                                        Text("部屋数")
                                            .font(.title3)
                                            .frame(width:100,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
                                       
                                                Text("\(item.num_of_rooms)" )
                                            .font(.title3)
                                        Spacer()
                                        
                                    }
                                    HStack(alignment: .center){
                                        Text("人数")
                                            .font(.title3)
                                            .frame(width:100,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
                                       
                                                Text("\(item.num_of_people)" )
                                            .font(.title3)
                                        Spacer()
                                        
                                    }
                                    HStack(alignment: .center){
                                        Text("金額")
                                            .font(.title3)
                                            .frame(width:100,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
                                      
                                                Text("\(item.amount!)" )
                                            .font(.title3)
                                        Spacer()
                                    }
                                }
                                  
                                    VStack(alignment: .leading) {
                                        HStack(alignment: .center){
                                            Text("IN")
                                                .font(.title3)
//                                                .fontWeight(.semibold)
                                                .frame(width:60,alignment: .leading)
                                               
                                            Text(":")
                                                .font(.title3)
                                            
                                                    Text("\(dateFormatter.string(from: item.checkin_at!))")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                               
                                            Spacer()
                                        }
                                        
                                        HStack(alignment: .center){
                                            Text("OUT")
                                                .font(.title3)
//                                                .fontWeight(.semibold)
                                                .frame(width:60,alignment: .leading)
                                                
                                            Text(":")
                                                .font(.title3)
                                                    Text("\(dateFormatter.string(from: item.checkout_at!))")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                               
                                            Spacer()
                                        }
                                        
                                        HStack(alignment: .center){
                                            Spacer()
                                                Text(item.paid_flag ? "支払済" : "未払")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                                .foregroundColor(item.paid_flag  ? Color.blue : Color.gray)
                                               
                                                
//                                                .border(item.paid_flag ? Color.blue : Color.gray , width: 3)
//                                                .cornerRadius(5)
                                                .padding(5)
                                            Spacer()
                                        }.border(item.paid_flag && item.checkin_flag ? Color.blue : Color.gray , width: 3)
//                                            .background(item.paid_flag ? Color.primary :Color.clear)
                                            .frame(width:190,alignment: .leading)
                                            .cornerRadius(5)
                                            
                                        
                                    }
                                    
                                }
                                .padding()
                            }
//                            .overlay(RoundedRectangle(cornerRadius: 10)
//                                .stroke(item.checkin_flag ? Color.blue : Color.primary, lineWidth: 3))
                            .border(item.checkin_flag ? Color.blue : Color.primary , width: 3)
                                                                            .cornerRadius(5)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}


struct ReservationListView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}
