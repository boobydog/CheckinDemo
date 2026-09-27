//
//  SelectLangView.swift
//  Checkin
//
//  Created by j-sys on 2022/06/17.
//

import SwiftUI

struct SelectLangView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var networkState: MonitoringNetworkStateModel
    @EnvironmentObject var vm: GoogleSigninModel
    
    @EnvironmentObject var envData: EnvironmentData//正常に最初の画面に画面遷移するための処理
//    次画面遷移用
    @State var selectFlag:Bool = false
//    管理者メニュー表示判定用
    @State var isShowAdminMenuView:Bool = false
    @State var tapCount:Int = 0
//    言語選択用State
    @State var lang:String = ""
    @State var authMessage:String = ""
//    以下対応言語　追加したい場合は project>info Localizableファイルを追加する必要がある
    let langlist = [
        ["English","en"],
        ["日本語","ja"],
        ["한국어","ko"],
        ["中文(简体)","zh-Hans"],
        ["中文(繁體)","zh-Hant"]
    ]
    //    Localauthentication 認証
    var la:LocalAuthentication = LocalAuthentication()
    
    func execLocalAuth() {
            // クロージャで非同期実行
            la.auth { message,result  in
                // 結果をメッセージに格納
                if result {
                    vm.checkStatus()
                    isShowAdminMenuView = true
                }else{
                    isShowAdminMenuView = false
                }
                authMessage = message
            }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack(){
                    
                    HStack(){
//                                        HelpView(lang:lang)
                        HelpView()
//                            .padding(.trailing,20)
                    //                管理者メニューの表示
//                                    if tapCount >= 5 {
                    Button(action: {
//                        isShowAdminMenuView = true
                        execLocalAuth()
                    }) {
                        Image(systemName: "lock.fill")
                            .resizable()    // 画像サイズをフレームサイズに合わせる
                            .frame(width: 20, height: 30)
                            .foregroundColor(.primary)
                    }
                    .sheet(isPresented: $isShowAdminMenuView) {
                        AdminMenuView()
                            .environment(\.managedObjectContext, self.viewContext)
                            .environmentObject(MonitoringNetworkStateModel())
                            .environmentObject(GoogleSigninModel())
                            .onDisappear{
                                self.tapCount = 0
                            }

                    }

//            .accentColor(Color.white)
            .padding(.trailing,20)
           
                    } .frame(width: 700,height: 100,alignment: .topTrailing)
//                                    }

//                YHVロゴ
                Image("logo")
                    .resizable()    // 画像サイズをフレームサイズに合わせる
                    .frame(width: 150, height: 150)     // フレームサイズの指定
                    .cornerRadius(10)
                    .onTapGesture {
                        if tapCount < 5{
                            self.tapCount += 1
                        }else if tapCount > 5{
                            self.tapCount = 0
                        }
                                    }
                
                Text("Checkin System")
                    .font(.system(.title, design: .default))
                    .fontWeight(.bold)
                Text("Welcome!")
                    .font(.system(.title, design: .default))
                    .fontWeight(.bold)

                Text("Please Select Languages")
                Text("")

                NavigationLink(destination: SelectQRView(lang: lang),isActive: $selectFlag) {
                EmptyView()
                    }

                
                ForEach(0..<langlist.count) { i in
                    Button(action: {
                        self.lang = self.langlist[i][1]
                        self.selectFlag = true
                        envData.isNavigationActive = $selectFlag//正常に最初の画面に画面遷移するための処理
                    }) {
                        Text(self.langlist[i][0])
                        .font(.system(.title, design: .default))
                        .fontWeight(.bold)
                    }
                    
                }
                    Spacer()
            }
                Spacer()
                
            }
        }
        
//        全画面表示
        .navigationViewStyle(StackNavigationViewStyle())
//        別画面から画面遷移した際の戻るナビゲーションボタンの非表示
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)

    }
    
    
        
}

struct SelectLangView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLangView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}

