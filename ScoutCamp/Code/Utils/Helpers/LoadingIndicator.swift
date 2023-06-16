//
//  LoadingIndicator.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 14/06/2023.
//

import UIKit

class LoadingIndicator {
    static let kLoadingContainerTag = 9022021
    static let kContainerSide: CGFloat = 60.0
    static var counter = 0

    class func showLoadingIndicator() {
        counter += 1
        let window = UIApplication.shared.windows.first
        var container = window?.viewWithTag(kLoadingContainerTag)
        container?.isHidden = false
        if container != nil {
            window?.isUserInteractionEnabled = false
            window?.bringSubviewToFront(container!)
            return
        }
        let rect = CGRect(x: 0, y: 0, width: kContainerSide, height: kContainerSide)

        let loadIndicator = UIActivityIndicatorView.init(frame: rect)

        loadIndicator.hidesWhenStopped = true
        loadIndicator.style = UIActivityIndicatorView.Style.large
        loadIndicator.color = .white

        container = UIView.init(frame: rect)
        container?.layer.cornerRadius = 10.0
        container?.center = (window?.center)!
        container?.backgroundColor = UIColor.darkGray
        container?.addSubview(loadIndicator)

        let coverView = UIView.init(frame: (window?.bounds)!)
        coverView.backgroundColor = UIColor.clear
        coverView.tag = kLoadingContainerTag
        coverView.addSubview(container!)

        window?.addSubview(coverView)
        loadIndicator.startAnimating()
        window?.isUserInteractionEnabled = false
    }

    class func hideLoadingIndicator() {
        counter -= 1
        for window in UIApplication.shared.windows {
            if let view = window.viewWithTag(kLoadingContainerTag) {
                view.removeFromSuperview()
                window.isUserInteractionEnabled = true
            }
        }
    }
}
