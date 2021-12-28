//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Aung Kyaw Phyo on 12/27/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appNavigation: AppNevigation?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let window = window {
            appNavigation = AppNevigation(window: window)
        }
        window?.makeKeyAndVisible()
        return true
    }
}

