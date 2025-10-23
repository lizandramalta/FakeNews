//
//  FakeNewsApp.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import SwiftUI
import TipKit

@main
struct FakeNewsApp: App {
    private let push = PushSubscriptionManager()
    private let ckClient = DefaultCloudKitClient()
    
    @State private var vm: NewsViewModel

    init() {
        _vm = State(initialValue: NewsViewModel(repo: CloudKitNewsRepository(ck: ckClient)))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .onAppear {
                    push.requestNotificationPermissions()
                }
                .task {
//                    try? Tips.resetDatastore()
                    try? Tips.configure([
//                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}
