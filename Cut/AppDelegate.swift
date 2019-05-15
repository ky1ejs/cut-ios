//
//  AppDelegate.swift
//  Cut
//
//  Created by Kyle McAlpine on 02/03/2017.
//  Copyright © 2017 Kyle McAlpine. All rights reserved.
//

import UIKit
import Kingfisher
import Bugger
import BuggerImgurStore
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Kingfisher
        ImageCache.default.maxDiskCacheSize         = 50 * 1024 * 1024 // 50 MB
        ImageCache.default.maxCachePeriodInSecond   = 60 * 60 * 24 * 3 // 3 days
        
        // Bugger
        Bugger.with(config: BuggerConfig.cutConfig)
        
        let tabBar = UITabBarController(nibName: nil, bundle: nil)
        tabBar.viewControllers = [FilmTVC(), FeedTVC(), SearchVC(), CurrentUserVC()].map(UINavigationController.init)
        
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
