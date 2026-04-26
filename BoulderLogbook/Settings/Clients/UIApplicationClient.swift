//
//  UIApplicationClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import UIKit
import ComposableArchitecture

@DependencyClient
struct UIApplicationClient {
    var openLink: @Sendable (String) async -> ()
    var setAlternateIconName: @Sendable (String?) async -> ()
    var currentIconName: @Sendable () async -> String? = { nil }
}

extension UIApplicationClient: DependencyKey {
    static let liveValue: Self = {
        return Self(
            openLink: { @MainActor urlString in
                if let url = URL(string: urlString) {
                    await UIApplication.shared.open(url)
                }
            },
            setAlternateIconName: { @MainActor iconName in
                UIApplication.shared.setAlternateIconName(iconName)
            },
            currentIconName: { @MainActor in
                UIApplication.shared.alternateIconName
            }
        )
    }()
}
