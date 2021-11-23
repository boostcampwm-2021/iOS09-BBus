//
//  SceneDelegate.swift
//  BBus
//
//  Created by Kang Minsang on 2021/10/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var movingStatusWindow: UIWindow?
    var appCoordinator: AppCoordinator?
    private var second = 0

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        sleep(1)
        self.window = UIWindow(windowScene: windowScene)
        self.movingStatusWindow = UIWindow(windowScene: windowScene)
        guard let navigationWindow = self.window,
              let movingStatusWindow = self.movingStatusWindow else { return }
        self.movingStatusWindow?.frame.size = CGSize(width: movingStatusWindow.frame.width, height: movingStatusWindow.frame.height + MovingStatusView.bottomIndicatorHeight)
        self.appCoordinator = AppCoordinator(navigationWindow: navigationWindow, movingStatusWindow: movingStatusWindow)
        appCoordinator?.start()

        self.fireTimer()
    }

    private func fireTimer() {
        let timer = Timer.init(timeInterval: 1, repeats: true) { _ in
            self.second += 1
            
            if self.second % 30 == 0 {
                NotificationCenter.default.post(name: .thirtySecondPassed, object: self)
                self.second = 0
            }
            if self.second % 15 == 0 {
                NotificationCenter.default.post(name: .fifteenSecondsPassed, object: self)
            }
            NotificationCenter.default.post(name: .oneSecondPassed, object: self)
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
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

