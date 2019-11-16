//
//  ViewController.swift
//  WebserviceWithDatabaseSwift3
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      //  WebserviceClass1()
        
        //WebserviceClass4()
    }
    
    
    @IBAction func btnNext(_ sender: Any) {
      if  let CheckReqServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckReqServiceVC") as? CheckReqServiceVC
      {
         self.navigationController?.pushViewController(CheckReqServiceVC, animated: true)
      }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func WebserviceClass1()
    {
        //RequestForGet Method
        let check = Constant.reachabilityCheck()
        if check == true
        {
            Constant.showHUD(ViewController: self)
            
            let url : String = "API"
            let webService = Webservice()
            webService.delegate = self
            webService.RequestForGet(strUrl: url, apiIdentifier: "simpleGetRequest")
        }
        else {
            Constant.InternetConnection(ViewController: self)
        }
    }
    
    func WebserviceClass2() {
        //RequestForGetWithHeader Method
        let check = Constant.reachabilityCheck()
        if check == true
        {
            Constant.showHUD(ViewController: self)
            
            let webservice = Webservice()
            webservice.delegate = self
            let url : String = "www.Google.com"
            webservice.RequestForGetWithHeader(strUrl: url, apiIdentifier: "getwithHeader")
        } else {
            Constant.InternetConnection(ViewController: self)
        }
    }
    
    func WebserviceClass3() {
        
        //RequestForPost Method
        let check = Constant.reachabilityCheck()
        if check == true
        {
            Constant.showHUD(ViewController: self)
            
            let webservice = Webservice()
            webservice.delegate = self
            let parameters : [String : String] = [
                "key1"      :"",
                "key2"      :"",
                "key3"      :"",
                ]
            webservice.RequestForPost(url: "WWW.google.com", postData: parameters as NSDictionary, apiIdentifier: "simplePost")
            
        }
        else {
            Constant.InternetConnection(ViewController: self)
        }
    }
    
    func WebserviceClass4() {
        
        //RequestForPost Method
        let check = Constant.reachabilityCheck()
        if check == true
        {
            Constant.showHUD(ViewController: self)
            
            let webservice = Webservice()
            webservice.delegate = self
            let parameters : [String : String] = [
                "caregiver_id"      :"12",
                "os_type"      :"2",
                ]
            
             let img : UIImage = UIImage(named: "newnature")!
            
            webservice.RequestForPostWithImages(strUrl: "API", postData: parameters as NSDictionary, aryImageKey: ["imgKey"], aryImages: [img], apiIdentifier: "imageUpload")
            
        }
        else {
            Constant.InternetConnection(ViewController: self)
        }
    }
}

// MARK: - API response handler
extension ViewController : WebserviceDelegate {
    func webserviceResponseSuccess(response: NSDictionary, apiIdentifier: String) {
        Constant.HideHud()
        
        print(response)
        
        if apiIdentifier == "simpleGetRequest" {
            
            print(response)
        }
        else if apiIdentifier == "getwithHeader" {
            
            
        }
        else if apiIdentifier == "simplePost" {
            
            
        }
        else if apiIdentifier == "imageUpload" {
            
            
        }
    }
    
    func webserviceResponseInArraySuccess(response: NSArray, apiIdentifier: String) {
        Constant.HideHud()
        if apiIdentifier == "simpleGetRequest" {
            
        }
        else if apiIdentifier == "getwithHeader" {
            
        }
        else if apiIdentifier == "simplePost" {
            
        }
        else if apiIdentifier == "imageUpload" {
            
        }
    }
    
    func webserviceResponseFail(response: NSDictionary, apiIdentifier: String) {
        Constant.HideHud()
        print(response)
    }
    
    func webserviceResponseError(error: Error?, apiIdentifier: String) {
        Constant.HideHud()
        print(error?.localizedDescription ?? "")
    }
}
