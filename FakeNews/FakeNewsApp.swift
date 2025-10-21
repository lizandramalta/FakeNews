//
//  FakeNewsApp.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import SwiftUI
import SwiftData

@main
struct FakeNewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: NoticeClass.self)
    }
}
