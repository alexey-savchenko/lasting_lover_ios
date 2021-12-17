//
//  AppDelegate.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator!
  private let disposeBag = DisposeBag()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
//
		appCoordinator = AppCoordinator(window: window!)
		appCoordinator.start().subscribe().disposed(by: disposeBag)
		appStore.dispatch(.didFinishLaunchingWithOptions)
//		let c = SnapshotController<StarterPurchaseScreenView>()
//    window?.rootViewController = c
//    window?.makeKeyAndVisible()
    
    return true
  }
	
	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {
		let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
		print("Push notification token - \(token)")
		Current.localStorageService().notificationsToken = token
	}
	
	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error
	) {
		print(#function + " \(error.localizedDescription)")
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		appStore.dispatch(.applicationDidBecomeActive)
	}
}
