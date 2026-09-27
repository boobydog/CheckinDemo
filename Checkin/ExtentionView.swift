//
//  ExtentionView.swift
//  Checkin
//
//  Created by j-sys on 2022/08/18.
//
//各画面共通で利用するVIEW

import SwiftUI
import UIKit

//戻るボタンのカスタム
extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}

struct CustomBackButton: ViewModifier {
    
    @Environment(\.presentationMode) var presentaion

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                
                            self.presentaion.wrappedValue.dismiss()
            }){
                HStack{
                    Image(systemName:"arrow.left")
                    Text(LocalizedStringKey("Go Back"))
                }
                
            })
    }
}

//通知Alert
struct OverlayView: View {
    @Binding var isPresented: Bool
    @Binding var message: String
    
    var body: some View {
        Text(LocalizedStringKey(message))
                   .font(.subheadline)
                   .frame(width: 300, height: 100)
                   .frame(width: 300)
                   .foregroundColor(Color.red)
                   .background(Color.white)
                   .cornerRadius(10)
//                   .shadow(color: Color(red: 0.85, green: 0.85, blue: 0.85), radius: 20)
                   .transition(.move(edge: .top))
                   .padding()
    }
}


