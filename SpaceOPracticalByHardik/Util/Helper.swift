//
//  Helper.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import Foundation
import UIKit

open class Helper : NSObject
{
    var myCustomView: EmptyStateGenericScreen?
    static let sharedHelper = Helper()
    
    var routesOffset = 0
    var batchSize = 0
    
    override init()
    {
           myCustomView = UIView.fromNib()
    }
    
    func addEmptyStateDesign(imageName:String,title:String,desc:String,objVw:UIView)
    {
        objVw.addSubview(myCustomView!)
        myCustomView?.frame = CGRect(x: 0, y: 0, width: objVw.frame.size.width, height: objVw.frame.size.height)
        myCustomView?.emptyStateDesignTitleLabel.text = title
        myCustomView?.emptyStateDesignDescLabel.text = desc
    }
    func removeEmptyStateDesign()
    {
        myCustomView?.removeFromSuperview()
    }
    func getRootViewController() -> UIViewController?
    {
        if let topController = UIApplication.topViewController() {
            return topController
        }
        if let viewController =  UIApplication.shared.keyWindow?.rootViewController
        {
            return viewController
        }
        return nil
    }
    func showAlert(_ alertTitle: String, alertMessage: String)
    {
        if objc_getClass("UIAlertController") != nil
        { // iOS 8
            let myAlert: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            myAlert.view.tintColor = customColor.globalTintColor
            myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.getRootViewController()?.present(myAlert, animated: true, completion: nil)
        }
        else
        {
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = alertTitle
            alert.tintColor = customColor.globalTintColor
            alert.message = alertMessage
            alert.addButton(withTitle: "OK")
            
            alert.show()
        }
    }
    
    func showAlert(_ alertTitle: String, alertMessage: String,whenPressedOK: @escaping ()->())
    {
        if objc_getClass("UIAlertController") != nil
        { // iOS 8
            let myAlert: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            myAlert.view.tintColor = customColor.globalTintColor
            myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                whenPressedOK()
            }))
            self.getRootViewController()?.present(myAlert, animated: true, completion: nil)
        }
        else
        {
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.tintColor = customColor.globalTintColor
            alert.title = alertTitle
            alert.message = alertMessage
            alert.addButton(withTitle: "OK")
            alert.show()
        }
    }
    func setIconBeforeLabel(imageName:String,value:String) -> NSAttributedString
    {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named:imageName)
        // Set bound to reposition
        let imageOffsetY: CGFloat = -5.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: value)
        completeText.append(textAfterIcon)
        return completeText
    }
    func convertDateToOtherFormat(selectedDate:String,currentDateFormat :String,newDateFormat:String) -> String
    {
        let objDateformatter = DateFormatter()
        objDateformatter.dateFormat = currentDateFormat
        objDateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
        
        let strDate = objDateformatter.date(from: selectedDate)
        objDateformatter.dateFormat = newDateFormat
        objDateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as! Locale
        
        let strfinalDate = objDateformatter.string(from: strDate!)
        return strfinalDate
    }
}
extension UIApplication
{
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
struct customColor
{
    static let globalTintColor =  UIColor(red: 67.0/255.0, green: 141.0/255.0, blue: 65.0/255.0, alpha:1.0)
}
