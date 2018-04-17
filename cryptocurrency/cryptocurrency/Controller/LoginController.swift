//
//  LoginController.swift
//  AppChat
//
//  Created by Khoa Nguyen on 3/14/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    var dashboardController: DashBoardController?
    var coinDetailController: CoinDetailController?
    let API_POST_LOGIN = "https://cryws.herokuapp.com/api/accounts/login" //return token
    let API_POST_REGISTER = "https://cryws.herokuapp.com/api/accounts/" 
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 12, g: 29, b: 53)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 28, g: 52, b: 84)
        button.tintColor = UIColor.white
        button.layer.borderWidth = 1
        button.layer.borderColor = button.tintColor.cgColor
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func loginWithParameter(username: String, password: String, completionBlock: @escaping (String) -> Void) -> Void {
        
       
    }
    
    func handleLogin(){
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
            else {
                return
        }
        if username.isEmpty || password.isEmpty{
            Alert.showAlert(inViewController: self, title: "Login Failed", message: "Username Or Password is not empty")
            return
        }
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["username": username, "password": password] as [String: String]
        
        //create the url with NSURL
        let urlLogin = NSURL(string: API_POST_LOGIN)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: urlLogin! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {          
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                                
                        if let success = json["success"] as? Int{
                            if success == 0 {
                                if let message = json["message"] as? String{
                                    if message == "notfound"{
                                        Alert.showAlert(inViewController: self, title: "Login Failed", message: "User is not exist")
                                    } else if message == "wrongpassword"{
                                        Alert.showAlert(inViewController: self, title: "Login Failed", message: "Password is incorrect")
                                    }
                                }
                            }else{
                                if let token = json["token"] as? String{
                                    print(token)

                                    self.dashboardController?.token = token
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                } catch let error {
                    
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    func handleRegister(){
        guard let username = usernameTextField.text?.trimmingCharacters(in: .whitespaces), let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
            else {
                return
        }
        if username.isEmpty || password.isEmpty{
            Alert.showAlert(inViewController: self, title: "Register Failed", message: "Username Or Password is not empty")
            return
        }
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["username": username, "password": password] as [String: String]
        
        //create the url with NSURL
        let urlLogin = NSURL(string: API_POST_REGISTER)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: urlLogin! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                        print(json)
                        
                        if let success = json["success"] as? Int{
                            if success == 0 {
                                if let message = json["message"] as? String{
                                    Alert.showAlert(inViewController: self, title: "Register Failed", message: message)
                                }
                            }else{
                                let parameters = ["username": username, "password": password] as [String: String]
                                let urlLogin = NSURL(string: self.API_POST_LOGIN)
                                let session = URLSession.shared
                                let request = NSMutableURLRequest(url: urlLogin! as URL)
                                request.httpMethod = "POST" //set http method as POST
                                do {
                                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata
                                    
                                } catch let error {
                                    print(error.localizedDescription)
                                }
                                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                                request.addValue("application/json", forHTTPHeaderField: "Accept")
                                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                                    guard error == nil else {
                                        return
                                    }
                                    guard let data = data else {
                                        return
                                    }
                                    do {
                                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: AnyObject] {
                                            print(json)
                                            if let success = json["success"] as? Int{
                                                if success == 0 {
                                                    print("ERRRORRRR")
                                                }else{
                                                    if let token = json["token"] as? String{
                                                        print(token)
                                                        
                                                        self.dashboardController?.token = token
                                                        self.dismiss(animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        }
                                    } catch let error {
                                        print(error.localizedDescription)
                                    }
                                    
                                })
                                task.resume()
                            }
                        }
                    }
                } catch let error {
                    
                    print(error.localizedDescription)
                }
            }
        })
        task.resume()
    }
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        tf.backgroundColor = UIColor.clear
        tf.attributedPlaceholder = NSAttributedString(string: "Username",attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardAppearance = .dark
        
        return tf
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.textColor = UIColor.white
        tf.backgroundColor = UIColor.clear
        tf.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bitcoin_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login","Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return segmentedControl
    }()
    
    @objc func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 12, g: 29, b: 53)
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func setupLoginRegisterSegmentedControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupInputsContainerView(){
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 91).isActive = true
        
        inputsContainerView.addSubview(usernameTextField)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(usernameSeparatorView)
        inputsContainerView.addSubview(passwordSeparatorView)
        
        
        //usernameTF constrain
        usernameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        usernameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //usernameSeparatorView
        usernameSeparatorView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor).isActive = true
        usernameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        usernameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        usernameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //passwordTF constrain
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: usernameSeparatorView.bottomAnchor, constant: 8).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //passwordSeparatorView
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    func setupLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 24).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1/2).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
extension UIColor{
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}

extension LoginController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
