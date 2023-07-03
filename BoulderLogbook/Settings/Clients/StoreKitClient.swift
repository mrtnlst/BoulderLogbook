//
//  StoreKitClient.swift
//  BoulderLogbook
//
//  Created by Martin List on 03.07.23.
//

import StoreKit
import Dependencies

struct StoreKitClient {
    var fetchProduct: () async throws -> InAppPurchase?
    var fetchEntitlement: () async throws -> Bool
    var purchase: () async throws -> Bool
    var observeUpdates: () async throws -> Bool
}

extension DependencyValues {
    var storeKitClient: StoreKitClient {
        get { self[StoreKitClient.self] }
        set { self[StoreKitClient.self] = newValue }
    }
}

extension StoreKitClient: DependencyKey {
    static let liveValue: Self = {
        let productId = "com.martinlist.BoulderLogbook.AppIconPack"
        return Self(
           fetchProduct: {
               if let product = try await Product.products(for: [productId]).first {
                   return InAppPurchase(
                    id: product.id,
                    displayName: product.displayName,
                    displayPrice: product.displayPrice
                   )
               }
               return nil
           },
           fetchEntitlement: {
               var hasInAppPurchase = false
               for await result in Transaction.currentEntitlements {
                   guard case let .verified(transaction) = result,
                         transaction.productID == productId
                   else {
                       continue
                   }
                   hasInAppPurchase = transaction.revocationDate == nil
               }
               return hasInAppPurchase
           },
           purchase: {
               let products = try await Product.products(for: [productId])
               let result = try await products.first?.purchase(options: [.simulatesAskToBuyInSandbox(true)])
               
               switch result {
               case let .success(.verified(transaction)):
                   await transaction.finish()
                   return true
               default:
                   return false
               }
           },
           observeUpdates: {
               var hasInAppPurchase = false
               for await result in Transaction.updates {
                   guard case let .verified(transaction) = result,
                         transaction.productID == productId
                   else {
                       continue
                   }
                   hasInAppPurchase = transaction.revocationDate == nil
                   await transaction.finish()
               }
               return hasInAppPurchase
           }
        )
    }()
}
