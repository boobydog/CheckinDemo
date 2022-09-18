//
//  SelectQRView.swift
//  CheckinApp
//
//  Created by j-sys on 2022/06/16.
//

import SwiftUI
import CoreData

struct SelectQRView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = ScannerViewModel()
    @EnvironmentObject var chat: ChatWorkModel //正常に最初の画面に画面遷移するための処理
    @State var selectFlag:Bool = false
    var lang: String
    @State var isShowHelpSheet = false
    var hello = LocalizedStringKey("Inquire")
    /// 入力値チェック
    var inputValueCheck: Bool {
        viewModel.lastQrCode.count >= 7
    }

    var body: some View {
        
        
        ZStack(alignment: .center){

            VStack(alignment: .center) {

//                                HelpView(lang:lang)
//                HelpView()
//                VStack{
 
                NavigationLink(destination: CheckinFormView(lang:lang,reservation_id: viewModel.lastQrCode),isActive: $selectFlag) {
                EmptyView()
                    }
//
                
                Form {
                    
                    
                    VStack{
                        
                        HelpView()
                            .frame(width: 700,height: 100,alignment: .topTrailing)
                    Text(LocalizedStringKey("Read the QR code in the email when you made the reservation, or Please enter your reservation number."))
                            .fixedSize(horizontal: false, vertical: true)
                        .font(.title)
                        
                    }.padding()
                    
                    
                    
                    HStack{
                        
                    TextField(LocalizedStringKey("Reservation number"), text: $viewModel.lastQrCode)
//                         .frame(width: 300, height: 60, alignment: .center)
                        .keyboardType(.URL)
                        .autocapitalization(.allCharacters)
                    
                    Button(action: {
                                    viewModel.isShowing = true
                                }){
                                    Text(LocalizedStringKey("Read QR Code"))
                                        .font(.system(size: 15, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                    Image(systemName: "camera")
                                        .font(.system(size: 15, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                }
                        
                                .frame(width: 200, height: 60, alignment: .center)
                        .accentColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                
            }
            
                Button(LocalizedStringKey("Next")) {
                                    self.selectFlag = true
                                }
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundColor(Color.white)
                .frame(width: 130, height: 60, alignment: .center)
                .accentColor(Color.white)
//                .background(Color.blue)
                .background(inputValueCheck ? Color.blue: Color.gray)
                .cornerRadius(10)
                .disabled(!inputValueCheck)
          
                }
        
            .fullScreenCover(isPresented: $viewModel.isShowing) {
                SecondView(viewModel: viewModel)
            }


//        全画面表示
//        .navigationViewStyle(StackNavigationViewStyle())
            .navigationViewStyle(.stack)
            .customBackButton()
        .environment(\.locale, .init(identifier: lang))
        
    }
}

struct SelectQRView_Previews: PreviewProvider {
    static var previews: some View {
        SelectQRView(lang: "ja")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}

