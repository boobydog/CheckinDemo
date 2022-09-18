//
//  ViewModelBootcamp.swift
//  Checkin
//
//  Created by j-sys on 2022/06/27.
//

import Foundation
import CoreData
import SwiftUI
import UIKit



class  Model: ObservableObject {
    @Published var items: [SubModel] = []

    func addItems(_ residenceindex: Int,
                  _ residence_country: String,
                  _ delegate_flag: Bool,
                  _ name: String,
                  _ booking_id: String,
                  _ email: String,
                  _ tel: String,
                  _ nationality: String,
                  _ countrycode:String,
                  _ identification: UIImage,
                  _ address: String,
                  _ idd_code: String) {
        self.items.append(SubModel(residenceindex,
                                   residence_country,
                                   delegate_flag,
                                   name,
                                   booking_id,
                                   email,
                                   tel,
                                   nationality,
                                   countrycode,
                                   identification,
                                   address,
                                   idd_code))

    }

}

class SubModel: ObservableObject, Identifiable {
    let id = UUID()
    let insert_at = Date()
    @Published var residenceindex:Int //日本国内に住んでいるかどうかのフラグ 国内：0 国外:1
    @Published var residence_country:String
    @Published var delegate_flag:Bool //代表者かどうかのフラグ 代表：true それ以外:false
    @Published var name: String?
    @Published var booking_id: String?
    @Published var email: String?
    @Published var tel: String?
    @Published var nationality: String?
    @Published var countrycode: String?
    @Published var identification: UIImage
    @Published var address: String?
    @Published var idd_code: String?

    init(_ residenceindex:Int,
         _ residence_country: String,
         _ delegate_flag:Bool,
         _ name: String,
         _ booking_id: String,
         _ email: String,
         _ tel: String,
         _ nationality: String,
         _ countrycode:  String,
         _ identification: UIImage,
         _ address: String,
         _ idd_code: String
    ) {
        self.residenceindex = residenceindex
        self.residence_country = residence_country
        self.delegate_flag = delegate_flag
        self.name = name
        self.booking_id = booking_id
        self.email = email
        self.tel = tel
        self.nationality = nationality
        self.countrycode = countrycode
        self.identification = identification
        self.address = address
        self.idd_code = idd_code
    }
}


struct CheckinFormView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var lm :LocaleModel
//    @ObservedObject var model = CheckinModel()
//    @StateObject var model = CheckinModel()
    @ObservedObject var model =  Model()
    @FetchRequest  var items: FetchedResults<Reservation>
    @State var errorMessage:[String] = []
    @State var selected = 0
    @State var selectFlag:Bool = false
    @State var num_of_stay = 0
    @State var isShowCheckinAlertView:Bool = false
    @State var isShowPayAlertView:Bool = false
    @State var isShowPrivacyPolicyView = false
    @State var privacyAgreeChecked:Bool = false
    @State var paid_flag:Bool = false //支払い済フラグ（更新用）
    @State var authMessage:String = ""
    var fetchedArray: [NSManagedObject] = []
    var countries: [String:String] = [:]
    var lang: String
    var reservation_id: String
    var la:LocalAuthentication = LocalAuthentication()
    
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
        self._items = FetchRequest(
            entity: Reservation.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Reservation.booking_id, ascending: true)],
            predicate:NSPredicate(format: "checkin_flag == %@ && booking_id ==  %@",NSNumber(value: false),"\(self.reservation_id)"),
            animation: .default
        )



    }
    var body: some View {
        
        if (items.count <= 0 && self.selectFlag == false){
            Form {
            VStack{

                HelpView()
                                    .frame(width: 700,height: 100,alignment: .topTrailing)
                
            Text(LocalizedStringKey("Reservation information not found."))
                .font(.title)
                .foregroundColor(Color.red)
                .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }.padding()
            }
            //        全画面表示
                    .navigationViewStyle(StackNavigationViewStyle())
                    .customBackButton()
                    .environment(\.locale, .init(identifier: lang))
            
        }else{

        ZStack(alignment: .bottom){
//        VStack(alignment: .center) {

            NavigationLink(destination: CompleteView(lang:lang,reservation_id: reservation_id),isActive: $selectFlag) {
                EmptyView()

            }
            
            Form {
                
//                以下VStackを取るとうまくチェックインできなくなる
                VStack(alignment: .leading){

                    HelpView()
                                        .frame(width: 700,height: 50,alignment: .topTrailing)

                                            //                                予約情報の表示
                                                            List(items.indices,id: \.self){i in
 
                                                                        Section(header: Text(LocalizedStringKey("Reservation info"))
                                                                                    .font(.title3)
                                                                                    .fontWeight(.semibold)){
                                                                            VStack(alignment: .leading){
                                            //                                    予約番号
                                                                        HStack{
                                                                            Text(LocalizedStringKey("Reservation number"))
                                                                                .font(.headline)
                                                                                .frame(width:200,alignment: .leading)
                                                                                .padding(.leading, 30)
                                                                            Text(items[i].booking_id ?? "Unknown")
                                                                            

                                                                        }
                                                                        .padding(.vertical, 1)

                                            //                                    部屋数
                                                                        HStack{
                                                                            Text(LocalizedStringKey("Number of rooms"))
                                                                                .font(.headline)
                                                                                .frame(width:200,alignment: .leading)
                                                                                .padding(.leading, 30)
                                                                            Text("\(items[i].num_of_rooms)")

                                                                                 }
                                                                                    .padding(.vertical, 1)
                                            //                                    宿泊人数
                                                                                 HStack{
                                                                                Text(LocalizedStringKey("Number of people"))
                                                                                    .font(.headline)
                                                                                    .frame(width:200,alignment: .leading)
                                                                                    .padding(.leading, 30)
                                                                            Text("\(items[i].num_of_people)" )

                                                                            }
                                                                                    .padding(.vertical, 1)
                                            //                                    部屋タイプ
                                                                                 HStack{
                                                                                Text(LocalizedStringKey("Room Type"))
                                                                                    .font(.headline)
                                                                                    .frame(width:200,alignment: .leading)
                                                                                    .padding(.leading, 30)
                                                                                Text(items[i].room_type ?? "Unknown")

                                                                            }
                                                                        .padding(.vertical, 1)
                                            //                                    チェックイン日付
                                                                        HStack{
                                                                                Text(LocalizedStringKey("Check in date"))
                                                                                    .font(.headline)
                                                                                    .frame(width:200,alignment: .leading)
                                                                                    .padding(.leading, 30)
                                                                            Text("\(dateFormatter.string(from: items[i].checkin_at!))")
                                                                            }
                                                                        .padding(.vertical, 1)
                                            //                                    チェックアウト日付
                                                                        HStack{
                                                                            Text(LocalizedStringKey("Check out date"))
                                                                                .font(.headline)
                                                                                .frame(width:200,alignment: .leading)
                                                                                .padding(.leading, 30)

                                                                                Text("\(dateFormatter.string(from: items[i].checkout_at!))")

                                                                            }
                                                                        .padding(.vertical, 1)
                                                                                
                                            //                                    支払い金額
                                                                                 HStack{
                                                                                Text(LocalizedStringKey("Payment"))
                                                                                    .font(.headline)
                                                                                    .frame(width:200,alignment: .leading)
                                                                                    .padding(.leading, 30)
                                                                                Text(items[i].amount ?? "Unknown")

                                                                            }.padding(.vertical, 1)
                                            //                                   お支払い状況
                                                                                 HStack{
                                                                                Text(LocalizedStringKey("Payment status"))
                                                                                    .font(.headline)
                                                                                    .frame(width:200,alignment: .leading)
                                                                                    .padding(.leading, 30)


                                                                                Text(items[i].paid_flag ? LocalizedStringKey("Paid") : "Unpaid")

                                                                            }





                                                                                Spacer()
                                                            }
                                                                }
                                                                                    .padding(.bottom, 5)
                                                            }

                            //                                    滞在人数分の入力フォームの表示
                                            List(model.items.indices,id:\.self){i in
                                               

                                                            if (i == 0){
                            //                                                最初の1名は代表者用のフォーム
                                                            DelegateInputForm(lang:self.lang,item: model.items[i])
                                                                    .environmentObject(LocaleModel(lang:self.lang))
                                                                   
                                                            }else{
                                                                InputForm(item: model.items[i])
                                                            }



                                                Spacer()
                                            }

                }
                
                
//                ここからFooter
//                個人情報の取り扱い
                HStack {
                    Spacer()
                    VStack(alignment: .center){
                        HStack {
                Image(systemName: privacyAgreeChecked ? "checkmark.square" : "square")
                                .font(.system(size: 20, weight: .medium, design: .default))
                                        .onTapGesture {
                                            privacyAgreeChecked.toggle()
                                        }
                        
                            
                            
                            Button(action: {
                                isShowPrivacyPolicyView = true

                            }) {
                                Text(LocalizedStringKey("I agree to the privacy policy."))
                                    .font(.system(size: 20, weight: .medium, design: .default))
                                    .foregroundColor(Color.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(isPresented: $isShowPrivacyPolicyView) {
                                PrivacyPolicy(lang:lang,isShowPrivacyPolicyView:$isShowPrivacyPolicyView)

                            }
                            

                        
                        }.padding(.vertical,20)
                        
//                入力チェックエラーメッセージ
                        if errorMessage != [] {
                            VStack(alignment: .center){
                                    List(errorMessage , id: \.self){item in
                                    Text(LocalizedStringKey(item))
                                        .font(.headline)
                                        .foregroundColor(.red)
                                        .frame(alignment: .center)
                                        
                                    }
                            }.padding(.vertical,20)
                                    

                        }
                        
                        
                        if self.paid_flag {
//                            支払いが完了している場合のボタン表示
                            Button(action: {
                                
                                if validCheck(){
                                isShowCheckinAlertView = false
                                } else{
                                   
                                        isShowCheckinAlertView = true
                                }
                                
                            }) {
                                HStack {
                                    Image(systemName: "play.circle")
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                    Text(LocalizedStringKey("Check in"))
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            .frame(width: 200, height: 60, alignment: .center)
                            .accentColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                            .alert(isPresented: $isShowCheckinAlertView) {
                                return Alert(title: Text(LocalizedStringKey("Check in")),
                                                  message: Text(LocalizedStringKey("Check in with the information you entered. Is it OK?")),
                                      primaryButton: .cancel(Text(LocalizedStringKey("Cancel"))),
                                      secondaryButton: .default(Text(LocalizedStringKey("Run")),

                                                                action: {
                                    executeCheckin()
                                    
                                })

                                )
                                }
                            
                            
                        }else{
                            
//                            支払いが完了していない場合はこちらのボタンを表示
                            
                            Button(action: {
                                
                                if validCheck(){
                                    isShowPayAlertView = false
                                } else{

                                        isShowPayAlertView = true
                                    
                                
                                }
                                
                            }) {
                                HStack {
                                    Image(systemName: "play.circle")
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                    Text(LocalizedStringKey("Check in"))
                                        .font(.system(size: 20, weight: .medium, design: .default))
                                        .foregroundColor(Color.white)
                                }
                                
                            }
                            .frame(width: 200, height: 60, alignment: .center)
                            .accentColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .buttonStyle(PlainButtonStyle())
                            .alert(isPresented: $isShowPayAlertView) {
                                return Alert(title: Text(LocalizedStringKey("Payment required")),
                                                  message: Text(LocalizedStringKey("Since your payment has not been completed,\nstaff action is required. \nPlease contact the staff from the help button.")),
                                      primaryButton: .cancel(Text(LocalizedStringKey("Cancel"))),
                                      secondaryButton: .default(Text(LocalizedStringKey("Paid. Execute check-in.")),
                                                                action: {
//                                    executeCheckin()
                                    execLocalAuth()
                                    
                                }))
                                }
                            
                            
                            
                            
                        }
                        

                    }
                    Spacer()
                }
                //                ここまでFooter
            }


        .onAppear{
            appendCheckin(items: items)
        }
            


            
        }
//        全画面表示
        .navigationViewStyle(StackNavigationViewStyle())
        .customBackButton()
        .environment(\.locale, .init(identifier: lang))
        }

    }

    
    func executeCheckin(){
        

print("start Checkin")
//                CoreaDataにInsert Update処理
do{
    for item in model.items {
        print("insert checkin model")
        let newCheckin = Checkin(context: viewContext)
        newCheckin.id = UUID()
        newCheckin.insert_at = Date()
        newCheckin.address = item.address
        newCheckin.booking_id = item.booking_id
        newCheckin.name = item.name
        newCheckin.email = item.email
        newCheckin.tel = item.tel
        newCheckin.idd_code = item.idd_code
        newCheckin.nationality = item.nationality
        newCheckin.residence_country = item.residence_country
        newCheckin.identification = item.identification.jpegData(compressionQuality: 0.8)
//        newCheckin.identification = item.identification.pngData()
        
    }

for item in items{
print("update checkin flag")
print("target Booking number:\(item.booking_id ?? "")")
item.setValue(true,forKeyPath:"checkin_flag")
item.setValue(true,forKeyPath:"paid_flag")
}
print("try viewContext.save()")
try viewContext.save()
self.selectFlag = true
print("end viewContext.save()")
} catch let error as NSError {
print("\(error), \(error.userInfo)")
}
print("end Checkin")
        
    }
    
//    LocalAuthentication パスワード認証
    func execLocalAuth() {
            // クロージャで非同期実行
            la.auth { message,result in
                // 結果をメッセージに格納
                if result {
//                    認証が成功したらチェックインを実行する
                    executeCheckin()
                }
                authMessage = message
            }
    }
    
    func appendCheckin(items: FetchedResults<Reservation>){
        //              配列の初期化
        model.items = []
        var paid_count = 0

        //                        ObserverObjectに値を入れて、Checkinフォームの初期データとインスタンスをを作成する
        //                        Fromの中に作成したらappendされる数が倍になってしまったのでFormの外に出して実行する
        for item in items {
            
            if item.paid_flag == false {
                paid_count += 1
            }
            
            if paid_count > 0 {
                self.paid_flag = false
            }else{
                self.paid_flag = true
            }
        //                            num_of_peopleの数だけ入力フォームを生成する
            for index in 0 ..< item.num_of_people {
        //                                1つ目のフォームを代表者用にする
                if index == 0 {
                    model.addItems(0,
                                   "日本",
                                   true,
                                   item.name ?? "",
                                   item.booking_id ?? "",
                                   item.email ?? "",
                                   item.tel ?? "",
                                   "",
                                   "",
//                                                   UIImage(),
                                   UIImage(named: "image_logo")!,
                                   item.address ?? "",
                                   ""
                    )
                    
                }else{
//                                    2つ目以降の入力フォームは空にする
                    model.addItems(
                                   0,
                                   "日本",
                                   false,
                                   "",
                                   item.booking_id ?? "",
                                   "",
                                   "",
                                   "",
                                   "",
//                                                   UIImage(),
                                   UIImage(named: "image_logo")!,
                                   "",
                                   ""
                    )
                    
                }
                
            }
            
        }
        
    }
    
//    メールのバリデーションチェック
    func isValidEmail(_ string: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: string)
            return result
     }
    
//    入力チェック
    func validCheck()->Bool{
        print("Start Valid Check Checkin model")
        errorMessage = []
         
        
        if privacyAgreeChecked == false {
            errorMessage.append("Please agree to the privacy policy.")

        }

        
        for item in model.items {
            
            if item.delegate_flag == true {
                
                if item.residenceindex == 1 && item.nationality == "" {
                    
//                    LocalizedStringKeyのKeyを登録
                    errorMessage.append("Nationality is required.")
                   
                }
                
                if item.name == ""{
                    errorMessage.append("Representative guest name is required.")
//                    errorMessage.append("\(LocalizedStringKey("Representative guest"))"+"\(LocalizedStringKey(" name"))"+"\(LocalizedStringKey(" is"))"+"\(LocalizedStringKey(" required"))"+"\(LocalizedStringKey(" ."))")
                }
                
                if item.tel == ""{
                    errorMessage.append("Phone number is required.")

                }
                
                if item.email != "" && !isValidEmail(item.email!){
                    errorMessage.append("There is an error in the format of the email.")
                }
                
                if item.address == ""{

                }
                
                if item.residenceindex == 1 && item.identification == UIImage(named: "image_logo")! {
                    errorMessage.append("Representative guest passport picture is required.")

                }
                
                
            }else{
                if item.name == ""{
                    errorMessage.append("Other guest name is required.")

                }
                
                if item.residenceindex == 1 && item.identification == UIImage(named: "image_logo")! {
                    errorMessage.append("Other guest passport picture is required.")

                }
                
            }

        }
        
        print("End Valid Check Checkin model")
        if errorMessage == []{
            return false
        }else{
            return true
            
        }
    }
    
}


// 代表者入力フォーム
struct DelegateInputForm: View {
     var lang : String
    
//    init(lang:String){
//        self.lang = lang
//    }
    
    @Environment(\.managedObjectContext) private var viewContext
//    @Environment(\.LocaleModel) var lm

    @ObservedObject var item: SubModel
    @EnvironmentObject var lm :LocaleModel
    
    @State var showImagePicker: Bool = false
    @State var showPostImageView: Bool = false
//    @State var countryOfResidenceFlag: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "image_logo")!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    private let selectCountryOfResidence = [LocalizedStringKey("Living in Japan"), LocalizedStringKey("Living outside Japan")]
//    @State var countries:Dictionary<String,String>
//    @State var countries:[String:String]
//    @State var selectedNationality:String = "日本"
//    @ObservedObject private  var inputItem: Checkin
    var body: some View {
        
        Section(header: Text(LocalizedStringKey("Representative guest"))
                    .font(.title3)
                    .fontWeight(.semibold)
                    ){
            VStack{
            
                Group {

        VStack(alignment: .leading){
            
            HStack {
            Text(LocalizedStringKey("Country of residence"))
                .font(.headline)
                .frame(width:130,alignment: .leading)
                .padding(.leading, 15)
            Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
            ForEach(0..<selectCountryOfResidence.count, id: \.self, content: { index in
               
                    Text(selectCountryOfResidence[index])

                Image(systemName: item.residenceindex == index ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
                
                .onTapGesture {
                    item.residenceindex = index
                    if index == 0 {
                        item.residence_country = "日本"
                    }else{
                        item.residence_country = "日本以外"
                    }
                }
            })
            }
            .frame(height: 40)
            
            if item.residenceindex == 1 {
//                国内在住の場合は非表示
            HStack {
                Text(LocalizedStringKey("Nationality"))
                       .font(.headline)
                       .frame(width:130,alignment: .leading)
                       .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                Menu {
//                    List{

                    ForEach(lm.countries.sorted(by: >), id: \.key) {key, value in
                            Button(action: {item.nationality =  value
                                item.countrycode =  key
                                item.idd_code = lm.getCountryCallingCode(countryRegionCode:key)
                                print("item.idd_code:\(Binding($item.idd_code)!)")
                            }, label: {
                                Text("\(value)")
                                    .tag(value)

                            })
                            
                        }
//                }
                               }
            label: {
                TextField(LocalizedStringKey("Nationality"),text: Binding($item.nationality)!)
                    .multilineTextAlignment(.leading)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                           
                            .padding(-8.0)
                    )
                    .padding(16.0)
                   
                       }
                               }
            }

            
            HStack{
                Text(LocalizedStringKey("Name"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                TextField(LocalizedStringKey("Name"),text: Binding($item.name)!)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)
                
            }

            HStack{Text(LocalizedStringKey("Email"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Optional"))
                    .font(.footnote)
                    .foregroundColor(.blue)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                TextField(LocalizedStringKey("Email"),text: Binding($item.email)!)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)
            }

            HStack{
                Text(LocalizedStringKey("Phone number"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                if item.residenceindex == 1 {
//                    国内在住の場合は非表示
                TextField(LocalizedStringKey("Country IDD code"),text: Binding($item.idd_code)!)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                    .frame(width:130,alignment: .leading)
                    .keyboardType(.phonePad)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)
                }
                
                TextField(LocalizedStringKey("Phone number"),text: Binding($item.tel)!)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .keyboardType(.phonePad)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)

            }

            HStack{Text(LocalizedStringKey("Address"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                TextField(LocalizedStringKey("Address"),text: Binding($item.address)!)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)

            }
            
            if item.residenceindex == 1 {
//                            カメラ START
            HStack{
                Text(LocalizedStringKey("Passport picture"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                Image(uiImage: item.identification)
                    .resizable()
                    .frame(width: 400, height:350)

                
            Button(action: {
                sourceType = UIImagePickerController.SourceType.camera
                showImagePicker.toggle()
                
            }, label: {
                Image(systemName: "camera")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                
            }).buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: self.$showImagePicker) {
//                                 ImagePickerを呼び出す
                        ImagePicker(imageselected: $item.identification, sourceType: $sourceType)
                        
                    }
                
            }
            }
            
        }
                    
                }

            }

        }.padding(.bottom, 5)
                    
    }
    

}


// 一般入力フォーム
struct InputForm: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var item: SubModel
    @State var showImagePicker: Bool = false
//    @State var countryOfResidenceFlag: Bool = false
    @State var showPostImageView: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "image_logo")!
    @State var sourceType: UIImagePickerController.SourceType = .camera
    private let selectCountryOfResidence = [LocalizedStringKey("Living in Japan"), LocalizedStringKey("Living outside Japan")]
//    @ObservedObject private  var inputItem: Checkin
    var body: some View {
        
        Section(header: Text(LocalizedStringKey("Other guest"))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
                    ){
            VStack{
            
                Group {
        
        
        
        VStack(alignment: .leading){
//            HStack{
//                Text("予約番号")
//                Text(item.booking_id ?? "")
//
//            }
            
            HStack {
                Text(LocalizedStringKey("Country of residence"))
                .font(.headline)
                .frame(minWidth: 130,alignment: .leading)
                
                .padding(.leading, 15)
            Text(LocalizedStringKey("Required"))
                .font(.footnote)
                .foregroundColor(.red)
                .frame(width:55,alignment: .leading)
                .padding(.leading, 15)
            ForEach(0..<selectCountryOfResidence.count, id: \.self, content: { index in
               
                    Text(selectCountryOfResidence[index])

                    Image(systemName: item.residenceindex == index ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.blue)
                
                .onTapGesture {
                    item.residenceindex = index
                    if index == 0 {
                        item.residence_country = "日本"
                    }else{
                        item.residence_country = "日本以外"
                    }
                }
            })
            }
            .frame(height: 40)
            

            HStack{
                Text(LocalizedStringKey("Name"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                TextField(LocalizedStringKey("Name"),text: Binding($item.name)!)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .overlay(
                            RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                            .stroke(Color.gray, lineWidth: 4.0)
                            .padding(-8.0)
                    )
                    .padding(16.0)
                
            }


            if item.residenceindex == 1 {
            //                            カメラ START
            HStack{
                Text(LocalizedStringKey("Passport picture"))
                    .font(.headline)
                    .frame(width:130,alignment: .leading)
                    .padding(.leading, 15)
                Text(LocalizedStringKey("Required"))
                    .font(.footnote)
                    .foregroundColor(.red)
                    .frame(width:55,alignment: .leading)
                    .padding(.leading, 15)
                Image(uiImage: item.identification)
                    .resizable()
                    .frame(width: 400, height:350)

                
            Button(action: {
                sourceType = UIImagePickerController.SourceType.camera
                showImagePicker.toggle()
                
            }, label: {
                Image(systemName: "camera")
                    .font(.system(size: 32))
                    .foregroundColor(.gray)
                
            }).buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: self.$showImagePicker) {
                //                                 ImagePickerを呼び出す
                        ImagePicker(imageselected: $item.identification, sourceType: $sourceType)
                        
                    }
                
            }
            //                        カメラEND
            }
            
        }
    }
    
}

}
    }
}

struct PrivacyPolicy: View {
    @Environment(\.managedObjectContext) private var viewContext
    var lang: String
    
    @Binding var isShowPrivacyPolicyView: Bool
    var tel =  Bundle.main.object(forInfoDictionaryKey:"TEL") as! String

    
    var body: some View {
       
        Section(header: Text(LocalizedStringKey("Privacy Policy"))
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 15)
        ){
            Form {
            VStack(alignment: .leading){

                VStack{
                Text(LocalizedStringKey("Policy for handling private information"))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)

                Text(LocalizedStringKey("Us XXX.LCC, the operating company of XXX (hereinafter referred to as the company) handle personal information as required to running our business. We take seriously the importance of your personal information, and under the recognition that protection of personal information is our legal and social responsibility, all staff take great care to protect them."))
                        .padding(.bottom, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                Text(LocalizedStringKey("We have created the following list of policies to serve our responsibility as a company handling personal information. Here and onwards, the company and its staff will operate our business following these principals and serve to the development of society."))
                        .fixedSize(horizontal: false, vertical: true)
                }  .padding(.bottom, 10)
                
                Spacer()
                
                VStack(alignment: .leading){

                    
                    Text(LocalizedStringKey("1. Collecting, handling and handing of personal information") )
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                    Text(LocalizedStringKey("When we collect personal information, we will inform the provider with the usage of information to obtain consensus. We will take proper measures to manage the use of information, by limiting its usage to be kept within our original purpose, and give the provider of information with the option to delete or change their information."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)

                    Text(LocalizedStringKey("2. Managing risks such as information leakage"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                    Text(LocalizedStringKey("We will take proper measures to prevent loss, destruction, falsification, leakage, theft, and other risks, and will act swiftly if such exceptional cases may occur."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)

                    Text(LocalizedStringKey("3. Policy for legal compliance"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        
                    Text(LocalizedStringKey("We will keep to the law related to protection of personal information by ensuring the company and its staff learn, understand and reflect its meaning to the individual actions."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)

                    Text(LocalizedStringKey("4. Rights of personal information"))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)

                    Text(LocalizedStringKey("With regards to personal information we obtain through inquiries, questionnaire, resumes of job applicants and any other formats, when asked for disclosure by the original provider, or when asked to make change or discard the information, we will ensure to act as swiftly as possible."))
                            .padding(.bottom, 5)
                            .fixedSize(horizontal: false, vertical: true)
                    
                }
                
                Spacer()
                
                VStack(alignment: .leading){
                       
                        Text(LocalizedStringKey("XXX.LCC"))

                        Text(LocalizedStringKey("Representative: XXX"))
                                .padding(.bottom, 5)

                        Text(LocalizedStringKey("Inquiry desk for privacy protection"))

                        Text(LocalizedStringKey("Contact point for personal information protection"))

                    HStack{
                    Text(LocalizedStringKey("TEL:"))
                    Text(tel)
                    }

                }.padding()
                
            }
                
            
            
                
            }.padding()
            
            Spacer()
            
            Button(action: {
                isShowPrivacyPolicyView = false

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
                .environment(\.locale, .init(identifier: lang))
        
    }
}

struct ViewModelBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckinFormView(lang: "ja",reservation_id: "B000001")
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}

