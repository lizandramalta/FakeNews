//
//  PushSubscriptionManager.swift
//  FakeNews
//
//  Created by Lizandra Malta on 21/10/25.
//

import Foundation
import CloudKit
import SwiftUI

class PushSubscriptionManager {
    private let subscriptionKey = "hasSubscribedToNews"
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { sucess, error in
            if let error = error {
                print("❌ Erro ao autorizar notificações: ", error )
            } else {
                print("✅ Notificações autorizadas com sucesso.")
                
                Task { @MainActor in
                    UIApplication.shared.registerForRemoteNotifications()
                    await self.subscribeIfNeeded()
                }
            }
        }
    }
    
    private func subscribeIfNeeded() async {
        let hasSubscribed = UserDefaults.standard.bool(forKey: subscriptionKey)
        guard !hasSubscribed else {
            print("ℹ️ Usuário já inscrito, ignorando nova subscription.")
            return
        }
        
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(
            recordType: "News",
            predicate: predicate,
            subscriptionID: "news_added_to_database",
            options: .firesOnRecordCreation
        )
        
        let notification = CKSubscription.NotificationInfo()
        notification.titleLocalizationKey = "%1$@"
        notification.titleLocalizationArgs = ["title"]
        notification.alertLocalizationKey = "%1$@"
        notification.alertLocalizationArgs = ["description"]
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        do {
            try await CKContainer.default().publicCloudDatabase.save(subscription)
            UserDefaults.standard.set(true, forKey: subscriptionKey)
            print("✅ Subscription criada com sucesso.")
        } catch {
            print("❌ Erro ao se inscrever nas notificações:", error.localizedDescription)
        }
    }
}
