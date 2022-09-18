//
//  URLImageViewModel.swift
//  Checkin
//
//  Created by j-sys on 2022/08/23.
//

import SwiftUI

 class URLImageViewModel: ObservableObject {
    
    @Published var downloadData: Data? = nil
    let url: String
    
    init(url: String, isSync: Bool = false) {
        self.url = url
        if isSync {
            self.downloadImageSync(url: self.url)
        } else {
            self.downloadImageAsync(url: self.url)
        }
    }
    
    func downloadImageAsync(url: String) {
        
        guard let imageURL = URL(string: url) else {
            return
        }
                
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                self.downloadData = data
            }
        }
    }
    
    func downloadImageSync(url: String) {
        
        guard let imageURL = URL(string: url) else {
            return
        }
        
        let data = try? Data(contentsOf: imageURL)
        self.downloadData = data
    }
}
