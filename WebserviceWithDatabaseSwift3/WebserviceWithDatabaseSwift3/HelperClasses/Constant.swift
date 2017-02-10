//
//  Constant.swift

import UIKit

class Constant: NSObject {
    
    static let InternetConnectionProblem : String = "Please check your internet connection."
    static let CommonAlert : String = "Oops!! Something went wrong. Please try again later."
    
    static var HUD : MBProgressHUD!
    
    static let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    static var reachability: Reachability?
    
    // MARK: - ServerPath Version 1
    static var ServerPathV1 : String = ""

    static let defaults = UserDefaults.standard
    static var MacUUID : String = "00:0a:95:9d:68:16"
    
    // MARK: - Device Token
    static var deviceToken : String = ""
    static var AppDel = UIApplication.shared.delegate as! AppDelegate
    static var isReachable      :   Bool  = false
    static var isOnWiFi: Bool = false
    // MARK: - Screen Size
    static var kScreenBounds    :   CGRect = UIScreen.main.bounds
    static var isiPhone_4       :   Bool  = 480 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_5       :   Bool  = 568 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_6       :   Bool  = 667 == UIScreen.main.bounds.size.height ? true:false
    static var isiPhone_6_Plus  :   Bool  = 736 == UIScreen.main.bounds.size.height ? true:false
    
    //, isPushOrPop:Bool
    static func Push_Pop_to_ViewController(destinationVC:UIViewController,isAnimated:Bool,navigationController:UINavigationController){
        var VCFound:Bool = false
        let viewControllers:NSArray = (navigationController.viewControllers as NSArray)
        var indexofVC:NSInteger = 0
        for  vc  in viewControllers {
            if (vc as AnyObject).nibName == (destinationVC.nibName) {
                VCFound = true
                break
            } else {
                indexofVC += 1
            }
        }
        if VCFound == true {
            navigationController .popToViewController(viewControllers.object(at: indexofVC) as! UIViewController, animated: isAnimated)
        } else {
            DispatchQueue.main.async {
                navigationController .pushViewController(destinationVC , animated: isAnimated)
            }
        }
    }
    
    static func getDocumentsURL() -> URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsURL
    }
    
    static func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL.path
    }
    
    static func getUniqueString() -> String {
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "ddMMyyyHHmmssSSS"
        return df.string(from: NSDate() as Date)
    }
    
    //MARK:- Validation
    static func usernameValidation(strUsername:String)->Bool {
        // Usernam should not blank
        if strUsername.isEmpty {
            return false
        }
        //Username should not be more than 40 characters.
        if strUsername.characters.count >= 40{
            return false
        }
        //Username should not contain space
        if strUsername.contains(" ") {
            return false
        }
        //Username should not start with any symbols.
        let regEx = "^([a-zA-z0-9])"
        let match = strUsername.range(of: regEx, options: .regularExpression, range: nil, locale: nil)
        if (match == nil){
            return false
        }
        return true
        //Username should not accept with spacing word(like word:user test)
    }
    
    //MARK passwodValidation
    static func passwodValidation(strPasswd : String)-> Bool {
        // Password should not blank
        if strPasswd.isEmpty {
            return false
        }
        //Password should be at least 6 characters.
        if strPasswd.characters.count < 6{
            return false
        }
        //Password should not be more than 40 characters.
        if strPasswd.characters.count > 40{
            return false
        }
        //Password should not contain space
        if strPasswd.contains(" "){
            return false
        }
        return true
    }
    
    //MARK emailAdrressValidation
    static func emailAdrressValidation(strEmail : String)->Bool {
        // Password should not blank
        if strEmail.isEmpty{
            return false
        }
        //Email address should accept like:test@gmail.co.uk
        let emailRegEx = "[.0-9a-zA-Z_-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailTest.evaluate(with: strEmail){
            return false
        }
        return true
    }
    
    static func setPalceHolderTextColor(textFiled:UITextField, text:String) {
        textFiled.attributedPlaceholder = NSAttributedString(string:text, attributes:[NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 254/255, green: 254/255, blue: 254/255, alpha: 0.20)])
        
    }
    
    // MARK: - HUD Methods
    static func showHUD(ViewController:UIViewController) {
        DispatchQueue.main.async {
            Constant.indicator.center = ViewController.view.center
            Constant.indicator.frame.origin.y = Constant.indicator.frame.origin.y - 64
            Constant.indicator.frame.size = CGSize(width: 60, height: 60)
            Constant.indicator.layer.cornerRadius = 5.0
            Constant.indicator.backgroundColor = UIColor.lightGray
            ViewController.view.addSubview(Constant.indicator)
            ViewController.view.bringSubview(toFront: Constant.indicator)
            Constant.indicator.startAnimating(isUserInteractionEnabled: false)
        }
    }
    
   static func HideHud() {
        DispatchQueue.main.async {
            Constant.indicator.stopAnimating(isUserInteractionEnabled: true)
        }
    }
    
    //MARK:- SHOW LOADING HUD
    static func showLoadingHUD(ViewController:UIViewController){
        if (self.HUD.superview == nil) {
            ViewController.view .addSubview(self.HUD)
            self.HUD.show(animated: true)
        }else{
            print("HUD is nil")
        }
    }
    
    //MARK:- SHOW LOADING HUD WITH TEXT
    static func showLoadingHUDWithText(ViewController:UIViewController,text:String){
        if (self.HUD .superview == nil) {
            ViewController.view .addSubview(self.HUD)
            self.HUD.label.text = text
            self.HUD.show(animated: true)
        }else{
            print("HUD is nil")
        }
    }
    
    //MARK:- HIDE LOADING HUD
    static func hideLoadingHUD(){
        DispatchQueue.main.async {
            self.HUD .removeFromSuperview()
        }
    }
    
    static func InternetConnection(ViewController:UIViewController) {
        let alert = UIAlertController(title: "SimpleWebsreviceDemo", message: Constant.InternetConnectionProblem, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        ViewController.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- INTERNAL_SERVER_ERROR
    static func InternalserverError(ViewController:UIViewController){
        let alert = UIAlertController(title: "SimpleWebsreviceDemo", message: Constant.CommonAlert, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        ViewController.present(alert, animated: true, completion: nil)
    }
    
    static func reachabilityCheck()-> Bool {
        let reachability = Constant.reachability
        if (reachability?.isReachable)! {
            if (reachability?.isReachableViaWiFi)! {
                print("Reachable via WiFi")
                Constant.isOnWiFi = true
            } else {
                print("Reachable via Cellular")
                Constant.isOnWiFi = false
            }
            Constant.isReachable = true
            return true
        } else {
            print("Not reachable")
            Constant.isReachable = false
            Constant.isOnWiFi = false
            return false
        }
    }
}

extension UIActivityIndicatorView {
    func startAnimating(isUserInteractionEnabled: Bool){
        self.startAnimating()
        self.superview?.isUserInteractionEnabled = isUserInteractionEnabled
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func stopAnimating(isUserInteractionEnabled: Bool){
        self.stopAnimating()
        self.superview?.isUserInteractionEnabled = isUserInteractionEnabled
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}

