//
//  CompleteView.swift
//  Checkin
//
//  Created by j-sys on 2022/06/26.
//

import SwiftUI
import CoreData
import UIKit

struct CompleteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var envData: EnvironmentData //正常に最初の画面に画面遷移するための処理
    @FetchRequest  var reservationItems: FetchedResults<Reservation>
    @FetchRequest  var checkinItems: FetchedResults<Checkin>
    
//    @ObservedObject var checkIn = CheckinModel()
    @State var name = ""
    @State var address = ""
    @State var phone_number = ""
    @State var selected = 0
    @State var birthDate = Date()
    @State var isNavigate = false
    
    @State var isShowHowToGetYourKeyModal:Bool = false
    @State var isShowHowToUseTheFacilityModal:Bool = true
    
    var lang: String
    var reservation_id: String
    
//    日付のフォーマット
    var dateFormatter = DateFormatter()

//    予約番号からBooking情報の取得
    init(lang: String,reservation_id: String) {
        //    日付のフォーマット
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.reservation_id = reservation_id
        self.lang = lang
        self._reservationItems = FetchRequest(
                        entity: Reservation.entity(),
                        sortDescriptors: [NSSortDescriptor(keyPath: \Reservation.booking_id, ascending: true)],
                        predicate:
                            NSPredicate(format: "booking_id ==  %@" ,"\(self.reservation_id)"),
                        animation: .default
                    )
        self._checkinItems = FetchRequest(
                        entity: Checkin.entity(),
                        sortDescriptors: [NSSortDescriptor(keyPath: \Checkin.booking_id, ascending: true)],
                        predicate:
                            NSPredicate(format: "booking_id ==  %@" ,"\(self.reservation_id)"),
                        animation: .default
                    )
        }
    
    var body: some View {
//envData:の処理を使って画面遷移するためNavivationLinkは不要
//        NavigationLink(destination: SelectLangView(),isActive: $isNavigate) {
//            EmptyView()
//        }
        
        
        Form{
            VStack(alignment: .center){
//                                HelpView(lang:lang)
                HelpView()
                                    .frame(width: 700,height: 100,alignment: .topTrailing)
                
                
                Text(LocalizedStringKey("Checkin has Completed"))
                    .font(.system(size: 50, weight: .bold, design: .default))
                    .frame(width: 700, alignment: .center)

                Text(LocalizedStringKey("Enter your XXX password into the terminal and receive your key."))
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .frame(width: 700, alignment: .center)
                    .padding()

                
//                VimeoViewContrillerWrapper()
                
                Text(LocalizedStringKey("XXX Password"))
                    .font(.system(size: 60, weight: .bold, design: .default))
                    .frame(width: 700, alignment: .center)
                    .padding()
                
                VStack(alignment: .center){
    //                                予約情報の表示
                    List{
                        ForEach(reservationItems.indices,id: \.self){i in
                   
                        HStack(){
                            Spacer()
                                    Text(reservationItems[i].key_code ?? "Unknown")
                                        .font(.system(size: 80, weight: .black, design: .default))
                                        .frame(width: 700, alignment: .center)
                                        .foregroundColor(Color.white)
                                .background(Color.gray)
                                .cornerRadius(10)

                            Spacer()
                    }
                    
                }
                        
                        Button(action: {
                            isShowHowToGetYourKeyModal = true

                        }) {
                            Image(systemName: "person.badge.key.fill")
                            Text(LocalizedStringKey("How to get your key"))
                                .foregroundColor(Color.white)
                        }
                        .sheet(isPresented: $isShowHowToGetYourKeyModal){
                            
                            HowToGetYourKeyModal(isShowHowToGetYourKeyModal:$isShowHowToGetYourKeyModal)
                        }
                        .frame(width: 300, height: 60, alignment: .center)
                        .accentColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        Button(action: {
                            isShowHowToUseTheFacilityModal = true

                        }) {
                            Image(systemName: "house.fill")
                            Text(LocalizedStringKey("How to use the facility"))
                                .foregroundColor(Color.white)
                        }
                        .sheet(isPresented: $isShowHowToUseTheFacilityModal){
                            
                            HowToUseTheFacilityModal(isShowHowToUseTheFacilityModal:$isShowHowToUseTheFacilityModal)
                        }
                        .frame(width: 300, height: 60, alignment: .center)
                        .accentColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .buttonStyle(PlainButtonStyle())
                        
                        
                        
                        
                        
                        Spacer()
                        HStack(){
                            Spacer()
                        Button(action: {
                            envData.isNavigationActive.wrappedValue = false//正常に最初の画面に画面遷移するための処理
                        }) {
                            Text(LocalizedStringKey("I received my key.\nReturn to first screen."))
                                .font(.system(size: 20, weight: .medium, design: .default))
                                .foregroundColor(Color.white)
                        }
                        .frame(width: 300, height: 60, alignment: .center)
                        .accentColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }.padding()
                    }
                }
                
            }
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
                
        }
        .customBackButton()
        .environment(\.locale, .init(identifier: lang))
        }

    }

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView(lang: "ja",reservation_id: "B000001")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
            }
}
