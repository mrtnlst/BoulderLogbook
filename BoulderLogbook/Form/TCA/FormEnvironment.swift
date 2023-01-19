//
//  FormEnvironment.swift
//  Mandala
//
//  Created by Martin List on 25.06.22.
//

import Foundation
import ComposableArchitecture

struct FormEnvironment {
    var save: (Logbook.Entry) -> Effect<Never, Never>
}
