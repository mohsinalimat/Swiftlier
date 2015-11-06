//
//  KeyboardConstraintAdjuster.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/6/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

class KeyboardConstraintAdjuster: NSObject {
    @IBOutlet var constraint: NSLayoutConstraint!
    @IBOutlet var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: Notifications

    func keyboardWillShow(notification: NSNotification) {
        let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if frame != nil && duration != nil {
            UIView.animateWithDuration(
                duration!,
                delay: 0,
                options: options,
                animations: { () -> Void in
                    self.constraint.constant = frame!.size.height
                    self.view.layoutIfNeeded()
                },
                completion: nil
            )
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if frame != nil && duration != nil {
            UIView.animateWithDuration(duration!, delay: 0, options: options, animations: { () -> Void in
                self.constraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}