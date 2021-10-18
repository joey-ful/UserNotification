//
//  EnterWithNotifications - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (didAllow, error) in
            
        })
        UNUserNotificationCenter.current().delegate = self
        
        let content = UNMutableNotificationContent()
        content.title = "Hi there"
        content.body = "This is the letter from England..."
        content.userInfo = ["target_view" : "yellow_view"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if error != nil {
                print(error?.localizedDescription)
           }
        }

        let yellowViewAction = UNNotificationAction(identifier: "YELLOW_ACTION",
              title: "Yellow뷰로 이동",
              options: UNNotificationActionOptions(rawValue: 0))

        let yellowViewCategory =
              UNNotificationCategory(identifier: "YELLOW",
              actions: [yellowViewAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        
        notificationCenter.setNotificationCategories([yellowViewCategory])
    }

//    @IBAction func notify(_ sender: UIButton) {
//        print("notify")
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            guard (settings.authorizationStatus == .authorized) ||
//                  (settings.authorizationStatus == .provisional) else { return }
//
//
//            let content = UNMutableNotificationContent()
//            content.title = "야곰 노티피케이션"
//            content.body = "몇 초 후 알림"
//            content.badge = 1
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
//
//            let uuidString = UUID().uuidString
//            let request = UNNotificationRequest(identifier: uuidString,
//                        content: content, trigger: trigger)
//
//            // Schedule the request with the system.
//            let notificationCenter = UNUserNotificationCenter.current()
//            notificationCenter.add(request) { (error) in
//               if error != nil {
//                    print(error?.localizedDescription)
//               }
//            }
//
//        }
//
//    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           didReceive response: UNNotificationResponse,
           withCompletionHandler completionHandler:
             @escaping () -> Void) {
           
       let userInfo = response.notification.request.content.userInfo
       let targetView = userInfo["target_view"] as! String
       let title = response.notification.request.content.title
       let body = response.notification.request.content.body
        
//        let yellowView = storyboard?.instantiateViewController(withIdentifier: "yellowView") as! YellowViewController
//        present(yellowView, animated: true, completion: nil)
        
        tabBarController?.dismiss(animated: false, completion: nil)
        tabBarController?.selectedIndex = 1
        let navi = tabBarController?.viewControllers?[1] as? UINavigationController
        navi?.topViewController?.performSegue(withIdentifier: "moveToYellow", sender: nil)

//        yellowView.titleLabel.text = "제목"
//        yellowView.bodyLabel.text = "내용"
        
       switch response.actionIdentifier {
       case "YELLOW_ACTION":
        print("yellow")
        
       default:
          break
       }

       completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        let settingsViewController = UIViewController()
        settingsViewController.view.backgroundColor = .gray
        self.present(settingsViewController, animated: true, completion: nil)
        
    }
}
