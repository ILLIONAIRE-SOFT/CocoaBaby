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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(NSLocalizedString("Alert.AlreadyLinked", comment: ""))
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Database.database().isPersistenceEnabled = false
        
//        if let uid = Auth.auth().currentUser?.uid {
//            let babyRef = Database.database().reference(withPath: "babies/\(uid)")
//            babyRef.keepSynced(true)
//            
//            let diaryRef = Database.database().reference(withPath: "diaries/\(uid)")
//            diaryRef.keepSynced(true)
//        }
        
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
        
        // 실행안됨
//        if let token = Messaging.messaging().apnsToken {
//            let tokenString = token.reduce("", {$0 + String(format: "%02X", $1)})
//            print("APN token: \(tokenString)")
//        }
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // 앱이 꺼져있을 때 처리 필요
        if let tabBarVC = self.window?.rootViewController as? UITabBarController {
            tabBarVC.selectedIndex = 1
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([UNNotificationPresentationOptions.alert,
                           UNNotificationPresentationOptions.badge])
    }
}

