//
//  MainService.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 28.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyVK


/*
 //делаем запрос
 //Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
 
 guard case let .failure(error) = response.result else { return }
 
 if let error = error as? AFError {
 switch error {
 case .invalidURL(let url):
 print("Invalid URL: \(url) - \(error.localizedDescription)")
 case .parameterEncodingFailed(let reason):
 print("Parameter encoding failed: \(error.localizedDescription)")
 print("Failure Reason: \(reason)")
 case .multipartEncodingFailed(let reason):
 print("Multipart encoding failed: \(error.localizedDescription)")
 print("Failure Reason: \(reason)")
 case .responseValidationFailed(let reason):
 print("Response validation failed: \(error.localizedDescription)")
 print("Failure Reason: \(reason)")
 
 switch reason {
 case .dataFileNil, .dataFileReadFailed:
 print("Downloaded file could not be read")
 case .missingContentType(let acceptableContentTypes):
 print("Content Type Missing: \(acceptableContentTypes)")
 case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
 print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
 case .unacceptableStatusCode(let code):
 print("Response status code was unacceptable: \(code)")
 }
 case .responseSerializationFailed(let reason):
 print("Response serialization failed: \(error.localizedDescription)")
 print("Failure Reason: \(reason)")
 }
 
 print("Underlying error: \(error.underlyingError)")
 } else if let error = error as? URLError {
 print("URLError occurred: \(error)")
 } else {
 print("Unknown error: \(error)")
 }
 
 print("\(response.result)")
 switch response.result {
 case .success(let value):
 let json = JSON(value)
 print ("JSON: \(json)")
 
 if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
 print("Data: \(utf8Text)") // original server data as UTF8 string
 }
 
 case .failure(let error):
 print("Error while quering database: \(String(describing: error))")
 return
 }

 */

class MainService {
 
    /*
     //let clientId = "6200602" // ID приложения
     //базовый url сервиса
     //let baseUrl = "https://oauth.vk.com"
     
     //запрос чтобы получить токен
     //https://oauth.vk.com/authorize?client_id=6200602&display=page&redirect_uri=&scope=friends,photos,groups,offline&response_type=token&v=5.68

     let path = "/authorize?"
     //параметры, город, еденицы измерения градусы, ключ для доступа к сервису
     let parameters: Parameters = [
     "client_id": clientId,
     "display": "mobile",
     "redirect_uri": "https://oauth.vk.com/blank.html",
     "scope": "friends",
     "response_type": "token",
     "v": "5.68"
     ]
     
     //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
     let url = baseUrl+path
     */

    let currentUserId = 35390381
   
    //ключ для доступа к сервису offline
    let accessToken = "2317f563b87c4fde7cf98c23288ce39ba9977722c18a821924c2213f4535083cec4e7e3a7687ca9c87d59"

    //базовый url сервиса
    let baseUrl = "https://api.vk.com"

    //запрос на список друзей (5)
    //"https://api.vk.com/method/friends.search?count=5&v=5.68&access_token=" + accessToken

    func loadFriendVK(){

        let path = "/method/friends.search?"

        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path

        //параметры
        let parameters: Parameters = [
            "count": 5,
            "access_token": accessToken,
            "v": "5.68"
        ]
        
       
        Alamofire.request(url, method: .get, parameters: parameters).responseData { (response) in
            
            print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print ("JSON: \(json)")
                
                //if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //    print("Data: \(utf8Text)") // original server data as UTF8 string
                //}

                for (_, userJson) in json["response"]["items"] {
                    
                    let id = userJson["id"].intValue
                    let name = userJson["first_name"].stringValue
                    let username = userJson["last_name"].stringValue
                    
                    print("id friend = \(id)", name, username)
                    
                    
                }

            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

    
   
    func loadFriendFotoVK(){
        
        
        let path = "/method/photos.get?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "owner_id": currentUserId,
            "album_id": "profile",
            "count": 5,
            "access_token": accessToken,
            "v": "5.68"
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { (response) in
            
            print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print ("JSON: \(json)")
                
                for (_, userJson) in json["response"]["items"] {
                    
                    let id = userJson["id"].intValue
                    let photo2560 = userJson["photo_2560"].stringValue
                    let countLike = userJson["likes"]["count"].intValue
                    
                    print("id photo = \(id)", photo2560, countLike)
                    
                    
                }
                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

    
    
    func loadGroupVK(){
        
        
        let path = "/method/groups.get?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "user_id": currentUserId,
            "extended":1,
            "count": 5,
            "access_token": accessToken,
            "v": "5.68"
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { (response) in
            
            print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print ("JSON: \(json)")
                
               
                for (_, userJson) in json["response"]["items"] {
                    
                    let id = userJson["id"].intValue
                    let name = userJson["name"].stringValue
                   
                    print("id group = \(id)", name)
                    
                    
                }
                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

    
}
