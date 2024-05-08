//
//  RemoteConfigManager.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 31/10/2023.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case currentPeriodId
}

final class RemoteConfigManager: ObservableObject {
    static let shared = RemoteConfigManager()
    private(set) var remoteConfig: RemoteConfig!

    // MARK: - Public methods

    func setup() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        refresh()
    }

    var currentPeriodId: String? {
        remoteConfig.configValue(forKey: RemoteConfigKey.currentPeriodId.rawValue).stringValue
    }

    // MARK: - Helpers

    private func refresh() {
        remoteConfig.fetchAndActivate { _, error in
            if let error {
                print(error.localizedDescription)
            }
        }
    }
}
