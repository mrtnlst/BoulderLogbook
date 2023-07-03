//
//  InAppPurchase.swift
//  BoulderLogbook
//
//  Created by Martin List on 03.07.23.
//

import Foundation
import StoreKit

struct InAppPurchase: Equatable, Identifiable {
    let id: String
    let displayName: String
    let displayPrice: String
}
