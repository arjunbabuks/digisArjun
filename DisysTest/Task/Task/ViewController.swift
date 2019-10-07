//
//  ViewController.swift
//  Task
//
//  Created by Arjun babu k.s on 10/7/19.
//  Copyright © 2019 Arjun babu k.s. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    // MARK: Outlets and Declaraction
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var eidTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idbanohoTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var unifiedNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var name = NSString()
    var eid = NSString()
    var idbanoho = NSString()
    var emailAddress = NSString()
    var mobileNumber = NSString()
    var unifiedNumber = NSString()

    // MARK : LifeCycleMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCornerRadicus(textField: eidTextField)
        setCornerRadicus(textField: nameTextField)
        setCornerRadicus(textField: idbanohoTextField)
        setCornerRadicus(textField: emailAddressTextField)
        setCornerRadicus(textField: mobileNumberTextField)
        setCornerRadicus(textField: unifiedNumberTextField)
        self.submitButton.layer.cornerRadius = 5.0
        self.activityIndicator.isHidden = true
         self.setPaddingInTextField(selectedTextField: self.emailAddressTextField)
        self.setPaddingInTextField(selectedTextField: self.eidTextField)
        self.setPaddingInTextField(selectedTextField: self.nameTextField)
        self.setPaddingInTextField(selectedTextField: self.idbanohoTextField)
        self.setPaddingInTextField(selectedTextField: self.unifiedNumberTextField)
        self.setPaddingInTextField(selectedTextField: self.mobileNumberTextField)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK : Methods
    
    func setCornerRadicus (textField : UITextField) {
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 0.5
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func isValidInput(Input:NSString) -> Bool {
        let RegEx = "\\w{4,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with:Input)
    }
    
    
    func setPaddingInTextField (selectedTextField : UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: selectedTextField.frame.height))
        selectedTextField.leftView = paddingView
        selectedTextField.leftViewMode = UITextField.ViewMode.always
    }
    
    func isValidTextFields(name: NSString?, emailAddress: NSString?, eid: NSString?, idbanoho : NSString?, unifiedNumber : NSString?, mobilenumber : NSString?) -> Bool{
        var success : Bool = false
        if name!.length != 0 && emailAddress!.length != 0 && mobilenumber?.length != 0 && eid?.length != 0 && idbanoho?.length != 0 && unifiedNumber?.length != 0 {
            success = true
            return success
        }
        return false
    }
    
    func showAlertView (message : String) {
        var alert = UIAlertView(title: "Error", message: message, delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    func showIndicator () {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideIndicator () {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func validateMobileNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func initializeLogin() {
        DispatchQueue.main.async {
            self.showIndicator()
        let url = URL(string: "https://api.qa.mrhe.gov.ae/mrhecloud/v1.4/api/iskan/v1/certificates/towhomitmayconcern")
        var request = URLRequest(url: url!)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "eid": Int(self.eid as String) ,
            "name": self.name,
            "idbarahno": Int(self.idbanoho as String),
            "emailaddress": self.emailAddress,
            "unifiednumber":Int(self.unifiedNumber as String),
            "mobileno" : self.mobileNumber
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        request.setValue("mobile_dev", forHTTPHeaderField: "consumer-key")
        request.setValue("20891a1b4504ddc33d42501f9c8d2215fbe85008", forHTTPHeaderField: "consumer-secret")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    self.hideIndicator()
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                self.hideIndicator()
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            do {
                let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                print(result.success)
            //    self.hideIndicator()
                if result.success {
                    // navigate to list of news view
                    UserDefaults.standard.set(self.eid, forKey: "eid")  //Integer
                    UserDefaults.standard.set(self.name, forKey: "name") //setObject
                    UserDefaults.standard.set(self.unifiedNumber, forKey: "unifiedNumber")  //Integer
                    UserDefaults.standard.set(self.emailAddress, forKey: "emailAddress") //setObject
                    UserDefaults.standard.set(self.idbanoho, forKey: "idbanoho")  //Integer
                    UserDefaults.standard.set(self.mobileNumber, forKey: "mobilenumber") //setObject
                    self.performSegue(withIdentifier: "LoginToListView", sender: self)
                } else {
                    print(error)
                    self.showAlertView(message: result.message)
                }
            } catch {
            }
        }
        
        task.resume()
        }
    }
    
    
    // MARK: SumbitAction Method
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        name = self.nameTextField?.text as! NSString ?? "" as NSString
        eid = self.eidTextField?.text as! NSString ?? "" as NSString
        idbanoho = self.idbanohoTextField?.text as! NSString ?? "" as NSString
        emailAddress = self.emailAddressTextField?.text as! NSString ?? "" as NSString
        mobileNumber = self.mobileNumberTextField?.text as! NSString ?? "" as NSString
        unifiedNumber = self.unifiedNumberTextField?.text as! NSString ?? "" as NSString
        
        
        var isEmpty : Bool = self.isValidTextFields(name: name, emailAddress: emailAddress, eid: eid, idbanoho: idbanoho, unifiedNumber: unifiedNumber, mobilenumber: mobileNumber)
        
        if isEmpty == false {
            print("Invalid crediatles")
            showAlertView(message: "Please enter all crediatles")
        } else {
            if eid.length < 6 {
                showAlertView(message: "eid must be greater than and equal to 6 characters")
            } else if (!isValidInput(Input: name)) {
                showAlertView(message: "enter the valid username")
            } else if (idbanoho.length < 6) {
                showAlertView(message: "idbarahno must be greater than 6 characters")
            } else if (!isValidEmail(emailStr: (emailAddress as? String)!)) {
                showAlertView(message: "Invalid emailAddress")
            } else if (unifiedNumber.length < 3) {
                showAlertView(message: "unified number should be 3 characters")
            } else if (
                validateMobileNumber(value: mobileNumber as String)) {
                showAlertView(message: "Please enter correct mobile number")
            } else {
                self.initializeLogin()
            }
        }
    }
    
   
    // MARK: Keyboard Methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        DispatchQueue.main.async {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                    print(keyboardSize.height)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    // MARK: Segue Method
    
    func prepareForSegue(segue : UIStoryboardSegue!, sender: AnyObject!){
        if segue.identifier == "LoginToListView" {
            let vc = segue.identifier as? listOfNewsViewController
        }
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func  textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField .resignFirstResponder()
        return true
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
