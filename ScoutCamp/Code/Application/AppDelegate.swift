//
//  AppDelegate.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 24/11/2023.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appDIContainer = AppDIContainer()
    private var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        setupServiceContainer()
        RemoteConfigManager.shared.setup()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()

        return true
    }
}

private extension AppDelegate {
    func setupServiceContainer() {
        ServiceContainer.register(type: TeamsServiceProtocol.self, TeamsService())
        ServiceContainer.register(type: CategoriesServiceProtocol.self, CategoriesService())
        ServiceContainer.register(type: CategorizationPeriodsServiceProtocol.self, CategorizationPeriodsService())
        ServiceContainer.register(type: StorageManagerProtocol.self, StorageManager())
    }
}
