//
//  PowerWebservice.swift
//  WebserviceWithDatabaseSwift3

import UIKit
import Foundation
import MobileCoreServices

@objc protocol PowerWebserviceDelegate {
    /// This will return response from webservice if request successfully done to server
    func powerWebserviceResponseSuccess(response: NSDictionary, apiIdentifier: String)
    
    /// This will return response from webservice if request fail to server
    func powerWebserviceResponseFail(response: NSDictionary, apiIdentifier: String)
    
    /// This is for Fail request or server give any error
    func powerWebserviceResponseError(error: Error?, apiIdentifier: String)
    
    /// This will return response from webservice if request successfully done to server
    @objc optional func powerWebserviceResponseInArraySuccess(response: NSArray, apiIdentifier: String)
}

class PowerWebservice: NSObject, URLSessionDelegate, URLSessionDataDelegate {

    var delegate : PowerWebserviceDelegate?
    var apiIdentifier : String = ""
    var receivedData = NSMutableData()
    
    //MARK:- GET_Webservice
    /**
     Request using GET method
     - parameter strUrl     :- Request String
     */
    func requestGet_service(strUrl: String, apiIdentifier: String)  {
        self.apiIdentifier = apiIdentifier
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue .main)
        session.configuration.timeoutIntervalForRequest = 60.0
        let url: URL = URL(string: strUrl)!
        let urlRequest = NSMutableURLRequest(url: url)
        
        //------------------IF Header Required----------------------------
        // urlRequest = requiredHeader(request: urlRequest) //uncomment if rquired
        //--------------------------------------------------------------
        
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 60.0
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                    if httpResponse.statusCode != 200 {
                        if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        {
                            print(responseString)
                        }
                    }
                }
                
                if self.delegate != nil {
                    self.delegate?.powerWebserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
                }
                return
            }
            do {
                
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print(responseDictionary)
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        if self.delegate != nil {
                            self.delegate?.powerWebserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            print(httpResponse)
                            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                                print(responseString)
                            }
                        }
                        if self.delegate != nil {
                            self.delegate?.powerWebserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(String(describing: responseString))")
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                }
                if self.delegate != nil {
                    self.delegate?.powerWebserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
        task.resume()
    }
    
    //MARK:- POST_Webservice
    /**
     Request using post method,with user reuired to pass parameter on server.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     */
    func requestPost_service(url:String, postData:NSDictionary, apiIdentifier: String)  {
        self.apiIdentifier = apiIdentifier
        
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue .main)
        session.configuration.timeoutIntervalForRequest = 60.0

        let url = URL(string: url as String)!
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.timeoutInterval = 60
        
        //------------------IF Header Required----------------------------
        // urlRequest = requiredHeader(request: urlRequest) //uncomment if rquired
        // do Var instead of let
        //--------------------------------------------------------------
        
        urlRequest.httpBody = ConvertDictionaryToJsonString(object: postData)
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest as URLRequest)
        dataTask.resume()
    }
    
    //MARK:- POSTWithImage_OR_MultipleImage_Webservice
    
    /**
     Request using post method,with user reuired to pass parameter and file's on server with multipart form.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     - parameter aryImageKey :- array name of parameter, which will be used for store file on server DB. (i.e Image)
     - parameter aryImages   :- array of location of file, which will be stored on document directory.
     */
    func requestPostWithImages_service(strUrl:String, postData:NSDictionary, aryImageKey:NSArray, aryImages:NSArray, apiIdentifier: String)  {
        self.apiIdentifier = apiIdentifier
    
        let boundary = generateBoundaryString()
        let url = URL(string: strUrl)!
        let urlRequest = NSMutableURLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //------------------IF Header Required----------------------------
        // urlRequest = requiredHeader(request: urlRequest) //uncomment if rquired
          // do Var instead of let
        //--------------------------------------------------------------

        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy // this is the default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        
        let session = URLSession(configuration:configuration, delegate: self, delegateQueue: OperationQueue .main)
        
       urlRequest.httpBody = createBodyWithParametersAndImages(parameters: postData, filePathKey: aryImageKey, aryImage: aryImages, boundary: boundary) as Data
       let dataWithImagesTask: URLSessionDataTask = session.dataTask(with: urlRequest as URLRequest)
       dataWithImagesTask.resume()
    }
    
    //MARK:- POSTWithFile_OR_MultipleFile_Webservice
    /**
     Request using post method,with user reuired to pass parameter and file on server with multipart form.
     - parameter strUrl     :- Request URL
     - parameter postData   :- parameter for send to server.
     - parameter aryFilesKey :- array name of parameter, which will be used for store file on server DB. (i.e Image)
     - parameter aryFilesPath   :- array of location of file, which will be stored on document directory.
     */
    func requestPostWithFile_service(strUrl:String, postData:NSDictionary, aryFilesKey:NSArray, aryFilesPath:NSArray, apiIdentifier: String)  {
         self.apiIdentifier = apiIdentifier
        
        let boundary = generateBoundaryString()
        let url = NSURL(string: strUrl)!
        let urlRequest = NSMutableURLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //------------------IF Header Required----------------------------
        // urlRequest = requiredHeader(request: urlRequest) //uncomment if rquired
        // do Var instead of let
        //--------------------------------------------------------------

        urlRequest.httpBody = createBodyWithParametersAndFile(parameters: postData, aryFilesKey: aryFilesKey, aryFilesPath: aryFilesPath, boundary: boundary) as Data
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy // this is the default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0

        let session = URLSession(configuration:configuration, delegate: self, delegateQueue: OperationQueue .main)
        
       // let session = URLSession(configuration: configuration)
        
         let dataWithFileTask: URLSessionDataTask = session.dataTask(with: urlRequest as URLRequest)
         dataWithFileTask.resume()
    }
    
    
    // MARK: - Post API With Block
    func resquestSyncAPI(dictData : NSDictionary, url : URL,successHandler:@escaping (_ response:
        NSDictionary,_ isSuccess:Bool)-> Void) {
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.timeoutInterval = 30
        request.httpBody = ConvertDictionaryToJsonString(object: dictData)
        
        let session = URLSession(configuration:URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue .main)
        session.configuration.timeoutIntervalForRequest = 60.0
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            let dic = [
                "Error": "Fail"
            ]
            if error != nil {
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                    if httpResponse.statusCode != 200 {
                        
                        if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        {
                            print(responseString)
                        }
                        
                    }
                }
                print(error!)
                successHandler(dic as NSDictionary, false)
                return
            }
            
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    if (responseDictionary.object(forKey: "status"))! as! String == "success" {
                        successHandler(responseDictionary, true)
                    } else {
                        if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                            print(httpResponse)
                            if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            {
                                print(responseString)
                            }
                        }
                        successHandler(responseDictionary, false)
                    }
                }
            } catch {
                print(error)
                if let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                {
                    print(responseString)
                }
                if let httpResponse : HTTPURLResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                }
                successHandler(dic as NSDictionary, false)
            }
        }
        task.resume()
    }

    //MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
         receivedData.append(data as Data)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(.allow)
        print(response)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            if let responseString = NSString(data: receivedData as Data, encoding: String.Encoding.utf8.rawValue){
                print(responseString)
            }
            if self.delegate != nil {
                self.delegate?.powerWebserviceResponseError(error: error!, apiIdentifier: self.apiIdentifier)
            }
            return
        }
        else
        {
            do {
                if let responseDictionary = try JSONSerialization.jsonObject(with: receivedData as Data, options: []) as? NSDictionary {
                    
                    print(responseDictionary)
                    
                    
                    if responseDictionary.object(forKey: "status") as! Int == 1 {
                        if self.delegate != nil {
                            self.delegate?.powerWebserviceResponseSuccess(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                    else {
                        if let responseString = NSString(data: receivedData as Data, encoding: String.Encoding.utf8.rawValue){
                                print(responseString)
                        }
                        if self.delegate != nil {
                            self.delegate?.powerWebserviceResponseFail(response: responseDictionary, apiIdentifier: self.apiIdentifier)
                        }
                    }
                }
            }
            catch {
                let responseString = String(data: receivedData as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print("responseString = \(String(describing: responseString))")
                if self.delegate != nil {
                    self.delegate?.powerWebserviceResponseError(error: nil, apiIdentifier: self.apiIdentifier)
                }
            }
        }
    }
    
    //MARK:- Create RequestBody
    func createBodyWithParametersAndImages(parameters: NSDictionary?,filePathKey:NSArray , aryImage:NSArray,boundary: String) -> NSData {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        if aryImage.count > 0 && filePathKey.count == aryImage.count {
            
            for i in 0 ..< aryImage.count{
                
                let data = (aryImage[i] as! UIImage).jpegData(compressionQuality: 1)
                let mimeType = "png"
                
                // You can change name image.jpg
                
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey[i])\"; filename=\"image.jpg\"\r\n")
                body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
                body.append(data!)
                body.appendString(string: "\r\n")
            }
        }
        
        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }
    
    
    func createBodyWithParametersAndFile(parameters: NSDictionary, aryFilesKey: NSArray, aryFilesPath: NSArray,boundary: String) -> NSData {
        
        let body = NSMutableData()
        if parameters.count > 0 {
            for (key, value) in parameters {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        if aryFilesPath.count > 0  && aryFilesPath.count == aryFilesKey.count{
            for i in 0 ..< aryFilesPath.count {
                if let filePath:String = aryFilesPath[i] as? String
                {
                    let fileManager = FileManager.default
                    let fileUrl = URL(fileURLWithPath:filePath)
                    let filename = fileUrl.lastPathComponent
                    if (fileManager.fileExists(atPath: filePath)){
                        var data = Data()
                        do {
                            data = try Data(contentsOf: fileUrl)
                        }
                        catch {
                        }
                        
                        let mimeType = self.mimeTypeForPath(path: aryFilesPath[i] as! String)
                        
                        //let mimeType = "pdf"
                        
                        body.appendString(string: "--\(boundary)\r\n")
                        body.appendString(string: "Content-Disposition: form-data; name=\"\(aryFilesKey[i])\"; filename=\"\(filename)\"\r\n")
                        body.appendString(string: "Content-Type: \(mimeType)\r\n\r\n")
                        body.append(data)
                        body.appendString(string: "\r\n")
                    }
                }
            }
        }

        body.appendString(string: "--\(boundary)--\r\n")
        return body
    }

    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream";
    }
    
    //MARK:- RequiredHeader
    func requiredHeader(request:NSMutableURLRequest)-> NSMutableURLRequest {
        request.setValue("", forHTTPHeaderField: "Token")
        request.setValue("",forHTTPHeaderField: "sourceSystemId")
        request.setValue("",forHTTPHeaderField: "buId")
        request.setValue("",forHTTPHeaderField: "macId")
        // Compulsory
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    
    //MARK:- Convert Parameter Dictinary TO JSON String
    func ConvertDictionaryToJsonString(object : NSDictionary) -> Data {
        var jsonData : Data = Data()
        do {
            jsonData = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is an `AnyObject` decoded from JSON data
            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:String] {
                print(dictFromJSON)
                // use dictFromJSON
            }
        } catch let error as NSError {
            
            print(error)
        }
        return jsonData
    }
    
    //MARK:- GenerateBoundaryString
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}
