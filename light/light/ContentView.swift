import SwiftUI

struct LightData: Codable {
    var status: Bool
}

struct WindowData: Codable {
    var window_status: Bool
}

class LightViewModel: ObservableObject {
    @Published var isEnable = false
    @Published var switchHistory: [SwitchRecord] = []

    //燈泡寫入JSON
    func writeToJsonFile() {
        let data: [String: Any] = ["status": isEnable]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

            if let jsonFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("status.json") {
                try jsonData.write(to: jsonFileURL)

                //將目前開關狀態、時間戳記和使用者名稱新增到歷史紀錄陣列
                switchHistory.append(SwitchRecord(status: isEnable, timestamp: Date(), username: "123"))
            }
        } catch {
            print("電燈寫入錯誤：\(error.localizedDescription)")
        }
    }

    //讀取燈泡JSON
    func readFromJsonFile() {
        do {
            if let jsonFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("status.json") {
                let jsonData = try Data(contentsOf: jsonFileURL)
                let data = try JSONDecoder().decode(LightData.self, from: jsonData)
                isEnable = data.status
            }
        } catch {
            print("電燈讀取錯誤：\(error.localizedDescription)")
        }
    }
}
class WindowViewModel: ObservableObject {
    @Published var isOn = false
    @Published var window: [Window] = []

    //天窗寫入JSON
    func writeToJsonFile_window() {
        let data: [String: Any] = ["window_status": isOn]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)

            if let jsonFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("window_status.json") {
                try jsonData.write(to: jsonFileURL)

                //將目前開關狀態、時間戳記和使用者名稱新增到歷史紀錄陣列
                window.append(Window(status: isOn, timestamp: Date(), username: "345"))
            }
        } catch {
            print("天窗寫入錯誤：\(error.localizedDescription)")
        }
    }

    //讀取天窗JSON
    func readFromJsonFile_window() {
        do {
            if let jsonFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("window_status.json") {
                let jsonData = try Data(contentsOf: jsonFileURL)
                let data = try JSONDecoder().decode(WindowData.self, from: jsonData)
                isOn = data.window_status
            }
        } catch {
            print("天窗讀取錯誤：\(error.localizedDescription)")
        }
    }
}

@available(iOS 14.0, *)
struct ContentView: View {
    @StateObject private var lightViewModel = LightViewModel()
    @StateObject private var windowViewModel = WindowViewModel()
    //@State private var showHistoryView = false

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: lightViewModel.isEnable ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 100))
                        .foregroundColor(lightViewModel.isEnable ? .yellow : .black)
                    NavigationLink(destination: HistoryView(switchHistory: lightViewModel.switchHistory), label: { //轉到HistoryView
                        Text("電燈")
                        Spacer()
                        Toggle("電燈", isOn: $lightViewModel.isEnable)
                            .padding()
                            .labelsHidden()
                    })
                    /*
                     Button("查看歷史紀錄", action: {
                     showHistoryView = true
                     })
                     .padding()
                     .sheet(isPresented: $showHistoryView) {
                     HistoryView(switchHistory: lightViewModel.switchHistory)
                     } */
                }
                .font(.largeTitle)
                .onAppear(perform: lightViewModel.readFromJsonFile)
                .onChange(of: lightViewModel.isEnable) { newValue in //onChange元素的值被更改
                    lightViewModel.writeToJsonFile()
                }
                VStack {
                    NavigationLink(destination: WindowHistory(window: windowViewModel.window), label: { //轉到HistoryView
                        Text("天窗")
                        Spacer()
                        Toggle("天窗", isOn: $windowViewModel.isOn)
                            .padding()
                            .labelsHidden()
                    })
                }   .font(.largeTitle)
                    .onAppear(perform: windowViewModel.readFromJsonFile_window)
                    .onChange(of: windowViewModel.isOn) { newValue in //onChange元素的值被更改
                        windowViewModel.writeToJsonFile_window()
                    }
            }
        }
    }
}
@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
