//
//  IAPService.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-07.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPServiceDelegate {
    func iapProductsLoaded()
}

class IAPService: NSObject, SKProductsRequestDelegate {
    
    static let instance = IAPService()
    
    var delegate: IAPServiceDelegate?
    
    var productIds = Set<String>()
    var productsRequest = SKProductsRequest()
    var products = [SKProduct]()
    
    var hideAdsPurchased = UserDefaults.standard.bool(forKey: "hideAdsPurchased")
    
    func fetchProducts() {
        productIdToStringSet()
        requestProducts(forProductIds: productIds)
    }
    
    func productIdToStringSet() {
        let ids = [IAP_HIDE_ADS_ID, IAP_MEAL_ID]
        for id in ids {
            productIds.insert(id)
        }
    }
    
    func requestProducts(forProductIds ids: Set<String>) {
        productsRequest.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        if products.count > 0 {
            delegate?.iapProductsLoaded()
        } else {
            requestProducts(forProductIds: productIds)
        }
    }
    
    func attemptPurchaseForItem(withProductIndex idx: Product) {
        let product = products[idx.rawValue]
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                complete(transaction: transaction)
                sendNotification(forPurchaseStatus: .purchased, withIdentifier: transaction.payment.productIdentifier)
                debugPrint("Purchase was successful")
                break
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotification(forPurchaseStatus: .restored, withIdentifier: nil)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                sendNotification(forPurchaseStatus: .failed, withIdentifier: nil)
                break
            case .deferred:
                break
            case .purchasing:
                break
            default:
                break
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        sendNotification(forPurchaseStatus: .restored, withIdentifier: nil)
        setHideAdsPurchased(true)
    }
    
    func complete(transaction: SKPaymentTransaction) {
        switch transaction.payment.productIdentifier {
        case IAP_MEAL_ID:
            break
        case IAP_HIDE_ADS_ID:
            setHideAdsPurchased(true)
            break
        default:
            break
        }
    }
    
    func setHideAdsPurchased(_ status: Bool) {
        UserDefaults.standard.set(true, forKey: "hideAdsPurchased")
    }
    
    func sendNotification(forPurchaseStatus status: PurchaseStatus, withIdentifier identifier: String?) {
        switch status {
        case .purchased:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServicePurchaseNotification), object: identifier)
            break
        case .restored:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
            break
        case .failed:
            NotificationCenter.default.post(name: NSNotification.Name(IAPServiceFailureNotification), object: nil)
            break
        }
    }
}
