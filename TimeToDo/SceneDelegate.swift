//
//  SceneDelegate.swift
//  TimeToDo
//
//  Created by Minho on 3/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            let vc = MainTabBarViewController()
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("포그라운드로 완전히 돌아옴")
    }

    // 앱이 백그라운드로 빠지기 직전에 호출
    func sceneWillResignActive(_ scene: UIScene) {
        print("백그라운드로 빠지기 전")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sceneWillResignActive"), object: nil)
    }

    // 앱이 다시 포그라운드로 돌아오는 시점
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("포그라운드로 돌아올 예정")
        NotificationCenter.default.post(name: NSNotification.Name("sceneWillEnterForeground"), object: nil)
    }

    // 앱이 완전히 백그라운드로 빠졌을 때
    func sceneDidEnterBackground(_ scene: UIScene) {
        print("백그라운드로 완전히 빠짐")
    }


}

