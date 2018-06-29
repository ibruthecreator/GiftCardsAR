//
//  Balance.swift
//  GiftCards
//
//  Created by Mohammed Ibrahim on 2018-06-27.
//  Copyright © 2018 Mohammed Ibrahim. All rights reserved.
//

import UIKit

class Balance: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var rightSide: UIStackView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var balance: UILabel!
    
    enum card {
        case Cineplex
        case Optimum
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Balance", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func changeToOriginalSize() {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.size.width = 375
        }
    }
    
    func setImageTo(_ card: card) {
        if card == .Cineplex {
            imageView.image = UIImage(named: "Cineplex")
            balance.text = "$35.23 Remaining"
        } else {
            imageView.image = UIImage(named: "pc")
            balance.text = "26,232 Points"
        }
    }
    
}
