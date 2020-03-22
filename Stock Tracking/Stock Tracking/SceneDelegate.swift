//
//  SceneDelegate.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import UIKit
import SwiftUI
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, ObservableObject {

    var window: UIWindow?
    
    let category = Categorys(list: [
        CategoryModel(name: "Lebensmittel", products: [
            CategoryProduct(product: ProductModel(name: "Milch", emoji: "🥛", availability: .empty), selected: false),
            CategoryProduct(product: ProductModel(name: "Bread", emoji: "🍞", availability: .empty), selected: false),
            CategoryProduct(product: ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty), selected: false)
        ]),
        CategoryModel(name: "Produkte", products: [
            CategoryProduct(product: ProductModel(name: "Klopapier", emoji: "🥛", availability: .empty), selected: false),
            CategoryProduct(product: ProductModel(name: "Seifen", emoji: "🍞", availability: .empty), selected: false)
        ])
    ])

    func show<V: View>(view: V) {
        self.window?.rootViewController = UIHostingController(rootView: view)
    }
    
    func showMain() {
        self.show(view: ContentView()
            .environmentObject(category)
        )
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

		

		// Ntoifcation Request
		let center = UNUserNotificationCenter.current()
		let options: UNAuthorizationOptions = [.alert, .badge, .sound];
		center.requestAuthorization(options: options) {
		  (granted, error) in
			if !granted {
			  print("Something went wrong")
			}
		}
		
		center.getNotificationSettings { (settings) in
		  if settings.authorizationStatus != .authorized {
			// Notifications not allowed
		  }
		}
		
		
		
        // Create the SwiftUI view that provides the window contents.
        let root: UIViewController
        if !UserDefaults.standard.bool(forKey: "isOnboardingCompleted") {
            root = UIHostingController(rootView: LandingView()
                .environmentObject(self))
        } else {
            root = UIHostingController(rootView: ContentView().environmentObject(category))
        }


        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = root
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

