//
//  ChatWorkModel.swift
//  Checkin
//
//  Created by j-sys on 2022/08/17.
//

import Foundation
import SwiftUI

class ChatWorkModel: NSObject,ObservableObject {
    
//    @Published var message: String?
    
//    init(_ message: String){
//        self.message = message
//
//    }
    
    func sendMessage(message:String,completion: @escaping (Bool,Int,String)->Void)  {
    
        let token = Bundle.main.object(forInfoDictionaryKey:"CHATWORK_TOKEN") as! String
        let roomId = Bundle.main.object(forInfoDictionaryKey:"CHATWORK_ROOM_ID") as! String
        let body = message
        
        var result = false
        var code  = 0
        var message  = ""
        
        
let headers = [
  "Accept": "application/json",
  "Content-Type": "application/x-www-form-urlencoded",
  "X-ChatWorkToken": "\(token)"
]

let postData = NSMutableData(data: "self_unread=0".data(using: String.Encoding.utf8)!)
postData.append("&body=\(body)".data(using: String.Encoding.utf8)!)

let request = NSMutableURLRequest(url: NSURL(string: "https://api.chatwork.com/v2/rooms/\(roomId)/messages")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
request.httpMethod = "POST"
request.allHTTPHeaderFields = headers
request.httpBody = postData as Data

let session = URLSession.shared
let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
  if (error != nil) {
    print(error as Any)
      result = false
      code  = 400
      message  = "SendFailed:URLRequestError"

  } else {
      if  let httpResponse = response as? HTTPURLResponse {
          
          // URLResponseのプロパティ
                  print("response.url = \(String(describing:httpResponse.url))")
                  print("response.mimeType = \(String(describing: httpResponse.mimeType))")
                  print("response.expectedContentLength = \(httpResponse.expectedContentLength)")
                  print("response.textEncodingName = \(String(describing: httpResponse.textEncodingName))")
                  print("response.suggestedFilename = \(String(describing: httpResponse.suggestedFilename ))")


                  // HTTPURLResponseのプロパティ
                  print("response.statusCode = \(httpResponse.statusCode)")
                  print("response.statusCode localizedString=\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")

                  for item in httpResponse.allHeaderFields{
                      print("response.allHeaderFields[\"\(item.key)\"] = \(item.value)")
                  }
          
          if httpResponse.statusCode == 200 {
              result = true
              code  = httpResponse.statusCode
              message  = "SendSuccess:\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
            
              
          }
          else{
              
              result = false
              code  = httpResponse.statusCode
              message  = "SendFailed:\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
           
          }
          
        
      }

  }
    completion(result,code,message)
})

dataTask.resume()
    }

}
