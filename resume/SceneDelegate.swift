import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
        guard let uiWindowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: uiWindowScene.coordinateSpace.bounds)
        
        window?.windowScene = uiWindowScene
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }
}

