//
//  AppDelegate.swift
//  CocoaBaby
//
//  Created by Sohn on 02/08/2017.
//  Copyright © 2017 Sohn. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications

enum ShortcutIdentifier: String {
    case First
    case Second
    case Third
    case Fourth
    
    init?(fullType: String) {
        guard let last = fullType.components(separatedBy: ".").last else {
            return nil
        }
        
        self.init(rawValue: last)
    }
    
    var type: String {
        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    var isNeedHandleDiaryResponse: Bool = false
    var isNeedHandleWriteDiaryQuickAction: Bool = false
    var isNeedPresentWriteDiary: Bool = false
    var isNeedDiaryRefresh: Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // For launch with shortcut
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
        }
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // MARK: Firebase disk persistency
        Database.database().isPersistenceEnabled = true
        
        let diariesRef = Database.database().reference(withPath: "diaries")
        let babiesRef = Database.database().reference(withPath: "babies")
        let tipsRef = Database.database().reference(withPath: "tips")
        let userRef = Database.database().reference(withPath: "users")
        diariesRef.keepSynced(true)
        babiesRef.keepSynced(true)
        tipsRef.keepSynced(true)
        userRef.keepSynced(true)
        
        UINavigationBar.appearance().barStyle = .blackOpaque
        
        // MARK: Notification Settings
        if #available(iOS 10.0, *) {
            print("Request Notification Authorization")
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (_, _) in
                
            })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
        // For short cut item wtih app launch
        guard let shortcut = launchedShortcutItem else {
            return
        }
        
        handleShortcutItem(shortcutItem: shortcut)
        
        launchedShortcutItem = nil
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        let post = [UserPayloadName.deviceToken.rawValue:deviceTokenString] as [String:Any]
        
        UserStore.shared.updateUser(post: post) { (userResult) in
            switch userResult {
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        
        guard let authentication = user.authentication else {
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error)
                return
            }
            
            let mainSB = UIStoryboard(name: StoryboardName.main, bundle: nil)
            let viewController = mainSB.instantiateViewController(withIdentifier: StoryboardName.splashViewController)
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
            if let uid = Auth.auth().currentUser?.uid {
                let babyRef = Database.database().reference(withPath: "babies/\(uid)")
                babyRef.keepSynced(true)
                
                let diaryRef = Database.database().reference(withPath: "diaries/\(uid)")
                diaryRef.keepSynced(true)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    // MARK: - User Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if let tabBarVC = self.window?.rootViewController as? UITabBarController {
            // Case: App not terminated
            isNeedDiaryRefresh = true
            tabBarVC.selectedIndex = 0
            tabBarVC.selectedIndex = 1
        } else {
            // Case: App terminated
            isNeedHandleDiaryResponse = true
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,
                           UNNotificationPresentationOptions.badge])
    }
    
    // MARK: Quick Action
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        // general quick actions
        let handleShortcutItem = self.handleShortcutItem(shortcutItem: shortcutItem)
        
        completionHandler(handleShortcutItem)
    }
    
    @discardableResult func handleShortcutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var handled: Bool = false
        
        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else {
            return false
        }
        
        guard let shortCutType = shortcutItem.type as String? else {
            return false
        }
        
        switch shortCutType {
        case ShortcutIdentifier.First.type:
            if let tabBarVC = self.window?.rootViewController as? UITabBarController {
                // Case: app not terminated
                isNeedPresentWriteDiary = true
                tabBarVC.selectedIndex = 0
                tabBarVC.selectedIndex = 1
            } else {
                // Case: launch with quick action
                isNeedPresentWriteDiary = true
                isNeedHandleWriteDiaryQuickAction = true
            }
            
            handled = true
            break
        default:
            break
        }
        
        return handled
            
    }
}
