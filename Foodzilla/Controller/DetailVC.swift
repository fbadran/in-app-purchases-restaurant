//
//  DetailVC.swift
//  Foodzilla
//
//  Created by faisal badran on 2020-05-06.
//  Copyright © 2020 faisal badran. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var adView: UIView!
    @IBOutlet weak var buyItemBtn: UIButton!
    @IBOutlet weak var hideAdsBtn: UIButton!
    
    private(set) public var item: Item!
    private var hiddenStatus: Bool = UserDefaults.standard.bool(forKey: "hideAdsPurchased")
    
    func initDataForItem(item: Item) {
        self.item = item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemImageView.image = item.image
        itemNameLbl.text = item.name
        itemPriceLbl.text = String(describing: item.price)
        buyItemBtn.setTitle("Buy this item for $\(item.price)", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(IAPServicePurchaseNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure(_:)), name: NSNotification.Name(IAPServiceFailureNotification), object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideAds()
    }
    
    func showOrHideAds() {
        adView.isHidden = hiddenStatus
        hideAdsBtn.isHidden = hiddenStatus
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlePurchase(_ notification: Notification) {
        guard let productId = notification.object as? String else {
            return
        }
        
        switch productId {
        case IAP_MEAL_ID:
            buyItemBtn.isEnabled = true
            debugPrint("Meal Successfully Puchased.")
            break
        case IAP_HIDE_ADS_ID:
            adView.isHidden = true
            hideAdsBtn.isHidden = true
            break
        default:
            break
        }
    }
    
    @objc func handleFailure(_ notification: Notification) {
        buyItemBtn.isEnabled = true
        debugPrint("Purchase  Failed!")
    }

    @IBAction func buyBtnPressed(_ sender: Any) {
        buyItemBtn.isEnabled = false
        IAPService.instance.attemptPurchaseForItem(withProductIndex: .meal)
    }
    
    @IBAction func hideAdsBtnPressed(_ sender: Any) {
        IAPService.instance.attemptPurchaseForItem(withProductIndex: .hideAds)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
