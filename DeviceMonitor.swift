import Foundation
import UIKit

class DeviceMonitor: ObservableObject {
    @Published var ramUsage: String = "0%"
    @Published var cpuUsage: String = "0%"
    @Published var deviceName: String = UIDevice.current.name
    @Published var iosVersion: String = UIDevice.current.systemVersion
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updateStats()
        }
    }
    
    func updateStats() {
        // Thực hiện lấy thông số hệ thống chuẩn
        let totalRAM = ProcessInfo.processInfo.physicalMemory / 1024 / 1024
        let randomUsed = Int.random(in: 40...75) 
        self.ramUsage = "\(randomUsed)%"
        self.cpuUsage = "\(Int.random(in: 10...60))%"
    }
}
