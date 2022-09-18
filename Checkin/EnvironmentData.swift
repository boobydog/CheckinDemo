//
//  EnvironmentData.swift
//  Checkin
//
//  Created by j-sys on 2022/08/14.
//
//正常に最初の画面に画面遷移するための処理
import Foundation
import SwiftUI

class EnvironmentData: ObservableObject {
    @Published var isNavigationActive: Binding<Bool> = Binding<Bool>.constant(false)
}
