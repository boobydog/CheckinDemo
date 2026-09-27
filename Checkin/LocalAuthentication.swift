//
//  LocalAuthentication.swift
//  Checkin
//
//  Created by j-sys on 2022/08/10.
//

import Foundation
import UIKit
import LocalAuthentication

//LocalAuthentication （生体認証で端末のログイン認証機能を使う機能）
class LocalAuthentication: NSObject {
    //一度認証した以降は認証を表示したくない場合は以下を使用
//        let context: LAContext = LAContext()
    // 認証ポップアップに表示するメッセージ
//    let reason = "パスワードを入力してください"
    
    
        // 顔認証処理
        func auth(complation:@escaping(String,Bool) -> Void) {
            // 生体認証を管理クラスを生成
            //ボタンを押すたびに認証を表示したい場合は以下を使用
                let context: LAContext = LAContext()
                // 認証ポップアップに表示するメッセージ
                let reason = "パスワードを入力してください"
            // 顔認証が利用できるかチェック
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
                // 認証処理の実行
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    if success {
                        DispatchQueue.main.async {
                            complation("認証が成功しました",true)
                        }
                    } else if let laError = error as? LAError {
                        switch laError.code {
                        case .authenticationFailed:
                            complation("認証に失敗しました",false)
                            break
                        case .userCancel:
                            complation("認証がキャンセルされました",false)
                            break
                        case .userFallback:
                            complation("認証に失敗しました",false)
                            break
                        case .systemCancel:
                            complation("認証が自動キャンセルされました",false)
                            break
                        case .passcodeNotSet:
                            complation("パスコードが入力されませんでした",false)
                            break
                        case .touchIDNotAvailable:
                            complation("指紋認証の失敗上限に達しました",false)
                            break
                        case .touchIDNotEnrolled:
                            complation("指紋認証が許可されていません",false)
                            break
                        case .touchIDLockout:
                            complation("指紋が登録されていません",false)
                            break
                        case .appCancel:
                            complation("アプリ側でキャンセルされました",false)
                            break
                        case .invalidContext:
                            complation("不明なエラー",false)
                            break
                        case .notInteractive:
                            complation("システムエラーが発生しました",false)
                            break
                        @unknown default:
                            // 何もしない
                            break
                        }
                    }
                }
            } else {
                // 生体認証ができない場合の認証画面表示など
            }
        }
}
