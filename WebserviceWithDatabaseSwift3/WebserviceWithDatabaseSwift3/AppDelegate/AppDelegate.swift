//
//  AppDelegate.swift
//  WebserviceWithDatabaseSwift3


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupRechablity()
               return true
    }
    
    // MARK: - setupRechablity
    func setupRechablity() {
        Constant.reachability = Reachability.init()
        
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: Constant.reachability)
        
        NotificationCenter.default.addObserver(self,selector: #selector(AppDelegate.reachabilityChanged), name: ReachabilityChangedNotification, object: Constant.reachability)
        
        do { try Constant.reachability!.startNotifier()
        } catch { print("cant access") }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
                Constant.isOnWiFi = true
            } else {
                print("Reachable via Cellular")
                Constant.isOnWiFi = false
            }
            Constant.isReachable = true
        } else {
            print("Not reachable")
            Constant.isReachable = false
            Constant.isOnWiFi = false
        }
    }
}
