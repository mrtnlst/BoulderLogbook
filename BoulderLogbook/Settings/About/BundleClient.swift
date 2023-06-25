//
//  BundleClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import UIKit
import Dependencies

struct BundleClient {
    var appIcon: () -> UIImage?
}

extension DependencyValues {
    var bundleClient: BundleClient {
        get { self[BundleClient.self] }
        set { self[BundleClient.self] = newValue }
    }
}

extension BundleClient: DependencyKey {
    static let liveValue: Self = {
        return Self(
            appIcon: {
                if let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
                   let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
                   let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
                   let lastIcon = iconFiles.last {
                    return UIImage(named: lastIcon)
                }
                return nil
            }
        )
    }()
}
