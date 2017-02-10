//
//  CheckReqServiceVC.swift
//  WebserviceWithDatabaseSwift3

import UIKit
class CheckReqServiceVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // How To Call PowerWebservice Methods
    
        //(1) Simple Get Webservice
           //  callGETWebservice()
        
        //(1) Simple POST Webservice
           //  callPOSTWebservice()
        
        //(1) Simple callPOSTWithImageWebservice Webservice
           //  callPOSTWithImageWebservice()
        
        //(1) Simple callPOSTWithFileWebservice Webservice
             callPOSTWithFileWebservice()
        
    }

    func callGETWebservice() {
        //RequestForGet Method
        let checkInternet = Constant.reachabilityCheck()
        if checkInternet == true
        {
           // Constant.showLoadingHUD(ViewController: self)
        
            Constant.showHUD(ViewController: self)
            
            let url : String = "API"
            let webServiceobj = PowerWebservice()
            webServiceobj.delegate = self
            webServiceobj.requestGet_service(strUrl: url, apiIdentifier: "simpleGetRequest")
        }
        else {
            Constant.InternetConnection(ViewController: self)
        }
    }
    
    func callPOSTWebservice() {
        //RequestForGet Method
        let checkInternet = Constant.reachabilityCheck()
        if checkInternet == true
        {
            let webServiceobj = PowerWebservice()
            webServiceobj.delegate = self

            let url : String = "API"
            
            let parameters : [String : String] = [
                "key1"      :"",
                "key2"      :"",
                "key3"      :"",
                ]
            
            // Constant.showLoadingHUD(ViewController: self)
            
            Constant.showHUD(ViewController: self)
            
            webServiceobj.requestPost_service(url: url, postData: parameters as NSDictionary, apiIdentifier: "POSTWebservice")
            
        }
        else {
             Constant.InternetConnection(ViewController: self)
        }
    }
    
    func callPOSTWithImageWebservice() {
        //RequestForGet Method
        let checkInternet = Constant.reachabilityCheck()
        if checkInternet == true
        {
            let webServiceobj = PowerWebservice()
            webServiceobj.delegate = self
            
            let url : String = "API"
            
            let parameters : [String : String] = [
                "key1"      :"",
                "key2"      :"",
                "key3"      :"",
                ]
            
            let img : UIImage = UIImage(named: "newnature")!
            
           // Constant.showLoadingHUD(ViewController: self)
            
            Constant.showHUD(ViewController: self)
            
            webServiceobj.requestPostWithImages_service(strUrl: url, postData: parameters as NSDictionary, aryImageKey: ["imagekey"], aryImages: [img], apiIdentifier: "POSTWithImageWebservice")
            
        }
        else {
             Constant.InternetConnection(ViewController: self)
        }
    }
    
    func callPOSTWithFileWebservice() {
        //RequestForGet Method
        let checkInternet = Constant.reachabilityCheck()
        if checkInternet == true
        {
            let webServiceobj = PowerWebservice()
            webServiceobj.delegate = self
            
            let url : String = "API"
            
            let parameters : [String : String] = [
                "username"      :"hgdg",
                "email"      :"s1das@gmaild5.com",
                "password"      :"123456",
                "confirmPassword"      :"123456",
                "gender"      :"0",
                ]
        
           // let file = Constant.getDocumentsURL().appendingPathComponent("")
            
            guard let filetext = Bundle.main.path(forResource: "PowerWebserviceinfo", ofType: "rtf") else {
                return
            }
            
            Constant.showHUD(ViewController: self)
            
           // Constant.showLoadingHUD(ViewController: self)
            webServiceobj.requestPostWithFile_service(strUrl: url, postData: parameters as NSDictionary, aryFilesKey: ["image"], aryFilesPath: [filetext], apiIdentifier: "POSTWithFileWebservice")
        }
        else {
             Constant.InternetConnection(ViewController: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CheckReqServiceVC : PowerWebserviceDelegate {
    
    /// This will return response from webservice if request successfully done to server
    func powerWebserviceResponseSuccess(response: NSDictionary, apiIdentifier: String)
    {
        //Constant.hideLoadingHUD()
        
        Constant.HideHud()
        print(response)
        
        if apiIdentifier == "GETWebservice" {
        
        }
        else if apiIdentifier == "POSTWebservice" {
            
        }
        else if apiIdentifier == "POSTWithImageWebservice" {
            
        }
        else if apiIdentifier == "POSTWithFileWebservice" {
            
        }
    }
    
    /// This will return response from webservice if request fail to server
    func powerWebserviceResponseFail(response: NSDictionary, apiIdentifier: String)
    {
        //Constant.hideLoadingHUD()
        Constant.HideHud()
        
        print(response)
        if apiIdentifier == "GETWebservice" {
            
        }
        else if apiIdentifier == "POSTWebservice" {
            
        }
        else if apiIdentifier == "POSTWithImageWebservice" {
            
        }
        else if apiIdentifier == "POSTWithFileWebservice" {
            
        }
    }
    /// This is for Fail request or server give any error
    func powerWebserviceResponseError(error: Error?, apiIdentifier: String) {
       // Constant.hideLoadingHUD()
        Constant.HideHud()
    }
    
}

