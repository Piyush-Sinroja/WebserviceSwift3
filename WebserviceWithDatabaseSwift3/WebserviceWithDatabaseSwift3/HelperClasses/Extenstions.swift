//
//  Extenstions.swift
//  ModelClasses
//

import Foundation


//MARK:- NSMutableData EXTENSTION
extension NSMutableData {
    /// This function is use to append string to NSMutableData
    ///
    /// - Parameter string: The string to be added to the `NSMutableData`.
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}


//MARK:- String EXTENSTION
extension String {
    
    func isEmptyString() -> Bool {
        
        if self.trimmingCharacters(in: CharacterSet.whitespaces).count == 0{
            return true
        }
        return false
    }
}


//MARK:- UIViewController EXTENSTION
extension UIViewController {
    
    //MARK:-  Common alert method
    func showAlert(title: String?, message: String?, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:-  Common internet alert
    func showInternetAlert(){
        
        let alertController = UIAlertController(title: "App Name", message: "There is no internet connection.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            print("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK:-  HUD Custom Method
    func showHud()  {
        DispatchQueue.main.async(execute: {() -> Void in
            Constant.HUD  = MBProgressHUD.showAdded(to: self.view, animated: true)
            Constant.HUD.label.text = ""
            Constant.HUD.bezelView.color = UIColor.clear
        })
    }
    
    func hideHud() {
        DispatchQueue.main.async(execute: {() -> Void in
            Constant.HUD.hide(animated: true)
            Constant.HUD.removeFromSuperview()
        })
    }
    
}

extension UIView {
    func showLoadingHUDWithText (text: String) {
        if Constant.HUD.superview == nil {
            self.addSubview(Constant.HUD)
            Constant.HUD.center = self.center
            Constant.HUD.label.text = text
            Constant.HUD.show(animated: true)
        } else {
            print("HUD is nil")
        }
    }
    func hideLoadingHUD() {
        DispatchQueue.main.async {
            Constant.HUD.hide(animated: true)
            Constant.HUD.removeFromSuperview()
        }
    }
}
