//
//  AdminMenuView.swift
//  Checkin
//
//  Created by j-sys on 2022/07/05.
//
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import GoogleAPIClientForREST
import GTMSessionFetcher
import CoreData
import UIKit
import Network


struct AdminMenuView: View {
    @EnvironmentObject var networkState: MonitoringNetworkStateModel
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var vm: GoogleSigninModel
    @FetchRequest  var reservationItems: FetchedResults<Reservation>
    @FetchRequest  var checkinItems: FetchedResults<Checkin>
    
    @State var isShowAdminHelpSheet = false
    
    //Google Drive用変数
//    var googleUser: GIDGoogleUser?
    @State var isButtonDisabled : Bool = false
    @State var uploadFolderID: String?
    
    @State var isShowReservationListView:Bool = false
    @State var isShowCheckinListView:Bool = false
    @State var isShowReservationAlertView:Bool = false
    @State var isShowChekcinExportAlertView:Bool = false
    @State var isShowCheckinDeleteAlertView:Bool = false
    @State var isShowcompleteAlertView:Bool = false
    @State var isShowGoogleSignOutAlertView:Bool = false
    
    @State var alertMessage:String = ""
    
//    var alertItem:Alert
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
            
            self._reservationItems = FetchRequest(
                            entity: Reservation.entity(),
                            sortDescriptors: [NSSortDescriptor(keyPath: \Reservation.booking_id, ascending: true)],
                            predicate:nil,
                            animation: .default
                        )
            self._checkinItems = FetchRequest(
                            entity: Checkin.entity(),
                            sortDescriptors: [NSSortDescriptor(keyPath: \Checkin.insert_at, ascending: true)],
                            predicate:nil,
                            animation: .default
                        )

//            checkNetWorkAvailable()
           
        }
    
    
    fileprivate func login()  {
        if(!vm.isLoggedIn){
            vm.signIn()
        }
      }
    
    fileprivate func SignInButton() -> some View {
          Button(action: {
              vm.signIn()
          }) {
              Image(systemName: "lightbulb")
              Text("Google Sign In")
                  
          }
          .frame(width: 300, height: 60, alignment: .center)
          .accentColor(Color.blue)
          .background(Color.primary)
          .disabled(!vm.isConnected)
          .cornerRadius(10)
      }
      
      fileprivate func SignOutButton() -> some View {
          Button(action: {
              isShowGoogleSignOutAlertView = true
          }) {
              Image(systemName: "lightbulb")
              Text("Google Sign Out")
          }
          .frame(width: 300, height: 60, alignment: .center)
          .accentColor(Color.white)
          .background(!vm.isButtonDisabled ? Color.blue: Color.gray)
          .cornerRadius(10)
          .disabled(vm.isButtonDisabled)
          .alert(isPresented: $isShowGoogleSignOutAlertView) {
              return Alert(title: Text("Googleからサインアウト"),
                                message: Text("サインアウトすると\n管理画面の操作に制限がかかります。\nサインアウトを実行しますか？？"),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .default(Text("サインアウト"),
                                              action: {
                  vm.signOut()
              }))
      }
      }
    
    fileprivate func SwapReservationdataButton() -> Button<Text> {
        Button(action: {
            vm.signOut()
        }) {
            Text("Google Sign Out")
        }
    }
    
    
    var body: some View {
//        スクリーンサイズ取得
        let bounds = UIScreen.main.bounds

        VStack(alignment:.center){
        
        ZStack {

            if isShowcompleteAlertView {
                OverlayView(isPresented: $isShowcompleteAlertView,message:$alertMessage)
                    .position(x:bounds.width / 2,y:30)
            }
    }.frame(width: bounds.width, height: 60)
            
            Spacer()
            
        VStack{
//            if isShowcompleteAlertView {
//                OverlayView(isPresented: $isShowcompleteAlertView)
//                    .position(x:50,y:20)
//            }
            AdminHelpView()
                .frame(width: 700,height: 100,alignment: .topTrailing)
            
            HStack{
                Text("管理メニュー")
            Button(action: {
                vm.errorMessage = ""
                vm.check()
            }){
                Image(systemName: "arrow.clockwise")
                Text("更新")
                
            }
            
           
            }
//            Spreadsheetから値を取得し　Coredata 予約データを更新する
            Button(action: {
                DispatchQueue.global().async {
                    print ("start view que")
                    
                    DispatchQueue.main.sync {
                        vm.reservationItems = []
                                    }
                    
                    DispatchQueue.main.sync {
                        print("execute  start importReservation()")
                        vm.getReservationData()
                        vm.checkStatus()
                        print("execute  end importReservation()")
                    }
                    
                    DispatchQueue.main.sync {
                        isShowReservationAlertView = true
                                    }
                
                    
                    }
                    
                    print ("end view que")
                 
            }) {
                Text("予約データ受信")
                    .padding()
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(!vm.isButtonDisabled ? Color.blue: Color.gray)
            .cornerRadius(10)
            .disabled(vm.isButtonDisabled)
            .alert(isPresented: $isShowReservationAlertView) {
                return Alert(title: Text("予約データ受信"),
                                  message: Text("アプリ内の予約データは削除し\nSpreadsheetから\n予約データを受信します。\n\nチェックイン済の予約データも\n上書きされます。\nよろしいですか？？"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .default(Text("実行する"),
                                                action: {
                    deleteAllReservation ()
                    
                    if  writeReservation() {
//                        Alert表示処理　成功
                        withAnimation(.easeOut(duration: 0.3)) {
                        isShowcompleteAlertView = true
                            alertMessage = "処理が完了しました。"
                        }
                        //3秒後に閉じる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn(duration: 0.3)) {
                           isShowcompleteAlertView = false
                                
                           }
                        
                       }
                        
                    } else {
//                        Alert表示処理　失敗
                        withAnimation(.easeOut(duration: 0.3)) {
                        isShowcompleteAlertView = true
                            alertMessage = "処理に失敗しました。"
                        }
                        //3秒後に閉じる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn(duration: 0.3)) {
                           isShowcompleteAlertView = false
                                
                           }
                        
                       }
                        
                    }
                    
                    
                }))
                }
//            Coredata チェックインデータを Spreadsheetにアップロードする
            Button(action: {
                
//                if !
                vm.checkStatus()
//                {
//                    return
//                }
                
                isShowChekcinExportAlertView = true
            }) {
                Text("チェックイン済入力データ送信")
                    .padding()
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(!vm.isButtonDisabled ? Color.blue: Color.gray)
            .cornerRadius(10)
            .disabled(vm.isButtonDisabled)
            .alert(isPresented: $isShowChekcinExportAlertView) {
                return Alert(title: Text("チェックイン済入力データ送信を実行"),
                                  message: Text("チェックイン済の入力データを\nSpreadSheetに送信します。\n実行してもアプリ内のデータは\n削除されません。\n\nアプリ内のチェックイン済入力データを\n削除したい場合は\n「チェックイン済入力データ全削除」\nボタンから実行してください。"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .default(Text("実行する"),
                                                action: {
                
                    login()
                    if !updateCheckinData() {
                        
    //                        Alert表示処理　失敗
                            withAnimation(.easeOut(duration: 0.3)) {
                            isShowcompleteAlertView = true
                                alertMessage = "処理に失敗しました。"
                            }
                            //3秒後に閉じる
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeIn(duration: 0.3)) {
                               isShowcompleteAlertView = false
                                    
                               }
                            
                           }
                        
                    }
                    populateFolderID() { folderID in
                        if folderID != nil {
                            
                            for (i,item) in checkinItems.enumerated() {
                                if item.residence_country != "日本" {
                                let fileName = "\(item.booking_id ?? "")_\(i)"
                                uploadIdetificationImage(folderID:folderID!,name:fileName,data:item.identification)
                            print("folderID:\(folderID!)")
                                }
                            }
                            
                            
    //                        Alert表示処理　成功
                            withAnimation(.easeOut(duration: 0.3)) {
                            isShowcompleteAlertView = true
                                alertMessage = "処理が完了しました。"
                            }
                            //3秒後に閉じる
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeIn(duration: 0.3)) {
                               isShowcompleteAlertView = false
                                    
                               }
                            
                           }
                            
                            
                        } else {
                           
    //                        Alert表示処理　失敗
                            withAnimation(.easeOut(duration: 0.3)) {
                            isShowcompleteAlertView = true
                                alertMessage = "処理に失敗しました。"
                            }
                            //3秒後に閉じる
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeIn(duration: 0.3)) {
                               isShowcompleteAlertView = false
                                    
                               }
                            
                           }
                            // Folder already exists
                            throw NSError(domain: "error", code: -1, userInfo: nil) // NSErrorでエラーを発生させる
                        }
                        
                        
                        
                    }
                
                }))
                }
//            Coredata 予約データを一覧で表示する
            Button(action: {
                isShowReservationListView = true
            }) {
                Text("予約データ一覧")
                    .padding()
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .sheet(isPresented: $isShowReservationListView) {
                ReservationListView()
            }
            
//            Coredata チェックインデータを一覧で表示する
            Button(action: {
                isShowCheckinListView = true
            }) {
                Text("チェックイン済入力データ一覧")
                    .padding()
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .sheet(isPresented: $isShowCheckinListView) {
                CheckinListView()
            }
            
//          CoreData  チェックインデータをすべて削除する
            Button(action: {
                isShowCheckinDeleteAlertView = true
            }) {
                Text("チェックイン済入力データ全削除")
                    .padding()
            }
            .frame(width: 300, height: 60, alignment: .center)
            .accentColor(Color.white)
            .background(Color.blue)
            .cornerRadius(10)
            .alert(isPresented: $isShowCheckinDeleteAlertView) {
                return Alert(title: Text("チェックイン済入力データの全削除"),
                                  message: Text("アプリ内のチェックイン済入力データを\nすべて削除します。\n\n一度削除するともとに戻せません。\nよろしいですか？？"),
                      primaryButton: .cancel(Text("キャンセル")),
                      secondaryButton: .destructive(Text("削除する"),
                                                action: {
                    if deleteAllCheckin () {
                        withAnimation(.easeOut(duration: 0.3)) {
                        isShowcompleteAlertView = true
                            alertMessage = "処理が完了しました。"
                        }
                        //3秒後に閉じる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn(duration: 0.3)) {
                           isShowcompleteAlertView = false
                                
                           }
                        
                       }
                        
                    } else {
                        withAnimation(.easeOut(duration: 0.3)) {
                        isShowcompleteAlertView = true
                            alertMessage = "処理に失敗しました。"
                        }
                        //3秒後に閉じる
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeIn(duration: 0.3)) {
                           isShowcompleteAlertView = false
                                
                           }
                        
                       }
                        
                    }
                    
                }))
                }
//            if(vm.errorMessage == "") {
                    if(vm.isLoggedIn){
                        SignOutButton()
                        
                    }else{
                        SignInButton()
                    }
//            }
                    Text(vm.errorMessage)
    
        }
            Spacer()
            }
    }
    
    
//    func checkNetWorkAvailable() -> Bool{
//        var result = true
//        vm.errorMessage = ""
//        vm.isLoggedIn = false
//        vm.check()
////    print("vm.isError\(vm.isError)")
//    print("vm.isLoggedIn\(vm.isLoggedIn)")
//
//        if (vm.errorMessage != "" || !vm.isLoggedIn ){
//            vm.isButtonDisabled = true
//        result = false
//    } else {
//        vm.isButtonDisabled = false
//        result = true
//    }
//        print("isButtonDisabled:\(isButtonDisabled)")
//        return result
//    }
    
//SpreadSheet「Reservation」から値を取得し Core Data Bookingにレコードを追加する
    func writeReservation () -> Bool{
        print("start writeReservation")
        for item in vm.reservationItems {
            let newReservation = Reservation(context: self.viewContext)
           newReservation.id = UUID()
           newReservation.booking_id = item.booking_id
            newReservation.name = item.name
            newReservation.email = item.email
            newReservation.tel = item.tel
            newReservation.address = item.address
            newReservation.checkin_at = item.checkin_at
            newReservation.checkout_at = item.checkout_at
            newReservation.num_of_people = item.num_of_people
            newReservation.num_of_rooms = item.num_of_rooms
            newReservation.room_type = item.room_type
            newReservation.amount = item.amount
            newReservation.key_code = item.key_code
            newReservation.checkin_flag = item.checkin_flag
            newReservation.paid_flag = item.paid_flag
            print("newReservation:\(newReservation)")
                               }
        do{
            try self.viewContext.save()
    //    self.selectFlag = true
            
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
        vm.reservationItems = []
        print("end writeReservation")
        return true
    }
//    CoreData Bookingの予約データをすべて削除する
    func deleteAllReservation (){
        
        print("start deleteReservation")
        for item in reservationItems {
            viewContext.delete(item)
                               }
        do{
            try self.viewContext.save()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
        }
        print("end deleteReservation")
        
    }
    
//    CoreData Checkinのデータをすべて削除する
    func deleteAllCheckin () -> Bool{
        
        print("start deleteCheckin")
        for item in checkinItems {
            viewContext.delete(item)
                               }
        do{
            try self.viewContext.save()
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
        print("end deleteCheckin")
        return true
        
    }
    //    CoreData CheckinのデータをSpreadSheetにアップロード（追加）する
    func updateCheckinData () -> Bool {

        var array:[[Any]] = []
        for item in checkinItems {
            array.append([item.booking_id ?? "",
                          item.residence_country ?? "",
                          item.name ?? "",
                          item.nationality ?? "",
                          item.email ?? "",
                          item.idd_code ?? "",
                          item.tel ?? "",
                          item.address ?? "",
//                          item.insert_at ?? ""
                          "\(dateTimeFormatter.string(from: item.insert_at!))"
                         ]
            )
            
        }
        print("array:\(array)")
        if(vm.isLoggedIn && GIDSignIn.sharedInstance.currentUser != nil){
            
                let user = GIDSignIn.sharedInstance.currentUser
            vm.service.authorizer = user!.authentication.fetcherAuthorizer()
            print (" service.authorizer:\(vm.service)")
            let spreadsheetId = vm.sheetId
            let range = vm.checkinRange
            let valueRange = GTLRSheets_ValueRange.init();
            valueRange.values = array//[["A","B","C"],["D","E","F"]]//[array]
            print (" array:\(array)")
            let query = GTLRSheetsQuery_SpreadsheetsValuesAppend
                .query(withObject: valueRange,spreadsheetId: spreadsheetId, range:range)
            print (" query:\(query)")
            query.valueInputOption = "USER_ENTERED"
    
            print ("start executeQuery")
            vm.service.executeQuery(query) { (ticket, any, error) in
                
                         if let error = error {
                             print(error)
                         
                         }

                         print(ticket)
               
                     }

                     print ("end executeQuery:")
           
            return true
        } else {
            
            return false
        }
        
       

    }
   
//    以下からDriveに証明画像をアップロードする処理
    
//   フォルダが存在するかチェックし、なければ作成する
    func populateFolderID(completion: @escaping (String?) throws -> Void) {
        print("start populateFolderID")
        let targetFolderName = dateFormatter.string(from: Date())
         getFolderID(
            name: targetFolderName,
            service: vm.googleDriveService,
//            user: vm.googleUser!,
            targetDirectoryId :vm.imageDirectoryId) { folderID in
                do{
                    var uploadfolderId : String?
                    self.uploadFolderID = ""
                    print("populateFolderID 実行前 folderID:\(folderID ?? "")")
            if folderID == nil {
                self.createFolder(
                    name: targetFolderName,
                    service: vm.googleDriveService,
                    targetDirectoryId :vm.imageDirectoryId
                ) {
                    self.uploadFolderID = $0
                    uploadfolderId = $0
                    
                    //Createfolderで作成したFolderIDをCallbackの戻り値に設定
                    try? completion(uploadfolderId)
                    print("populateFolderID uploadfolderId:\(uploadfolderId ?? "")")
                    print("populateFolderID createdFolderId:\($uploadFolderID)")
                    
                }
//                try   completion(uploadfolderId)
            } else {
                // Folder already exists
                self.uploadFolderID = folderID
                uploadfolderId = folderID
//                 uploadfolderId = folderID!
//                try   completion(uploadfolderId)
                print("populateFolderID folderID:\(folderID ?? "")")
                print("populateFolderID uploadfolderId:\(uploadfolderId ?? "")")
                try completion(uploadfolderId)
            }
                    print("populateFolderID self.uploadFolderID:\($uploadFolderID)")
                    print("populateFolderID uploadFolderID:\(uploadfolderId ?? "")")
//                    print("populateFolderID self.uploadFolderID:\(uploadfolderId)")
//                try   completion(self.uploadFolderID)
               
//                    try   completion(uploadfolderId)
//                    try   completion(uploadfolderId)
                } catch let error as NSError {
                    print("\(error), \(error.userInfo)")
                }
                
        }
        
        print("end populateFolderID")
    }
    
//   証明画像をアップロードする処理
    func uploadIdetificationImage(folderID:String?,name:String?,data:Data?) {
        print("start uploadIdetificationImage")
//            let fileURL = Bundle.main.url(
//                forResource: "my-image", withExtension: ".png")
       uploadFile(
                name: name!,
                folderID: folderID!,
                mimeType: "image/jpeg",
                data:data!,
                service: vm.googleDriveService){ result in
            print(result)
        }
        print("end uploadIdetificationImage")
        }
    
//フォルダIDを取得する
    func getFolderID(
        name: String,
        service: GTLRDriveService,
//        user: GIDGoogleUser,
        targetDirectoryId :String,
        completion: @escaping (String?) -> Void) {
        print("start getFolderID")
            if(vm.isLoggedIn && GIDSignIn.sharedInstance.currentUser != nil){
                
                let user = GIDSignIn.sharedInstance.currentUser
                service.authorizer = user!.authentication.fetcherAuthorizer()
                print (" service.authorizer:\(vm.service)")
                let query = GTLRDriveQuery_FilesList.query()
                print (" query:\(query)")
                // Comma-separated list of areas the search applies to. E.g., appDataFolder, photos, drive.
                query.spaces = "drive"
                // Comma-separated list of access levels to search in. Some possible values are "user,allTeamDrives" or "user"
                query.corpora = "user"
                query.includeTeamDriveItems = true
                query.supportsTeamDrives = true
                print("getFolderID1")
                let targetDirectory = "'\(targetDirectoryId)' in parents"
//                let targetDirectory = "'root' in parents"
                let withName = "name = '\(name)'" // Case insensitive!
                let foldersOnly = "mimeType = 'application/vnd.google-apps.folder'"
                let trashed = "trashed = false"//ゴミ箱内を検索対象に含めるか
                print("name = '\(name)'")
//            let ownedByUser = "'\(user.profile!.email)' in owners"
            query.q = "\(targetDirectory) and \(withName) and \(foldersOnly) and \(trashed)"//and \(ownedByUser)"
                print("getFolderID2")
                print ("start executeQuery")
                service.executeQuery(query) { (_, result, error) in
                    //            guard error == nil else {
                    //                fatalError(error!.localizedDescription)
                    //            }
                                print("getFolderID3")
                                if let error = error {
                                                print(error.localizedDescription)
                                                return
                                            }
                                                         
                                let folderList = result as! GTLRDrive_FileList
                                
                                // For brevity, assumes only one folder is returned.
                                completion(folderList.files?.first?.identifier)
                            }
                         print ("end executeQuery:")
                print("end getFolderID")
            }
        }

    
//    フォルダが無い場合はフォルダを作成する
    func createFolder(
        name: String,
        service: GTLRDriveService,
        targetDirectoryId :String,
        completion: @escaping (String) -> Void) {
            print("start createFolder")
    
            if(vm.isLoggedIn && GIDSignIn.sharedInstance.currentUser != nil){
                
                let user = GIDSignIn.sharedInstance.currentUser
                service.authorizer = user!.authentication.fetcherAuthorizer()
                print (" service.authorizer:\(vm.service)")
                
                let folder = GTLRDrive_File()
                folder.mimeType = "application/vnd.google-apps.folder"
                folder.name = name
                folder.parents = [targetDirectoryId]
                print (" folder:\(folder)")
                
                // Google Drive folders are files with a special MIME-type.
                let query = GTLRDriveQuery_FilesCreate.query(withObject: folder, uploadParameters: nil)
                print (" query :\(query)")
                print ("start executeQuery")
                service.executeQuery(query) { (_, file, error) in
                    if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                
                let folder = file as! GTLRDrive_File
                completion(folder.identifier!)
            }
                print("end createFolder")
            }

        }
                
//    Driveに証明書画像をアップロードする
    func uploadFile(
        name: String,
        folderID: String,
        mimeType: String,
        data:Data,
        service: GTLRDriveService,
        completion:@escaping (Bool) -> Void
    ){
            print("start uploadFile")
            if(vm.isLoggedIn && GIDSignIn.sharedInstance.currentUser != nil){
                
                let user = GIDSignIn.sharedInstance.currentUser
                service.authorizer = user!.authentication.fetcherAuthorizer()
                print (" service.authorizer:\(vm.service)")
                
//                let data = data
                
                let file = GTLRDrive_File()
                file.name = name
                file.parents = [folderID]
                print (" file:\(file)")
                
                // Optionally, GTLRUploadParameters can also be created with a Data object.
                let uploadParameters = GTLRUploadParameters(data: data, mimeType: mimeType)
                
                let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParameters)
                
                service.uploadProgressBlock = { _, totalBytesUploaded, totalBytesExpectedToUpload in
                    // This block is called multiple times during upload and can
                    // be used to update a progress indicator visible to the user.
                }
                print (" query :\(query)")
                print ("start executeQuery")
                service.executeQuery(query) { (_, result, error) in
                    if let error = error {
                                    print(error.localizedDescription)
                                    return
                                }
                    print("end uploadFile")
                    // Successful upload if no error is returned.
                    completion(true)
            }
                
            }
        

            
            
            
            
    }
    
    
}




struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
    }
}
