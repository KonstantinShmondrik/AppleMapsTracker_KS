//
//  NotificationsService.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 30.11.2022.
//

import Foundation
import UserNotifications

class NotificationsService {
    
    func startNatifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificatioRequest(
                content: self.makeNotificationContent(title: "Пора размяться",
                                                      subtitle: "Начни прогулку",
                                                      body: "С каждым шагом ты становишься сильнее",
                                                      badge: nil),
                trigger: self.makeIntervalNotificatioTrigger()
            )
        }
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                print("Разрешение есть")
            case .notDetermined, .ephemeral:
                print("Неясно, есть или нет разрешение")
            case .denied:
                print("Разрешения нет")
            @unknown default:
                print("Неизвесная ошибка")
            }
        }
    }
    
    func makeNotificationContent(title: String,
                                 subtitle: String,
                                 body: String,
                                 badge: Int? ) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge as NSNumber?
        
        return content
    }
    
    func makeIntervalNotificatioTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false )
    }
    
    func sendNotificatioRequest(content: UNNotificationContent,
                                trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alaram",
                                            content: content,
                                            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
