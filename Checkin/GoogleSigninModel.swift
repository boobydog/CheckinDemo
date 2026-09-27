//
//  GoogleSigninModel.swift
//  Checkin
//
//  Created by j-sys on 2022/07/07.
//

//import UIKit
import SwiftUI
import UIKit
import GoogleSignIn
import GoogleSignInSwift
import GoogleAPIClientForREST
import GTMSessionFetcher
import CoreData
import Network

class GoogleSigninModel:NSObject, ObservableObject{
    @Published var reservationItems: [GoogleReservationSubModel] = []
    @Published var checkinItems: [GoogleCheckinSubModel] = []
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    @Published var isConnected = false
    
    func addCheckintems(
        _ residence_country: String,
        _ name: String,
        _ booking_id: String,
        _ email: String,
        _ tel: String,
        _ nationality: String,
        _ idd_code: String,
        _ address: String,
        _ identification: Data,
        _ insert_at: Date
                  ) {
        self.checkinItems.append(
            GoogleCheckinSubModel(
                residence_country,
                name,
                booking_id,
                email,
                tel,
                nationality,
                idd_code,
                address,
                identification
            ))
    }
//    XCodeの環境変数を読み込む
//    let env = ProcessInfo.processInfo.environment
//    let env = NSProcessInfo.processInfo().environment
//    GoogleCloudConsoleのClientIDを記載
    
//  注意 XCodeの環境変数は本番ビルドでは使用不可のため調査が必要
    var clientID =  Bundle.main.object(forInfoDictionaryKey:"GOOGLE_API_CLIENT_ID") as! String
    //    チェックインや予約を管理している Google Spreadsheet ID
        var sheetId =  Bundle.main.object(forInfoDictionaryKey:"GOOGLE_API_SHEET_ID") as! String
        var reservationRange = Bundle.main.object(forInfoDictionaryKey:"GOOGLE_API_RESERVATION_SHEET_RANGE") as! String
        var checkinRange=Bundle.main.object(forInfoDictionaryKey:"GOOGLE_API_CHECKIN_SHEET_RANGE") as! String
        
    //    身分証明書を格納するGoogleDriveのディレクトリ

        var imageDirectoryId = Bundle.main.object(forInfoDictionaryKey:"GOOGLE_API_IMAGE_DIRECTORY_ID") as! String
        
//    付与したい権限を設定
    var scopes = [kGTLRAuthScopeSheetsSpreadsheets,
                  kGTLRAuthScopeSheetsDrive,
                  kGTLRAuthScopeDrive]

    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var isError: Bool = true
    @Published var isButtonDisabled: Bool = true
    @Published var errorMessage: String = ""
    @Published var googleUser: GIDGoogleUser?
    
    var service = GTLRSheetsService()
    var googleDriveService = GTLRDriveService()
    

//    初期化
    override init(){
        super.init()
        check()
        reservationItems = []
        errorMessage = ""
//        checkNetWorkAvailable()
        
//        ネットワーク監視
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
//                DispatchQueue.main.async {
                    self.isConnected = true
//                }
            } else {
//                DispatchQueue.main.async {
                    self.isConnected = false
//                }
            }
        }
        
    }
    
//    ログイン状態のチェック
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            googleUser = user
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLoggedIn = true
            
            let grantedScopes = user.grantedScopes
                print("grantedScopes:\(grantedScopes!)")
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
        print("self.isLoggedIn:\(self.isLoggedIn)")
        self.checkNetWorkAvailable()
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
                print("\(self.errorMessage)")
            }else{
                self.errorMessage = ""
            }
            
            self.checkStatus()
        }
    }
    
//    GoogleにSignin
    func signIn(){
        
       guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

        let signInConfig = GIDConfiguration.init(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: presentingViewController,
            callback: { user, error in
                if let error = error {
                    self.errorMessage = "error: \(error.localizedDescription)"
                    self.isError = true
                    print("\(self.errorMessage)")
                    self.checkStatus()
                    return
                }
               
                self.isError = false
                self.googleUser = user
                self.addScope()
//                self.checkStatus()
            }
        )
        
//        GIDSignIn.sharedInstance.addScopes(scopes, presenting: presentingViewController) { user, error in
//            guard error == nil else { return }
//            guard let user = user else { return }
//
//            // Check if the user granted access to the scopes you requested.
//        }
        self.checkStatus()
    }
    
//    Scope権限付与
    func addScope(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        let grantedScopes = user.grantedScopes
            print("grantedScopes:\(grantedScopes!)")
//        if grantedScopes == nil || !grantedScopes!.contains(scopes) {
          // Request additional Drive scope.
            GIDSignIn.sharedInstance.addScopes(scopes, presenting: presentingViewController) { user, error in
    //            guard error == nil else { return }
    //            guard let user = user else { return }

                if let error = error {
                    self.errorMessage = "error: \(error.localizedDescription)"
                    self.isError = true
                    print("\(self.errorMessage)")
                    return
                }
    //            self.checkStatus()
            }
//        }
            print("grantedScopes:\(grantedScopes!)")

        }
        self.isError = false
        self.checkStatus()
    }
    
    
    //    GoogleからSignout
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
        print("signout complete")
    }
    
//    予約データの一時データをObjectに入れる
    func addItems(
        _ booking_id: String,
        _ name: String,
        _ email: String,
        _ tel: String,
        _ address: String,
        _ checkin_at: Date,
        _ checkout_at: Date,
        _ num_of_people: Int64,
        _ num_of_rooms: Int64,
        _ room_type: String,
        _ amount:String,
        _ key_code:String,
        _ checkin_flag: Bool,
        _ paid_flag: Bool
    ) {
        self.reservationItems.append(
            GoogleReservationSubModel(
                booking_id,
                name,
                email,
                tel,
                address,
                checkin_at,
                checkout_at,
                num_of_people,
                num_of_rooms,
                room_type,
                amount,
                key_code,
                checkin_flag,
                paid_flag
            ))
    }
    
//    var semaphore = DispatchSemaphore(value: 0)
//    予約データの取得
    func getReservationData() {
//        "Getting sheet data..."
        
        if(self.isLoggedIn && GIDSignIn.sharedInstance.currentUser != nil){
            
                let user = GIDSignIn.sharedInstance.currentUser
               service.authorizer = user!.authentication.fetcherAuthorizer()
            print (" service.authorizer:\(service)")
        let spreadsheetId = sheetId
        let range = reservationRange
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
                .query(withSpreadsheetId: spreadsheetId, range:range)
            print (" query:\(query)")
    
            print ("start executeQuery")
                     self.service.executeQuery(query,
                                          delegate: self,
                                               didFinish: #selector(self.insertResultsToCoreData(ticket:finishedWithObject:error:)))
                     print ("end executeQuery:")

        }
        self.checkStatus()
    }
    
    @objc func insertResultsToCoreData(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRSheets_ValueRange,
                                 error : NSError?) {
//        semaphore.signal()
   //            "Started callback"
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        
               if let error = error {
                   self.errorMessage = "error: \(error.localizedDescription)"
                   self.isError = true
                   print("\(self.errorMessage)")
                   return
               }else{
                   
                   self.isError = false
                     let rows = result.values!

                       for row in rows {
                           var checkinFlag = false
                           var paidFlag = false
                           
                           if row[12] as! String == "済"{
                               checkinFlag = true
                           }
                           
                           if row[13] as! String == "済"{
                               paidFlag = true
                           }
                           
                           self.addItems(
                            row[0] as! String, //booking_id,
                            row[1] as! String , //name,
                            row[2] as! String , //email,
                            row[3] as! String , //tel,
                            row[4] as! String , //address,
                            dateFormatter.date(from: row[5] as! String)!, //checkin_at
                            dateFormatter.date(from: row[6] as! String)!,//checkout_at,
                            Int64((row[7] as! NSString).doubleValue), //num_of_people,
                            Int64((row[8] as! NSString).doubleValue), //num_of_rooms,
                            row[9] as! String ,//room_type,
                            row[10] as! String,//amount
                            row[11] as! String,//key_code
                            checkinFlag as Bool,
                            paidFlag as Bool
                            
                            //row[12] is  Bool, //checkin_flag,
                            //row[13] is  Boolean //paid_flag
                           )
                           
                   print("insertResultsToCoreData_reservationItems.count:\(reservationItems.count)")
                   for item in  reservationItems {
                       print("\(String(describing: item.booking_id))")
                       
                   }
                   
               }
               }
    }
    
    
    func checkNetWorkAvailable(){
        var result = true
        self.errorMessage = ""
//        vm.check()
//    print("vm.isError\(vm.isError)")
    print("vm.isLoggedIn\(self.isLoggedIn)")
        print("self.errorMessage\(self.errorMessage)")
//        print("self.networkState.isConnected \(self.networkState.isConnected)")
        
        if (self.errorMessage != ""){
            result = false
            self.isButtonDisabled = true
        }
        
        if !self.isLoggedIn {
            result = false
            self.errorMessage += "\nGoogleにサインインしていません。"
        }
        
        if !self.isConnected  {
            result = false
            self.errorMessage += "\nネットワークが接続されていません。"
        }
        
        if !result {
            self.isButtonDisabled = true
            
        } else {
            self.errorMessage = ""
            self.isButtonDisabled = false
        
    }
        print("isButtonDisabled:\(self.isButtonDisabled)")
    
    }
   
}

class GoogleReservationSubModel: ObservableObject, Identifiable {
    let id = UUID()
    @Published var booking_id: String?
    @Published var name: String?
    @Published var email: String?
    @Published var tel: String?
    @Published var address: String?
    @Published var checkin_at: Date?
    @Published var checkout_at: Date?
    @Published var num_of_people: Int64
    @Published var num_of_rooms: Int64
    @Published var room_type: String?
    @Published var amount: String?
    @Published var key_code: String?
    @Published var checkin_flag: Bool
    @Published var paid_flag: Bool
    
    init(_ booking_id: String,
         _ name: String,
         _ email: String,
         _ tel: String,
         _ address: String,
         _ checkin_at: Date,
         _ checkout_at: Date,
         _ num_of_people: Int64,
         _ num_of_rooms: Int64,
         _ room_type: String,
         _ amount: String,
         _ key_code:String,
         _ checkin_flag: Bool,
         _ paid_flag: Bool
    ) {
        self.booking_id = booking_id
        self.name = name
        self.email = email
        self.tel = tel
        self.address = address
        self.checkin_at = checkin_at
        self.checkout_at = checkout_at
        self.num_of_people = num_of_people
        self.num_of_rooms = num_of_rooms
        self.room_type = room_type
        self.amount = amount
        self.key_code = key_code
        self.checkin_flag = checkin_flag
        self.paid_flag = paid_flag
    }
}

class GoogleCheckinSubModel: ObservableObject, Identifiable {
    let id = UUID()
    let insert_at = Date()
    @Published var booking_id: String?
    @Published var residence_country: String?
    @Published var name: String?
    @Published var nationality: String?
    @Published var email: String?
    @Published var idd_code: String?
    @Published var tel: String?
    @Published var address: String?
    @Published var identification: Data?


    init(
        _ booking_id: String,
        _ residence_country: String,
        _ name: String,
        _ nationality: String,
         _ email: String,
         _ tel: String,
        _ idd_code: String,
         _ address: String,
        _ identification: Data

    ) {
        self.booking_id = booking_id
        self.residence_country = residence_country
        self.name = name
        self.nationality = nationality
        self.email = email
        self.idd_code = idd_code
        self.tel = tel
        self.address = address
        self.identification = identification

    }
}
