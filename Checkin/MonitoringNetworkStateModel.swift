//
//  MonitoringNetworkStateModel.swift
//  Checkin
//
//  Created by j-sys on 2022/08/14.
//

import Foundation
import Network

class MonitoringNetworkStateModel: ObservableObject {

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    @Published var isConnected = false

    init() {
        monitor.start(queue: queue)

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.async {
                    self.isConnected = true
                }
            } else {
                DispatchQueue.main.async {
                    self.isConnected = false
                }
            }
        }
    }
}

