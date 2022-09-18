//
//  HelpView.swift
//  Checkin
//
//  Created by j-sys on 2022/09/04.
//

import SwiftUI
import SDWebImageSwiftUI
import UIKit
//HELPボタン
struct HelpView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var chat: ChatWorkModel //正常に最初の画面に画面遷移するための処理
    @State var isShowHelpSheet = false
    @State var isShowHelpAlertView:Bool = false
    @State var isShowCheckInInstructionsModal:Bool = false
    @State var isShowHowToGetYourKeyModal:Bool = false
    @State var isShowHowToUseTheFacilityModal:Bool = false
    @State var isShowCheckOutInstructionsModal:Bool = false
    @State var isShowOtherServicesModal:Bool = false
    @State var alertMessage:String = ""
    

    
    var body: some View {

        VStack{
            
            
        Button(action: {
            isShowHelpSheet = true

        }) {
            Image(systemName: "questionmark.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.primary)
                .padding()
        }
        .sheet(isPresented: $isShowHelpAlertView) {
            CallStaffModal(message:Binding(projectedValue: $alertMessage),isShowHelpAlertView:$isShowHelpAlertView)

        }
        .sheet(isPresented: $isShowCheckInInstructionsModal){
            
            CheckInInstructionsModal(isShowCheckInInstructionsModal:$isShowCheckInInstructionsModal,isShowHowToGetYourKeyModal:$isShowHowToGetYourKeyModal)
        }
        .sheet(isPresented: $isShowHowToGetYourKeyModal){
            
            HowToGetYourKeyModal(isShowHowToGetYourKeyModal:$isShowHowToGetYourKeyModal)
        }
        .sheet(isPresented: $isShowHowToUseTheFacilityModal){
            
            HowToUseTheFacilityModal(isShowHowToUseTheFacilityModal:$isShowHowToUseTheFacilityModal)
        }
        .sheet(isPresented: $isShowCheckOutInstructionsModal){
            
            CheckOutInstructionsModal(isShowCheckOutInstructionsModal:$isShowCheckOutInstructionsModal)
        }
        .sheet(isPresented: $isShowOtherServicesModal){
            
            OtherServicesModal(isShowOtherServicesModal:$isShowOtherServicesModal)
        }
        .actionSheet(isPresented: self.$isShowHelpSheet, content: {
                        ActionSheet(title: Text(LocalizedStringKey("HELP")), buttons: [
                            .default(Text(LocalizedStringKey("Check-in Instructions")),
                                     action: {
                                         isShowCheckInInstructionsModal = true
                                     }),
                            .default(Text(LocalizedStringKey("How to get your key")),
                                     action: {
                                         isShowHowToGetYourKeyModal = true
                                     }),
                            .default(Text(LocalizedStringKey("How to use the facility")),
                                     action: {
                                         isShowHowToUseTheFacilityModal = true
                                     }),
                            .default(Text(LocalizedStringKey("Check-out Instructions")),
                                     action: {
                                         isShowCheckOutInstructionsModal = true
                                     }),
                            .default(Text(LocalizedStringKey("Other Services")),
                                     action: {
                                         isShowOtherServicesModal = true
                                     }),
                            .default(Text(LocalizedStringKey("Call the staff")),
                            action: {
                               let text = "Checkin端末から呼び出しがありました。対応お願い致します。"
                                chat.sendMessage(message: text){ result,code,message in
                                    
                                    if result {
                                        
                                        alertMessage = "Call Send Success"
                                        isShowHelpAlertView = true
                                    }else{
                                        alertMessage = "Call Send Failed"
                                        isShowHelpAlertView = true
                                    }
                                    
                                }
                                
                            }),
                                .cancel(Text(LocalizedStringKey("Cancel")), action: {})
                        ]
                        )

        })
            
        .buttonStyle(PlainButtonStyle())
        }
        
    }
                     }

//HELP スタッフ呼び出し後のモーダル画面
struct CallStaffModal: View {
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    @Binding var message:String
    @Binding var isShowHelpAlertView: Bool
    var cellphone = Bundle.main.object(forInfoDictionaryKey:"CELLPHONE") as! String
    var email = Bundle.main.object(forInfoDictionaryKey:"EMAIL") as! String
    var qrurl = "https://chart.googleapis.com/chart?chs=150x150&cht=qr&chl="
    
    
//    init(lang: String,isShowPrivacyPolicyView: Bool){
//        self.lang = lang
////        self.isShowPrivacyPolicyView = isShowPrivacyPolicyView
//    }
    
    var body: some View {
        Section(header: Text("")//Text(LocalizedStringKey(message))//Text("")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .center){
                Spacer()
                Text(LocalizedStringKey(message))
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .frame(width: 600, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                Text(LocalizedStringKey("If you are in a hurry, please contact us at the contact information below."))
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .frame(width: 600, alignment: .center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                
                HStack{
                    Spacer()
                Text(cellphone)
                    .font(.system(size: 60, weight: .black, design: .default))
                    .frame(width: 600, alignment: .center)
                    .foregroundColor(Color.primary)
            .background(Color.gray)
            .cornerRadius(10)
                   
                    Spacer()
                }.padding()
                HStack{
                    Spacer()
                    WebImage(url: URL(string: qrurl+cellphone))
                                .resizable()
                                .frame(width: 200, height: 200)
                    Spacer()
                }
                
//                URLImageView(viewModel: .init(url: qrurl+cellphone))
//                URLImageView(viewModel: .init(url: "test"))
//                            .frame(width: 256, height: 256)
                
                HStack{
                    Spacer()
                Text(email)
                    .font(.system(size: 30, weight: .black, design: .default))
                    .frame(width: 600, alignment: .center)
                    .foregroundColor(Color.primary)
            .background(Color.gray)
            .cornerRadius(10)
                    
                Spacer()
            }.padding()
                HStack{
                    Spacer()
                    WebImage(url: URL(string: qrurl+email))
                                .resizable()
                                .frame(width: 200, height: 200)
                    Spacer()
                } .padding(.bottom, 15)
               
            }
            

        }
            Spacer()
            
            Button(action: {
                isShowHelpAlertView = false

            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            .padding()
        }
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
//                .environment(\.locale, .init(identifier: lang))
    }
}




//HELP チェックイン手順
struct CheckInInstructionsModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowCheckInInstructionsModal: Bool
    @Binding var isShowHowToGetYourKeyModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("Check-in Instructions"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
                
            VStack(alignment: .leading){

              
                VStack(alignment: .leading){

                    Text(LocalizedStringKey("Describe the check-in procedure"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    

                }  .padding(.bottom, 10)
                
                
                Spacer()
                

                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Language selection") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                    Text(LocalizedStringKey("First, select your language on the top page of the check-in app."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "IMG_0007")!)
                        .resizable()
                        .frame(width: 350, height:500)
                        Spacer()
                    }
                    Text(LocalizedStringKey("Enter your reservation number"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                    Text(LocalizedStringKey("Please read the QR code of the reservation number described in the reservation completion email sent from us at the time of reservation. Alternatively, enter the reservation number provided in the email and tap \"Next\"."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "IMG_0009")!)
                        .resizable()
                        .frame(width: 350, height:500)
                        Spacer()
                    }
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Enter customer information"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        
                    Text(LocalizedStringKey("Once the reservation has been confirmed based on the reservation number entered by the customer, the screen will transition to the customer information input screen. \nPlease enter the necessary information for the representative and all guests to complete check-in. \nIf you do not live in Japan, you are required to take a photo of your ID card with a face photo, such as a passport, so please take a photo from yesterday on the form. \nIf you have not paid yet, please contact the staff. Please call the staff from the help button on the upper right of the screen."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)

                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "IMG_0011")!)
                        .resizable()
                        .frame(width: 350, height:500)
                    Spacer()
                    }
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "IMG_0012")!)
                        .resizable()
                        .frame(width: 350, height:500)
                    Spacer()
                    }
                    
                    Text(LocalizedStringKey("Key pick-up"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("After successful check-in, a serial number for key collection will be displayed. Enter the serial number into the terminal called XXX and receive the key. \nPlease refer to the following for the operation procedure of the terminal."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    Button(action: {
                        isShowHowToGetYourKeyModal = true

                    }) {
                        Text(LocalizedStringKey("How to get your key"))
                            .foregroundColor(Color.blue)
                    }
                    .frame(alignment: .center)
                    .accentColor(Color.blue)
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $isShowHowToGetYourKeyModal){
                        
                        HowToGetYourKeyModal(isShowHowToGetYourKeyModal:$isShowHowToGetYourKeyModal)
                    }
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "IMG_0014")!)
                        .resizable()
                        .frame(width: 350, height:500)
                        Spacer()
                    }
                    
                }
                
                
            }
                
            
            
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowCheckInInstructionsModal = false
                
            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}



//Help 鍵の受け取り方
struct HowToGetYourKeyModal: View {

    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowHowToGetYourKeyModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("How to get your key"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){

                VStack(alignment: .leading){
                    
                Text(LocalizedStringKey("We will explain how to operate the XXX terminal when receiving the key."))
                        .fixedSize(horizontal: false, vertical: true)
                    
                Text(LocalizedStringKey("We have automated the receipt of keys, and we have introduced a mechanism to receive them from a terminal called XXX. The procedure is described below."))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "image_logo")!)
                            .resizable()
                            .frame(width: 500, height:350)
//                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    }
                    
                }  .padding(.bottom, 10)
              
                Spacer()
                
                VStack(alignment: .leading){

                    Text(LocalizedStringKey("Touch the touch panel of XXX") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("Choose your language"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("Select key pick-up"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("Enter key code"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("Select the name of the key you will receive"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("Take the key out of the open lock cabinet and close it"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    Text(LocalizedStringKey("The number on the key is the room number."))
//                            .font(.title2)
//                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0011")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                   

                }
                
            }
                
            
            
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowHowToGetYourKeyModal = false

            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}


//HELP 施設利用方法説明
struct HowToUseTheFacilityModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowHowToUseTheFacilityModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("How to use the facility"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){

                VStack(alignment: .leading){


                Text(LocalizedStringKey("We will explain how to use the facility and precautions."))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }  .padding(.bottom, 5)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Front desk") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)

                    Text(LocalizedStringKey("The front desk is on the 1st floor of the building across from XXX. \nIf you have any questions, please come to the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "DSC_0012")!)
                            .resizable()
                            .frame(width: 500, height:350)
                        Spacer()
                    }
                }
                    
                Spacer()
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Accommodation area") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)

                    Text(LocalizedStringKey("Please enter XXX in the building opposite the front desk, and our accommodation area is on the 4th and 5th floors. \nPlease do not enter 1F ~ 3F. \nSorry, this building does not have an elevator, so please use the stairs."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0014")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                    }
                        HStack{
                            Spacer()
                    Image(uiImage: UIImage(named: "DSC_0015")!)
                        .resizable()
                        .frame(width: 500, height:350)
                            Spacer()
                            
                        }
                        
                    HStack{
                        Spacer()
                Image(uiImage: UIImage(named: "DSC_0028")!)
                    .resizable()
                    .frame(width: 350, height:500)
                        Spacer()
                        
                    }
                        .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("Floor map"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "FloarMap4F")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "FloarMap4F")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                } .padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Toilet location"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)

                    Text(LocalizedStringKey("There is a men's restroom on the 4th floor and a women's restroom on the 5th floor. Please make sure there are no mistakes."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)

                    Text(LocalizedStringKey("Shower room"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)

                    Text(LocalizedStringKey("There is one shower room on each floor on the 4th and 5th floors. Please be sure to lock the door when using. It can get crowded at night. There is also a public bath nearby, so please use it if you like. \nWe sell towels at the front desk. Soap and shampoo are provided. Please refrain from using the hair dryer after 22:00."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0026")!)
                        .resizable()
                        .frame(width: 300, height:400)
                    Spacer()
                    }

                } .padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Non smoking area"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                        
                    Text(LocalizedStringKey("All rooms and buildings are non-smoking. When smoking, please use the 5F smoking area listed on the floor map. If we find that you have smoked in your room, we will charge you a cleaning fee."))
                            .padding(.bottom, 5)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0034")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0033")!)
                        .resizable()
                        .frame(width: 500, height:350)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        }
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0030")!)
                        .resizable()
                        .frame(width: 350, height:500)
                        Spacer()
                        } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("Shared kitchen"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("There is a shared kitchen on the 5th floor. Since other customers will also use it, please clean it after use and take care so that the next customer can use it comfortably."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0022")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                        }
                    
                    
                } .padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Key handling when going out"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    
                    Text(LocalizedStringKey("There is no need to leave your key at the front desk when you go out. Please manage by yourself. If you lose the key, we will charge a fee for reissuing the key. note that."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                } .padding(.bottom, 5)
                VStack(alignment: .leading){
                    
                    Text(LocalizedStringKey("Check-out/Key return location"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("Please check out by 10:00.\nIf you wish to extend your stay, please ask at the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    Text(LocalizedStringKey("If you check out before 9:00, there are key return boxes on the stairs on the 4th and 5th floors. Please return the key there. Please return the key to the front desk after 9:00."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0021")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                        }.padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("Request for cooperation in collection of sheets and pillowcases"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("When checking out, please remove the pillowcases and sheets from the futon and put them in the collection bag near the stairs. Thank you for your cooperation."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                        HStack{
                            Spacer()
                    Image(uiImage: UIImage(named: "DSC_0016")!)
                        .resizable()
                        .frame(width: 500, height:350)
                            Spacer()
                            }.padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("Luggage storage service"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                }.padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    
                    Text(LocalizedStringKey("After check-out, you can leave your luggage at the front desk for free on the same day. You can keep it until the closing time of the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0013")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                        }
                    
                    Text(LocalizedStringKey("Event announcement"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    
                    Text(LocalizedStringKey("We regularly hold events such as movie screenings and parties. Please join us. Please contact the front desk staff for details."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "event")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                }
                
            }
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowHowToUseTheFacilityModal = false

            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

//HELP チェックアウト手順
struct CheckOutInstructionsModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowCheckOutInstructionsModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("Check-out Instructions"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){

                VStack(alignment: .leading){

                Text(LocalizedStringKey("Describe the checkout procedure."))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }  .padding(.bottom, 10)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Floor map"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "FloarMap4F")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                            }
                    
                        HStack{
                            Spacer()
                            Image(uiImage: UIImage(named: "FloarMap4F")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                        }
                    
                    Text(LocalizedStringKey("Check-out/Key return location"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("Please check out by 10:00.\nIf you wish to extend your stay, please ask at the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    Text(LocalizedStringKey("If you check out before 9:00, there are key return boxes on the stairs on the 4th and 5th floors. Please return the key there. Please return the key to the front desk after 9:00."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0021")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Request for cooperation in collection of sheets and pillowcases"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("When checking out, please remove the pillowcases and sheets from the futon and put them in the collection bag near the stairs. Thank you for your cooperation."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0016")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                    
                    Text(LocalizedStringKey("Luggage storage service"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
              
                    
                    Text(LocalizedStringKey("After check-out, you can leave your luggage at the front desk for free on the same day. You can keep it until the closing time of the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0013")!)
                        .resizable()
                        .frame(width: 500, height:350)
                        Spacer()
                    }
                    
                }
                
            }
                
            
            
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowCheckOutInstructionsModal = false

            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

//HELP その他サービス
struct OtherServicesModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowOtherServicesModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("Other Services"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){

                VStack{

                Text(LocalizedStringKey("List other services."))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    

                }  .padding(.bottom, 5)
                
                Spacer()
                

                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Luggage storage service"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
              
                    
                    Text(LocalizedStringKey("After check-out, you can leave your luggage at the front desk for free on the same day. You can keep it until the closing time of the front desk."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "DSC_0013")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                    
                    
                    Text(LocalizedStringKey("Event announcement"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    
                    Text(LocalizedStringKey("We regularly hold events such as movie screenings and parties. Please join us. Please contact the front desk staff for details."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                    Image(uiImage: UIImage(named: "event")!)
                        .resizable()
                        .frame(width: 500, height:350)
                    Spacer()
                    }
                    
                }
                
                
            }
                
            
            
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowOtherServicesModal = false

            }) {
                Text(LocalizedStringKey("Close"))
                    .foregroundColor(Color.white)
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding()
        //        全画面表示
                .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

