//
//  UIButton+Extension.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//
import UIKit
import Foundation
extension UIButton
{
    func roundCorners(corners: UIRectCorner, radius: Int = 8) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func makeBeautiful(color:UIColor = .gray)
    {
        self.roundCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight])
        self.backgroundColor = color
    }
}

