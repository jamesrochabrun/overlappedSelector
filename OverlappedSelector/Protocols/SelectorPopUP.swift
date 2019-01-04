//
//  SelectorPopUP.swift
//  OverlappedSelector
//
//  Created by James Rochabrun on 12/23/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

protocol SelectorPopUP {
    func setUpLongGesture()
}

extension SelectorPopUP where Self: UIView {
    
    func addGesture(_ longGesture: UILongPressGestureRecognizer) {
        self.addGestureRecognizer(longGesture)
    }
    
    func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began: self.handleGestureBegan(gesture)
        case .ended: self.handleGestureEnd(gesture)
        case .changed: self.handleGestureChanged(gesture)
        default: break
        }
    }
    
    private func handleGestureBegan(_ gesture: UILongPressGestureRecognizer) {
        
        let pressedLocation = gesture.location(in: self)
        /// keep track of the Y coordinate in the full screen
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.frame.height / 2)
        
        let hitTestView = self.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
            }) { (_) in }
        }
    }
    
    private func handleGestureChanged(_ gesture: UILongPressGestureRecognizer) {
        
        let pressedLocation = gesture.location(in: self)
        
        /// keep track of the Y coordinate in the full screen
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.frame.height / 2)
        
        let hitTestView = self.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.subviews.forEach { imageView in
                    imageView.transform = .identity
                }
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -self.frame.size.height)
            })
        }
    }
    
    private func handleGestureEnd(_ gesture: UILongPressGestureRecognizer) {
        // clean up the animation
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // let stackView = self.subviews.first
            self.subviews.forEach { imageView in
                imageView.transform = .identity
            }
        }, completion: { (_) in
            // do something like select this ite
        })
    }
}
