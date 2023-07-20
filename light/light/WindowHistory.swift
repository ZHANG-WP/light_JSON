//
//  WindowHistory.swift
//  light
//
//  Created by Demeter on 2023/7/20.
//

import SwiftUI

struct Window {
    var status: Bool
    var timestamp: Date
    var username: String
}

struct WindowHistory: View {
    var window: [Window]

    var body: some View {
        NavigationView {
            VStack {
                if window.isEmpty {
                    Text("尚無開關歷史紀錄")
                } else {
                    List {
                        ForEach(window.reversed(), id: \.timestamp) { record in
                            VStack(alignment: .leading) {
                                Text("\(record.status ? "開啟" : "關閉")")
                                Text("\(formatDate(record.timestamp))")
                                Text("\(record.username)")
                            }
                        }
                    }
                }
            }
        }
    }

    // 格式化日期
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

