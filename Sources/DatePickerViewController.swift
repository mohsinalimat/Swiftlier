//
//  ChooseDateViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

public class ChooseDateViewController: UIViewController {
    public let datePicker: DatePicker
    public let datePickerView: UIView

    public init(date: Date, includesDay: Bool) {
        if includesDay {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            self.datePicker = datePicker
            self.datePickerView = datePicker
        }
        else {
            let datePicker = MonthAndYearPicker()
            self.datePicker = datePicker
            self.datePickerView = datePicker
        }

        super.init(nibName: nil, bundle: nil)

        self.datePicker.date = date
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        self.datePickerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.datePickerView)
        self.view.addConstraints([
            NSLayoutConstraint(leftOf: self.datePickerView, to: self.view),
            NSLayoutConstraint(rightOf: self.datePickerView, to: self.view),
            NSLayoutConstraint(topOf: self.datePickerView, to: self.view, distance: -44),
        ])

        self.preferredContentSize = self.datePickerView.frame.size
    }
}
#endif