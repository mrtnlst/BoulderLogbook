//
//  AppEnvironment.swift
//  Mandala
//
//  Created by Martin List on 24.06.22.
//

import Foundation
import CombineSchedulers

struct AppEnvironment {
    var mainQueue: AnySchedulerOf<DispatchQueue> = .main
    var storageService: StorageServiceType
}
