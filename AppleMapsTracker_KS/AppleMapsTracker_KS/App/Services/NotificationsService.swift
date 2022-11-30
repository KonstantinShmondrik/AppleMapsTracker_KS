//
//  NotificationsService.swift
//  AppleMapsTracker_KS
//
//  Created by Константин Шмондрик on 30.11.2022.
//

import Foundation
import UserNotifications

class NotificationsService {
    
    func startfications() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Разрешение не получено")
                return
            }
            
            self.sendNotificatioRequest(content: self.makeNotificationContent(),
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
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "Пора размяться"
        content.subtitle = "Начни прогулку"
        content.body = "С каждым шагом ты становишься сильнее"
        content.badge = 1
        
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
