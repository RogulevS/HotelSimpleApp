import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let view = MainViewController()
        let presenter = MainPresenter(view: view)
        view.presenter = presenter
        window.rootViewController = UINavigationController(rootViewController: view)
        window.makeKeyAndVisible()
        self.window = window
    }
}
