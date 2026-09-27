//
//  AdminHelpView.swift
//  Checkin
//
//  Created by j-sys on 2022/09/04.
//

import SwiftUI

import UIKit
//HELPボタン
struct AdminHelpView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var isShowAdminHelpSheet = false
    @State var isShowAboutadminMenuModal:Bool = false
    @State var isShowNecessaryPreparationModal:Bool = false
    @State var isShowRequireStaffAssistanceModal:Bool = false
//    @State var isShowOthersModal:Bool = false
    @State var alertMessage:String = ""
    

    
    var body: some View {

        VStack{
            
            
        Button(action: {
            isShowAdminHelpSheet = true

        }) {
            Image(systemName: "questionmark.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.primary)
                .padding()
        }

        .sheet(isPresented: $isShowAboutadminMenuModal){
            
            AboutadminMenuModal(isShowAboutadminMenuModal:$isShowAboutadminMenuModal)
        }
        .sheet(isPresented: $isShowNecessaryPreparationModal){
            
            NecessaryPreparation(isShowNecessaryPreparationModal:$isShowNecessaryPreparationModal)
        }
        .sheet(isPresented: $isShowRequireStaffAssistanceModal){
            
            RequireStaffAssistanceModal(isShowRequireStaffAssistanceModal:$isShowRequireStaffAssistanceModal)
        }
//        .sheet(isPresented: $isShowOthersModal){
//
//            OthersModal(isShowOthersModal:$isShowOthersModal)
//        }

        .actionSheet(isPresented: self.$isShowAdminHelpSheet, content: {
                        ActionSheet(title: Text(LocalizedStringKey("HELP")), buttons: [
                            .default(Text(LocalizedStringKey("管理者メニューについて")),
                                     action: {
                                         isShowAboutadminMenuModal = true
                                     }),
                            .default(Text(LocalizedStringKey("使用する際に必要な事前/事後作業")),
                                     action: {
                                         isShowNecessaryPreparationModal = true
                                     }),
                            .default(Text(LocalizedStringKey("スタッフの対応が必要となるケース")),
                                     action: {
                                         isShowRequireStaffAssistanceModal = true
                                     }),
//                            .default(Text(LocalizedStringKey("その他不明点")),
//                                     action: {
//                                         isShowOthersModal = true
//                                     }),
                                .cancel(Text(LocalizedStringKey("Cancel")), action: {})
                        ]
                        )

        })
            
        .buttonStyle(PlainButtonStyle())
        }
        
    }
                     }




//管理者HELP 管理者メニューについて
struct AboutadminMenuModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowAboutadminMenuModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("管理者メニューについて"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){
//内容ここから
                VStack(alignment: .leading){


                Text(LocalizedStringKey("各ボタンについて説明します。"))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0016")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }
                
                    
                }  .padding(.bottom, 5)
                
                Spacer()
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("予約データ受信") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 5)
                    
                    Text(LocalizedStringKey("Google Drive上に保存されているスプレッドシート「Reservation」の内容をiPadに反映します。\niPad内のデータはすべて上書きされてしまいますので注意してください。\n\n例えば、チェックインを受け付けたものがすでにあるが、改めて「予約データ受信」を実行したい場合は、スプレッドシートの記載されている内容を「チェックイン済」にしてから「予約データ受信」ボタンを押すようにしてください。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0019")!)
                            .resizable()
                            .frame(width: 500, height:350)
                        Spacer()
                    }
                }.padding(.bottom, 5)
                    
                Spacer()
                
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("チェックイン済入力データ送信") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("iPadでチェックインしたデータをスプレッドシート「Checkin」に送信します。画像はGoogle Drive上のフォルダに保存されます。\nボタンを押すとスプレッドシートにデータが追加されます。\n何度でも追加されますので連打しないようにお願い致します。\nこのボタンを押しても、iPad内のチェックインしたデータは削除されません。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                
                    Text(LocalizedStringKey("予約データ一覧") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("iPad内に入っている予約データを確認することができます。\nこのページではお客さまの詳細なデータは確認できません。\n詳細データを確認したい場合はスプレッドシートをご確認ください。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0036")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("チェックイン済入力データ一覧") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("iPad内に保存されているチェックイン済のデータを確認することができます。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0018")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("チェックイン済入力データ全削除") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("iPad内に保存されているチェックイン済のデータを削除することができます。\n必ず「チェックイン済入力データ送信」を行ってから削除するように気をつけてください。\n一度削除するともとに戻せません。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                   
                   
                } .padding(.bottom, 5)
                
                VStack(alignment: .leading){
                    
                    Text(LocalizedStringKey("GoogleSignIn / SignOut") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("スプレッドシートを使用しているため、Googleへのサインインが必要です。\nサインインしていない場合は一部の機能が使用できなくなります。\nまた、ネットワークにつながっていない場合も同様に一部機能が使用できません。\nネットワークが不安定な場合も一部ボタンが使用できない場合がありますが、そういった場合は「更新」ボタンを押してみてください。使用できるようになる場合があります。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0030")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                    Text(LocalizedStringKey("以下手順で認証を実施してください。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    
                    Text(LocalizedStringKey("以下のような状態は、Googleにサインインできていないか、ネットワークにつながっていない可能性があります。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0015")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("Google Sign In　ボタンを謳歌します。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0029")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("警告が出るので 続ける をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0027")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("ログインしたいアカウントを をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0028")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("再度警告が出るので 続ける をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0021")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("下記のような画面が出るので　詳細　をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0022")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("Checkin(安全ではないページ)に移動　をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0023")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("下記のような画面が出るので下にスクロールし　許可　をタップ"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0024")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0025")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    } .padding(.bottom, 5)
                }
                VStack(alignment: .leading){
                    
                    Text(LocalizedStringKey("すべてのボタンが青くなっていれば正常にログインできています。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0026")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                }.padding(.bottom, 5)
                
//                内容ここまで
            }
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowAboutadminMenuModal = false

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




//管理者HELP 使用する際に必要な準備
struct NecessaryPreparation: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowNecessaryPreparationModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("使用する際に必要な事前/事後作業"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){
//内容ここから
                VStack(alignment: .leading){
                    
                    Text(LocalizedStringKey("使用する前の作業") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                    
                    Text(LocalizedStringKey("■スプレッドシート「Reservation」の更新") )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("スプレッドシート「Reservation」にiPadを使用してチェックインさせたい予約情報を入力してください。赤字の項目は必須項目です。\nもし記入がされていない場合はアプリが正常に動かない場合があります。代表者の項目を事前に入力できているとスムーズにチェックインできますので、できる限りこの時点で埋めてあげてください。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0019")!)
                            .resizable()
                            .frame(width: 500, height:350)
                        Spacer()
                    }.padding(.bottom, 5)
                
                
                    
                    Text(LocalizedStringKey("■予約データ受信") )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("スプレッドシートの更新が完了しましたら、「予約データ受信」をタップし、先程更新したスプレッドシート「Reservation」の内容をiPad内のデータに反映し最新化してください。\n\n受信後、「予約データ一覧」を確認し、予約データがiPadに正しく反映されていること確認してください。\nここが古い状態だった場合や間違った状態ですと正常にチェックインできません。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                
                HStack{
                    Spacer()
                    Image(uiImage: UIImage(named: "IMG_0031")!)
                        .resizable()
                        .frame(width: 350, height:500)
                    Spacer()
                }.padding(.bottom, 5)
           
                
                HStack{
                    Spacer()
                    Image(uiImage: UIImage(named: "IMG_0033")!)
                        .resizable()
                        .frame(width: 350, height:500)
                    Spacer()
                }.padding(.bottom, 5)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0036")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
            
                    
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("使用後の作業") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                    
                    Text(LocalizedStringKey("■Checkinデータの確認") )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("「チェックイン済入力データ一覧」を確認し、変なデータがないかチェックしてください。\n例えば、チェックイン済となっているのにチェックインのデータが無い・身分証の画像が無いなど"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0018")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    Text(LocalizedStringKey("■Checkinデータの送信") )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("「チェックイン済入力データ送信」を行ってください。送信後は必ずスプレッドシート「Checkin」に反映されているかご確認ください。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0032")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0020")!)
                            .resizable()
                            .frame(width: 500, height:350)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                }
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("■Checkinデータの削除") )
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("スプレッドシートに反映できていることが確認できましたら、「チェックイン済入力データ全削除」をタップしてiPad内のデータを削除してください。\n\n他、YHV内で決められている作業があれば実施してください。\n\n以上で完了です。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0035")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                    
                }.padding(.bottom, 5)
                
                
//                内容ここまで
            }
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowNecessaryPreparationModal = false

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


//管理者HELP スタッフの対応が必要よなるケース
struct RequireStaffAssistanceModal: View {
    
    @Environment(\.managedObjectContext) private var viewContext
//    var lang: String
    
    @Binding var isShowRequireStaffAssistanceModal: Bool
    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("スタッフの対応が必要よなるケース"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){
//内容ここから
                VStack(alignment: .leading){
                    Text(LocalizedStringKey("ヘルプボタンから「スタッフを呼ぶ」ボタンが押された場合") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("お客さまがチェックイン操作をしている際に、ヘルプボタンから「スタッフを呼ぶ」ボタンが押された場合チャットワークにその旨を知らせるメッセージが飛びます。ご対応をお願い致します。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0037")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                    Text(LocalizedStringKey("宿泊代金が未払いのお客様がチェックインをする場合") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)

                    Text(LocalizedStringKey("未払いの状態でチェックインできないように、スタッフが画面を操作して認証する必要があります。必ず支払いがされていることを確認の上、操作するようにお願い致します。"))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0038")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    HStack{
                        Spacer()
                        Image(uiImage: UIImage(named: "IMG_0039")!)
                            .resizable()
                            .frame(width: 350, height:500)
                        Spacer()
                    }.padding(.bottom, 5)
                    
                    
                    
                }.padding(.bottom, 5)
                
//                内容ここまで
            }
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowRequireStaffAssistanceModal = false

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



////管理者HELP その他
//struct OthersModal: View {
//
//    @Environment(\.managedObjectContext) private var viewContext
////    var lang: String
//
//    @Binding var isShowOthersModal: Bool
//
//    var body: some View {
//
//        Section(header: Text(LocalizedStringKey("その他"))
//                    .font(.title)
//                    .fontWeight(.semibold)
//                    .padding(.bottom, 15)
//        ){
//            Form {
//            VStack(alignment: .leading){
////内容ここから
//                VStack(alignment: .leading){
//
//
//                Text(LocalizedStringKey("We will explain how to use the facility and precautions."))
//                        .padding(.bottom, 5)
//                        .fixedSize(horizontal: false, vertical: true)
//
//                }  .padding(.bottom, 5)
//
//                Spacer()
//
//                VStack(alignment: .leading){
//                    Text(LocalizedStringKey("Front desk") )
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .padding(.vertical, 5)
//
//                    Text(LocalizedStringKey("The front desk is on the 1st floor of the building across from Hayashi Kaikan. \nIf you have any questions, please come to the front desk."))
//                            .padding(.bottom, 5)
//                            .fixedSize(horizontal: false, vertical: true)
//
//                    HStack{
//                        Spacer()
//                        Image(uiImage: UIImage(named: "DSC_0012")!)
//                            .resizable()
//                            .frame(width: 500, height:350)
//                        Spacer()
//                    }
//                }.padding(.bottom, 5)
//
//                Spacer()
//
//                VStack(alignment: .leading){
//                    Text(LocalizedStringKey("Accommodation area") )
//                            .font(.title2)
//                            .fontWeight(.semibold)
//                            .padding(.vertical, 5)
//
//                    Text(LocalizedStringKey("Please enter Hayashi Kaikan in the building opposite the front desk, and our accommodation area is on the 4th and 5th floors. \nPlease do not enter 1F ~ 3F. \nSorry, this building does not have an elevator, so please use the stairs."))
//                            .padding(.bottom, 5)
//                            .fixedSize(horizontal: false, vertical: true)
//
//                    HStack{
//                        Spacer()
//                    Image(uiImage: UIImage(named: "DSC_0014")!)
//                        .resizable()
//                        .frame(width: 500, height:350)
//                        Spacer()
//                    }.padding(.bottom, 5)
//
//
//                } .padding(.bottom, 5)
//
//
////                内容ここまで
//            }
//
//            }.padding()
//
//            Spacer()
//
//            Button(action: {
//                isShowOthersModal = false
//
//            }) {
//                Text(LocalizedStringKey("Close"))
//                    .foregroundColor(Color.white)
//            }
//            .frame(width: 300, height: 60, alignment: .center)
//            .accentColor(Color.white)
//            .background(Color.blue)
//            .cornerRadius(10)
//            .buttonStyle(PlainButtonStyle())
//
//        }
//        .padding()
//        //        全画面表示
//                .navigationViewStyle(StackNavigationViewStyle())
//
//    }
//
//}
