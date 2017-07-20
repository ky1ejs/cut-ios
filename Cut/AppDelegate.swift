//
//  AppDelegate.swift
//  Cut
//
//  Created by Kyle McAlpine on 02/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 50 MB
        ImageCache.default.maxDiskCacheSize = UInt(50 * 1024 * 1024)
        // 3 days
        ImageCache.default.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 3)
        
        let tabBar = UITabBarController(nibName: nil, bundle: nil)
        tabBar.viewControllers = [FilmTVC(), FeedTVC(), SearchVC(), ProfileVC()].map(UINavigationController.init)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, error in })
        application.registerForRemoteNotifications()
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if DEBUG
            print(String(hexData: deviceToken))
        #endif
        _ = UploadPushToken(token: String(hexData: deviceToken)).call().subscribe()
    }
}
