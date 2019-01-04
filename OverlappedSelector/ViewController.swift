//
//  ViewController.swift
//  OverlappedSelector
//
//  Created by James Rochabrun on 12/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var overlappedView: OverlappedSelector = {
        let ov = OverlappedSelector(items: [#imageLiteral(resourceName: "pz"), #imageLiteral(resourceName: "messi"), #imageLiteral(resourceName: "zidane")], borderColor: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1))
        ov.translatesAutoresizingMaskIntoConstraints = false
        return ov
    }()
    
    lazy var expandButton: UIButton = {
        let b = UIButton(frame: CGRect.zero)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(toggleNow), for: .touchUpInside)
        b.layer.cornerRadius = 10
        b.clipsToBounds = true
        b.setTitle("Expand", for: .normal)
        b.layer.borderColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
        b.layer.borderWidth = 2.0
        b.setTitleColor(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), for: .normal)
        return b
    }()
    
    private var constantWidth: CGFloat = 180
    private var overlappedWidthConstraint: NSLayoutConstraint!
    private var toggle: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOverlapppedView()
    }
    
    
    private func addOverlapppedView() {
        
        self.view.addSubview(overlappedView)
        self.view.addSubview(expandButton)
        
        overlappedWidthConstraint = overlappedView.widthAnchor.constraint(equalToConstant:  constantWidth)
        overlappedWidthConstraint.isActive = true
        
        self.overlappedView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.overlappedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.overlappedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        expandButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        expandButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        expandButton.topAnchor.constraint(equalTo: self.overlappedView.bottomAnchor, constant: 50).isActive = true
        expandButton.centerXAnchor.constraint(equalTo: self.overlappedView.centerXAnchor).isActive = true
    }
    
    @objc func toggleNow() {
        
        toggle = !toggle
        let title = toggle ? "Expand" : "Collapse"
        UIView.animate(withDuration: 0.5, animations: {
            self.expandButton.setTitle(title, for: .normal)
            self.overlappedWidthConstraint.constant = self.toggle ? self.constantWidth : CGFloat(self.overlappedView.itemsCount) * self.overlappedView.frame.size.height
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
}
