///
//  AppDelegate.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit
import SciChart

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: DashBoardController())
        
        let licencing:String = "<LicenseContract>" +
        "<Customer>nguyendangkhoa96nt@gmail.com</Customer>" +
        "<OrderId>Trial</OrderId>" +
        "<LicenseCount>1</LicenseCount>" +
        "<IsTrialLicense>true</IsTrialLicense>" +
        "<SupportExpires>05/06/2018 00:00:00</SupportExpires>" +
        "<ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode>" + "<KeyCode>71790d17bca7427754d55503db63a0053e13608dd776a101a4d33a9edcf926f892a8686aa13e0a5090ca01bfd5cd024e4c9c1e02a95d89417590efb83b2069ae8f49ca72a49c8bb00759ee83f2f33e4bb70f29fc2fd4e742419674d4c17172e6e070113db3af1c4554983bba45962b0eea3bfc7504291bf55a8a4c5e2ed7f5f90bef245ff3565081137b7c149d7f43e2dc9da646f04d102c06266605c8afa3251e67ac7b47c7aae41f61e28a14fdccc399ef</KeyCode>" +
        "</LicenseContract>"

        
        SCIChartSurface.setRuntimeLicenseKey(licencing)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

