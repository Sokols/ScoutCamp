//
//  MainFlowCoordinator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/02/2024.
//

import SwiftUI

protocol MainFlowCoordinatorDependencies {
    func makeHomeScreen() -> UIViewController
    func makeCategorizationScreen(_ navigationController: UINavigationController) -> UIViewController
    func makeMyTeamsScreen() -> UIViewController
    func makeProfileScreen(_ navigationController: UINavigationController) -> UIViewController
}

enum MainTabPage: Int, CaseIterable {
    case home, categorization, myTeams, profile

    init?(index: Int) {
        switch index {
        case 0:
            self = .home
        case 1:
            self = .categorization
        case 2:
            self = .myTeams
        case 4:
            self = .profile
        default:
            return nil
        }
    }

    func pageTitleValue() -> String {
        switch self {
        case .home:
            return "Home"
        case .categorization:
            return "Categorization"
        case .myTeams:
            return "My teams"
        case .profile:
            return "Profile"
        }
    }

    func pageImage() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")
        case .categorization:
            return UIImage(systemName: "doc.fill")
        case .myTeams:
            return UIImage(systemName: "person.3.fill")
        case .profile:
            return UIImage(systemName: "person.crop.circle.fill")
        }
    }
}

final class MainFlowCoordinator: NSObject {

    private weak var navigationController: UINavigationController?
    private let dependencies: MainFlowCoordinatorDependencies

    var tabBarController: UITabBarController

    init(
        navigationController: UINavigationController?,
        dependencies: MainFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.tabBarController = .init()
    }

    func start() {
        let pages = MainTabPage.allCases
            .sorted(by: { $0.rawValue < $1.rawValue })
        let controllers: [UINavigationController] = pages
            .map { getTabController($0) }
        prepareTabBarController(withTabControllers: controllers)
    }

    // MARK: - Private

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = MainTabPage.home.rawValue

        navigationController?.viewControllers = [tabBarController]
    }

    private func getTabController(_ page: MainTabPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)

        navController.tabBarItem = UITabBarItem.init(
            title: page.pageTitleValue(),
            image: page.pageImage(),
            tag: page.rawValue
        )

        let vc = getViewController(page, navigationController: navController)
        navController.pushViewController(vc, animated: true)

        return navController
    }

    private func getViewController(_ page: MainTabPage, navigationController: UINavigationController) -> UIViewController {
        switch page {
        case .home:
            return dependencies.makeHomeScreen()
        case .categorization:
            return dependencies.makeCategorizationScreen(navigationController)
        case .myTeams:
            return dependencies.makeMyTeamsScreen()
        case .profile:
            return dependencies.makeProfileScreen(navigationController)
        }
    }
}
