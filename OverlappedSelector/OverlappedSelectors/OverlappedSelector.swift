//
//  OverlappedSelector.swift
//  OverlappedSelector
//
//  Created by James Rochabrun on 12/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class OverlappedSelector: UIView {
    
    // MARK: Properties
    private var xConstraints: [NSLayoutConstraint] = []
    private var items: [UIImage] = []
    
    var itemsCount: Int {
        return self.subviews.count
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(items: [UIImage], borderColor: UIColor? = nil) {
        self.init()
        self.items = items
        self.setUp(borderColor: borderColor)
        self.setUpLongGesture() // SelectorPopUP Protocol
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
        
    }
    
    // MARK: Configuration
    private func setUp(borderColor: UIColor? = nil) {
        
        for (i, item) in self.items.enumerated() {
            self.addSubview(self.constructImageView(image: item, index: i, borderColor: borderColor))
        }
    }
    
    private func constructImageView(image: UIImage?, index: Int, borderColor: UIColor? = nil) -> UIImageView {
        let iV = UIImageView(image: image)
        iV.backgroundColor = .green
        iV.clipsToBounds = true
        iV.layer.borderColor = borderColor?.cgColor
        iV.layer.borderWidth = 2.0
        iV.tag = index
        iV.translatesAutoresizingMaskIntoConstraints = false
        iV.isUserInteractionEnabled = true
        iV.gestureRecognizers = [UITapGestureRecognizer(target: self, action: #selector(handleTap))]
        return iV
    }
    
    // MARK: Layout Constraints
    func setUpConstraints() {
        
        let _ = xConstraints.forEach { $0.isActive = false }
        xConstraints.removeAll()
        
        for (i, subView) in self.subviews.enumerated() {
            subView.layer.cornerRadius = subView.frame.size.width / 2
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            subView.widthAnchor.constraint(equalTo: subView.heightAnchor).isActive = true
            
            let xCons = subView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            xCons.constant = getNextX(index: i)
            xCons.isActive = true
            xConstraints.append(xCons)
        }
    }
    
    // MARK: Helper
    private func getNextX(index: Int) -> CGFloat {
        
        var nxtX: CGFloat = 0
        let itemHeight = bounds.height
        let itemWidth = itemHeight
        let count: CGFloat = CGFloat(self.subviews.count)
        
        if count > 1 {
            let remainingSpace = bounds.width - itemWidth * count
            let space = remainingSpace / (count - 1.0) * CGFloat(index)
            nxtX = itemWidth * CGFloat(index) + space
        } else {
            nxtX = (bounds.width - itemWidth) / 2 // center one item
        }
        return nxtX
    }
}


extension OverlappedSelector: SelectorPopUP {
    
    func setUpLongGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(setUpLongPress))
        self.addGesture(longPress)
    }
    
    @objc func setUpLongPress(gesture: UILongPressGestureRecognizer) {
        self.handleLongPress(gesture: gesture)
    }
}

extension OverlappedSelector {
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        
        guard let imageViewTapped = gesture.view as? UIImageView else { return }
        guard let lastImageView = self.subviews.last as? UIImageView else { return }
        
        let selectedImage = imageViewTapped.image
        let lastImage = lastImageView.image
        
        lastImageView.image = selectedImage
        imageViewTapped.image = lastImage
    }
}

