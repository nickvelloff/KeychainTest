//
//  AppDelegate.swift
//  KeychainTest
//
//  Created by Nicholas Velloff on 1/17/15.
//  Copyright (c) 2015 The Experiment. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("93ef2e0b6cd21b511f30445318e08cc5")
        BITHockeyManager.sharedHockeyManager().startManager()
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation()

        // STORE THE VALUE
        doWriteValue()
        
        // RETREIVE THE VALUE
        doRetrieveWrittenValue()
        
        
        return true
    }
    
    func doWriteValue() {
        
        let key = "Full Name";
        let service = NSBundle.mainBundle().bundleIdentifier!
        /* TODO: Place your own team ID here */
        let accessGroup = "8DT848T694.*"
        
        /* First delete the existing one if one exists. We don't have to do this
        but SecItemAdd will fail if an existing value is in the keychain. */
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            
            kSecAttrService as NSString : service,
            kSecAttrAccessGroup as NSString : accessGroup,
            kSecAttrAccount as NSString : key
            ] as NSDictionary
        
        
        SecItemDelete(query)
        
        /* Then write the new value in the keychain */
        let value = "Steve Jobs"
        let valueData = value.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        let secItem = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            
            kSecAttrService as NSString : service,
            kSecAttrAccount as NSString : key,
            kSecAttrAccessGroup as NSString : accessGroup,
            kSecValueData as NSString : valueData!,
            ] as NSDictionary
        
        var result: Unmanaged<AnyObject>? = nil
        let status = Int(SecItemAdd(secItem, &result))
        
        switch status{
        case Int(errSecSuccess):
            println("Successfully stored the value")
        case Int(errSecDuplicateItem):
            println("This item is already saved. Cannot duplicate it")
        default:
            println("An error occurred with code \(status)")
        }
    }
    
    func doRetrieveWrittenValue() {
        let key = "Full Name"
        
        /* This is the bundle ID of the app that wrote the data to the keychain.
        This is NOT this app's bundle ID */
//        let service = "com.pixolity.ios.cookbook.app"
        let service = NSBundle.mainBundle().bundleIdentifier!
        
        let accessGroup = "8DT848T694.*"
        
        let query = [
            kSecClass as NSString :
                kSecClassGenericPassword as NSString,
            
            kSecAttrService as NSString : service,
            kSecAttrAccessGroup as NSString : accessGroup,
            kSecAttrAccount as NSString : key,
            kSecReturnData as NSString : kCFBooleanTrue,
            ] as NSDictionary
        
        
        var returnedData: Unmanaged<AnyObject>? = nil
        let results = Int(SecItemCopyMatching(query, &returnedData))
        
        if results == Int(errSecSuccess){
            
            let data = returnedData!.takeRetainedValue() as NSData
            
            let value = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Value = \(value)")
            
        } else {
            println("Error happened with code: \(results)")
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

