//
//  UIApplicationClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 25.06.23.
//

import UIKit
import Dependencies

struct UIApplicationClient {
    var openLink: (String) async -> ()
}

extension DependencyValues {
    var uiApplicationClient: UIApplicationClient {
        get { self[UIApplicationClient.self] }
        set { self[UIApplicationClient.self] = newValue }
    }
}

extension UIApplicationClient: DependencyKey {
    static let liveValue: Self = {
        return Self(
            openLink: { @MainActor urlString in
                if let url = URL(string: urlString) {
                    await UIApplication.shared.open(url)
                }
            }
        )
    }()
}
