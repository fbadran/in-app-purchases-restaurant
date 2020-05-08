//
//  ViewController.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-06.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import UIKit

class StorefrontVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        IAPService.instance.delegate = self
        IAPService.instance.fetchProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRestoredAlert), name: NSNotification.Name(IAPServiceRestoreNotification), object: nil)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        
        let item = foodItems[indexPath.row]
        cell.configureCell(forItem: item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailVC else {
            return
        }
        
        let item = foodItems[indexPath.row]
        detailVC.initDataForItem(item: item)
        present(detailVC, animated: true, completion: nil)
    }
    
    @objc func showRestoredAlert() {
        let alert = UIAlertController(title: "Success", message: "Your purchases were successfuly restored!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func restorePurchases(_ sender: Any) {
        let alert = UIAlertController(title: "Restore Purchases?", message: "Do you want to restore any in-app purchasses you have previously purchased", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Restore", style: .default) { (action) in
            IAPService.instance.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension StorefrontVC: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP PRODUCTS LOADED")
    }
    
}

