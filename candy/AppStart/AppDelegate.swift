//
//  AppDelegate.swift
//  candy
//
//  Created by Erik Perez on 8/3/18.
//  Copyright © 2018 Erik Perez. All rights reserved.
//

import UIKit
import RIBs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootBuilder = RootBuilder(dependency: AppComponent())
        let launchRouter = rootBuilder.build()
        
        self.window = window
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
        
        return true
    }
    
    // MARK: - Private
    
    private var launchRouter: LaunchRouting?

}



