//
//  LoginFormController.swift
//  Weather_Zebrev
//
//  Created by Rapax on 15.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import UIKit
import RealmSwift
import WebKit
import FirebaseAuth

class LoginFormController: UIViewController {

    @IBOutlet weak var webView: WKWebView! {
        didSet{
            webView.navigationDelegate = self
        }
    }

    //создаем экземпляр сервиса
//    let mainService     = MainService()
    let userDefaults    = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Realm.Configuration.defaultConfiguration  =  Realm.Configuration(  deleteRealmIfMigrationNeeded:  true)
        
        printPathRealData()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6223763"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            //URLQueryItem(name: "scope", value: "friends,photos,groups,offline"),
            URLQueryItem(name: "scope", value: "270342"),
            
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]

        
        let request = URLRequest(url: urlComponents.url!)
        //request.httpShouldHandleCookies = false
        webView.load(request)

        
        
        /*
         //получим  строку  из  хранилища
         let loginToken=userDefaults.string( forKey:  "token")
         
         if (loginToken=="exist") {
         print("успешная авторизация. найден ключ в хранилище")
         self.performSegue(withIdentifier: "sequeLoginOutId", sender: self)
         }
         else {
         print("неудачная авторизация. повтор запроса")
         }

 */
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 

}

extension LoginFormController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
            guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
            }
            
            let params = fragment
                .components(separatedBy: "&")
                .map { $0.components(separatedBy: "=") }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }
            
            print(params)
            
            
            MainService.currentUserId = Int(params["user_id"]!)!
            let token = params["access_token"]
            decisionHandler(.allow)
            
            MainService.accessToken = (token)!
            self.performSegue(withIdentifier: "sequeLoginOutId", sender: nil)
        
            //если авторизовались - подключимся к firebase
            Auth.auth().signIn(withEmail:  "rapax@list.ru",  password:  "123456")  {
                (user, error) in
                
                //in completion1(user  !=  nil )
                
                print("firebase connnect: user= \(user), error = \(error)")
            }

        }

}

