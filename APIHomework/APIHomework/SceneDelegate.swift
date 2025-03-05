import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let dependencyContainer = DependencyContainer()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if let weatherView = storyboard.instantiateInitialViewController() as? WeatherView {
            print("WeatherView created as Initial View Controller")

            // Pass dependencies via properties
            weatherView.weatherAPI = dependencyContainer.weatherAPI
            weatherView.weatherDataManager = dependencyContainer.weatherDataManager
            weatherView.districts = dependencyContainer.districts

            print("Dependencies set via properties")

            // Set WeatherView as rootViewController
            window?.rootViewController = weatherView
            window?.makeKeyAndVisible()
        } else {
            print("Error: Failed to create WeatherView as Initial View Controller")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called when the scene is released by the system
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene becomes active
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will resign active
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called when the scene moves to the foreground
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called when the scene moves to the background
    }
}
