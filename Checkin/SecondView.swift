//
//  SecondView.swift
//  CheckinApp
//
//  Created by j-sys on 2022/06/16.
//

import SwiftUI

struct SecondView: View {
    @ObservedObject var viewModel : ScannerViewModel
    
    
    var body: some View {
        Text("QR Code Scan")

        ZStack {
            // QRコード読み取りView
            QrCodeScannerView()
                .found(r: self.viewModel.onFoundQrCode)
                .interval(delay: self.viewModel.scanInterval)

            VStack {
                VStack {
                    Text(LocalizedStringKey("Keep scanning for QR-codes"))
                        .font(.system(.title, design: .default))
                        .fontWeight(.bold)

                    Spacer()
                    Button(action: {
                        self.viewModel.isShowing = false
                    }) {
                        Text("Close")
                        .font(.system(.title, design: .default))
                        .fontWeight(.bold)
                    }
                    .frame(width: 130, height: 60, alignment: .center)
                    .accentColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                }
               
                .padding(.vertical, 20)
//                .frame(alignment: .bottom)
                
            }.padding()
        }
    }
}
