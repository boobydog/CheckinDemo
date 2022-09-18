//
//  CheckinListView.swift
//  Checkin
//
//  Created by j-sys on 2022/07/09.
//

import SwiftUI
import UIKit
import CoreData

struct CheckinListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest  var items: FetchedResults<Checkin>
    
//    @ObservedObject var checkIn = CheckinModel()
    @State var name = ""
    @State var address = ""
    @State var phone_number = ""
    @State var selected = 0
    @State var birthDate = Date()
    
//    日付のフォーマット
    var dateFormatter = DateFormatter()
    var dateTimeFormatter = DateFormatter()

//    予約番号からBooking情報の取得
    init() {
        //    日付のフォーマット
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        dateTimeFormatter.locale = Locale(identifier: "ja_JP")
        dateTimeFormatter.dateStyle = .medium
        dateTimeFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        self._items = FetchRequest(
                        entity: Checkin.entity(),
                        sortDescriptors: [NSSortDescriptor(keyPath: \Checkin.booking_id, ascending: true)],
                        predicate:nil,
                        animation: .default
                    )
        
    }
    var body: some View {
        VStack {
            Text("チェックイン一覧")
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
                                    Text("\(dateTimeFormatter.string(from: item.insert_at!))")
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .padding()
                                    
                                    
                                }
//                                .accentColor(Color.clear)
                                .foregroundColor(Color.gray)
                                .background(Color.primary)
                                .frame(alignment: .leading)
                                
                                VStack(alignment: .leading){
                                HStack(alignment: .center){
                                    VStack(alignment: .leading) {
                                        
                                        HStack(alignment: .center){
                                        Text(LocalizedStringKey("Country of residence"))
                                            .font(.title3)
                                            .frame(width:80,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
                                       
                                        Text(item.residence_country ?? "Unknown")
                                            .font(.title3)
                                        Spacer()
                                    }
                                    
                                    
                                    
//                                    if item.tel  != "" {
                                        HStack(alignment: .center){
                                            Text(LocalizedStringKey("Phone number"))
                                                .font(.title3)
                                                .frame(width:80,alignment: .leading)
                                            Text(":")
                                                .font(.title3)
                                           
                                            Text(item.idd_code ?? "Unknown")
                                                .font(.title3)
                                            Text(item.tel ?? "Unknown")
                                                .font(.title3)
                                            Spacer()
                                        }
                                        
//                                    }
                                        
                                    
                            }
                                
                        VStack(alignment: .leading) {
//                            if item.nationality != "" {
                                HStack(alignment: .center){
                                    Text(LocalizedStringKey("Nationality"))
                                        .font(.title3)
                                        .frame(width:50,alignment: .leading)
                                    Text(":")
                                        .font(.title3)
                                    Text(item.nationality ?? "Unknown")
                                        .font(.title3)
                                    Spacer()
                                    
                                }
                                
//                            }
                            
//                            if item.email != "" {
                                HStack(alignment: .center){
                                    Text(LocalizedStringKey("Email"))
                                        .font(.title3)
                                        .frame(width:50,alignment: .leading)
                                    Text(":")
                                        .font(.title3)
                                    Text(item.email ?? "Unknown")
                                        .font(.title3)
                                    Spacer()
                                    
                                }
                                
//                            }
                            
                        }
                                    
                                }
                                    
                                    
                                    HStack(alignment: .center){
                                        Text(LocalizedStringKey("Address"))
                                            .font(.title3)
                                            .frame(width:80,alignment: .leading)
                                        Text(":")
                                            .font(.title3)
                                        Text(item.address ?? "Unknown")
                                            .font(.title3)
                                        Spacer()
                                        
                                    }
                                    
                                    
                                }.padding()
                                
                                VStack(alignment: .leading) {

                                        HStack(alignment: .center){

                                            Spacer()
                                            if  (item.residence_country != "日本") {
                                        Image(uiImage:  UIImage(data: item.identification ?? Data.init()) ?? UIImage())
                                                    .resizable()
                                                    .frame(width: 400, height:350)
                                            }else{
                                                Image(uiImage: UIImage(named: "image_logo")!)
                                                    .resizable()
                                                    .frame(width: 400, height:350)
                                            }
                                            
                                            Spacer()
                                        }.padding()
                                   

                                    
                                }
                                
                            }
                            .border( Color.primary , width: 3)
                                                                            .cornerRadius(5)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}


struct CheckinListView_Previews: PreviewProvider {
    static var previews: some View {
        CheckinListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}
