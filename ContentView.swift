import SwiftUI

struct ContentView: View {
    @StateObject var monitor = DeviceMonitor()
    @State private var selectedTab = 0
    @State private var toastMsg: String? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                if selectedTab == 0 {
                    HomeView(monitor: monitor)
                } else {
                    OptimizerView(trigger: showToast)
                }

                // Tab Bar
                HStack {
                    TabItem(title: "Home", icon: "house.fill", isSel: selectedTab == 0) { selectedTab = 0 }
                    TabItem(title: "Settings", icon: "gearshape.fill", isSel: selectedTab == 1) { selectedTab = 1 }
                }
                .padding(.top, 12).background(Color(white: 0.08).edgesIgnoringSafeArea(.bottom))
            }

            // Dynamic Island Toast
            if let msg = toastMsg {
                VStack {
                    HStack(spacing: 12) {
                        Image(systemName: "bolt.circle.fill").foregroundColor(.cyan)
                        Text(msg).font(.system(size: 16, weight: .black)).foregroundColor(.white)
                    }
                    .padding(.vertical, 18).padding(.horizontal, 30)
                    .background(Capsule().fill(Color(white: 0.12)).shadow(color: .cyan.opacity(0.3), radius: 10))
                    .padding(.top, 50)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }

    func showToast(_ msg: String) {
        withAnimation(.spring()) { toastMsg = msg }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            withAnimation { toastMsg = nil }
        }
    }
}

// MÀN HÌNH HOME
struct HomeView: View {
    @ObservedObject var monitor: DeviceMonitor
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Dashboard").font(.system(size: 34, weight: .black)).padding(.top, 40)
                
                VStack(spacing: 15) {
                    InfoTile(t: "Device", v: monitor.deviceName, i: "iphone", c: .blue)
                    InfoTile(t: "System", v: "iOS \(monitor.iosVersion)", i: "v.circle.fill", c: .purple)
                    HStack {
                        StatBox(t: "CPU", v: monitor.cpuUsage, i: "cpu", c: .red)
                        StatBox(t: "RAM", v: monitor.ramUsage, i: "memorychip", c: .green)
                    }
                }
            }
            .padding()
        }
    }
}

// MÀN HÌNH SETTINGS (30 NÚT)
struct OptimizerView: View {
    var trigger: (String) -> Void
    let grid = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Optimizer").font(.system(size: 34, weight: .black)).padding(.top, 40)
                
                Group {
                    Text("GAMING PERFORMANCE").font(.caption).bold().foregroundColor(.gray)
                    LazyVGrid(columns: grid, spacing: 12) {
                        OptiBtn(t: "Unlock 60FPS", i: "bolt.fill", c: .yellow) { trigger("60 FPS Enabled") }
                        OptiBtn(t: "Unlock 90FPS", i: "bolt.shield.fill", c: .orange) { trigger("90 FPS Enabled") }
                        OptiBtn(t: "Unlock 120FPS", i: "speedometer", c: .red) { trigger("120 FPS Enabled") }
                        OptiBtn(t: "Anti-Lag", i: "shield.fill", c: .green) { trigger("Lag Fixed") }
                    }
                }

                Group {
                    Text("SYSTEM CLEANER").font(.caption).bold().foregroundColor(.gray)
                    VStack(spacing: 8) {
                        ListRow(t: "Clear System Cache", i: "trash.fill") { trigger("Cache Cleared") }
                        ListRow(t: "Kill Background", i: "xmark.circle.fill") { trigger("Apps Killed") }
                        ListRow(t: "Deep Clean RAM", i: "memorychip.fill") { trigger("RAM Boosted") }
                        ListRow(t: "Fix Touch Delay", i: "hand.tap.fill") { trigger("Touch Optimized") }
                        ListRow(t: "GPU Boost", i: "hare.fill") { trigger("GPU Active") }
                        ListRow(t: "Clean Temp Files", i: "folder.fill") { trigger("Temp Deleted") }
                        ListRow(t: "DNS Flush", i: "network") { trigger("DNS Refreshed") }
                        ListRow(t: "Battery Calibrate", i: "battery.100") { trigger("Battery Optimized") }
                        ListRow(t: "Thermal Cooling", i: "thermometer.snowflake") { trigger("Cooling Active") }
                        ListRow(t: "Speed Up UI", i: "sparkles") { trigger("UI Fast Mode") }
                    }
                }
            }
            .padding()
        }
    }
}

// COMPONENTS
struct InfoTile: View {
    var t, v, i: String; var c: Color
    var body: some View {
        HStack {
            Image(systemName: i).foregroundColor(c).font(.title3)
            Text(t).foregroundColor(.gray)
            Spacer()
            Text(v).bold()
        }.padding().background(Color(white: 0.1)).cornerRadius(12)
    }
}

struct StatBox: View {
    var t, v, i: String; var c: Color
    var body: some View {
        VStack(alignment: .leading) {
            Label(t, systemImage: i).font(.caption).foregroundColor(c)
            Text(v).font(.title2).bold()
        }.frame(maxWidth: .infinity, alignment: .leading).padding().background(Color(white: 0.1)).cornerRadius(12)
    }
}

struct OptiBtn: View {
    var t, i: String; var c: Color; var a: () -> Void
    var body: some View {
        Button(action: a) {
            VStack {
                Image(systemName: i).font(.title2).foregroundColor(c)
                Text(t).font(.system(size: 12, weight: .bold)).foregroundColor(.white)
            }.frame(maxWidth: .infinity).frame(height: 85).background(Color(white: 0.12)).cornerRadius(15)
        }
    }
}

struct ListRow: View {
    var t, i: String; var a: () -> Void
    var body: some View {
        Button(action: a) {
            HStack {
                Image(systemName: i).foregroundColor(.cyan).frame(width: 30)
                Text(t).foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right").font(.caption).foregroundColor(.gray)
            }.padding().background(Color(white: 0.1)).cornerRadius(10)
        }
    }
}

struct TabItem: View {
    var title, icon: String; var isSel: Bool; var act: () -> Void
    var body: some View {
        Button(action: act) {
            VStack { Image(systemName: icon); Text(title).font(.caption2) }
            .foregroundColor(isSel ? .cyan : .gray).frame(maxWidth: .infinity)
        }
    }
}
