//
//  MainService.swift
//  GroupVK_ZebrevAndrey
//
//  Created by Rapax on 28.09.17.
//  Copyright © 2017 Rapax. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

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


func  printPathRealData() {
    do {
        //  получаем  доступ к   хранилищу
        let realm  = try  Realm( )
        
        print(realm.configuration.fileURL)
    }
    catch {
        //  если  произошла  ошибка,  выводим  ее  в к онсоль
        print(  error)
    }
    
    
    let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first 
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first 
    let tmpDirectory = FileManager.default.temporaryDirectory 
    
    print("cachesDirectory = \(cachesDirectory)")
    print("documentsDirectory = \(documentsDirectory)")
    print("tmpDirectory = \(tmpDirectory)")
}

class MainService {
 
    /*
     //let clientId = "6200602" // ID приложения
     //базовый url сервиса
     //let baseUrl = "https://oauth.vk.com"
     
     //запрос чтобы получить токен
     //https://oauth.vk.com/authorize?client_id=6223763&display=page&redirect_uri=&scope=friends,photos,groups,offline&response_type=token&v=5.68

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


    static var currentUserId = 0       //35390381
   
    //ключ для доступа к сервису offline
    static var accessToken = ""        //

    //базовый url сервиса
    let baseUrl = "https://api.vk.com"

    //запрос на список друзей (5)
    //"https://api.vk.com/method/friends.search?count=5&v=5.68&access_token=" + accessToken
  

    
    //func loadFriendVK(completionHandler: @escaping () -> () ) {
    func loadFriendVK() {

        let path = "/method/friends.search?"

        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path

        //параметры
        let parameters: Parameters = [
            "count": 15,
            "access_token": MainService.accessToken,
            "v": "5.68",
            "fields" : "photo_200_orig,photo_50,nickname"
        ]
        
        //указываем другую очередь
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) {
            response in

            //guard let data = response.value else { return }
            //print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                
                //print("\nУспешно считали список друзей")

                let json = JSON(value)
                
                //print(json)
                //let  friend  = json["response"]["items"].flatMap {User (json: $0.1) }
                let  friend  = json["response"]["items"].array?.flatMap {User (json: $0) } ?? []
                //let  photo  = json["response"]["items"].array?.flatMap {Photo (json: $0) } ?? []
                //print(friend)

                //данные сохраняем в реалм в отдельном потоке что выше указан
                Realm.replaceAllObjectOfType(toNewObjects: friend)
                
                //все сохраняется в базе данных - нет смысла хранить в замыканиях массив данных
                //completionHandler(friend)
                //completionHandler()
                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }

        /*
        Alamofire.request(url, method: .get, parameters: parameters).responseData { (response) in
            
            print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let  friend  = json["response"]["items"].flatMap {User (json: $0.1) }
                print(friend)

            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
*/
    }

   
    func loadFriendFotoVK(forUser user: Int, completionHandler: @escaping ([Photo]) -> Void){
        
        
        let path = "/method/photos.get?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "owner_id": user,
            "album_id": "profile",
            "count": 200,
            "access_token": MainService.accessToken,
            "v": "5.68"
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { (response) in
            
//            print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print ("JSON: \(json)")

                //print("\nУспешно считали фото")
                
                let  photo  = json["response"]["items"].flatMap {Photo (json: $0.1) }

                //Realm.replaceAllObjectOfType(toNewObjects: photo)
                
                DispatchQueue.main.async {
                                    completionHandler(photo)
                }




            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

    
    
    //func loadGroupVK(completionHandler: @escaping () -> () ){
    func loadGroupVK() {
        
        
        let path = "/method/groups.get?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "user_id": MainService.currentUserId,
            "extended":1,
            "count": 5,
            "access_token": MainService.accessToken,
            "v": "5.68",
            "fields": "members_count"           //+опциональные дополнительные поля
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { (response) in
            
            //print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                //print ("JSON: \(json)")

                //print("\nУспешно считали список групп")
                
                let  group  = json["response"]["items"].array?.flatMap {Group (json: $0) } ?? []
                
                Realm.replaceAllObjectOfType(toNewObjects: group)

                //completionHandler()

/*
                for (_, userJson) in json["response"]["items"] {
                    
                    let id = userJson["id"].intValue
                    let name = userJson["name"].stringValue
                   
                    print("id group = \(id)", name)
                    
                    
                }
  */
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

    
    func loadAndSearchGroupVK(searchText: String, completionHandler: @escaping ([Group]) -> () ){
        
        
        let path = "/method/groups.search?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "count": 20,
            "access_token": MainService.accessToken,
            "v": "5.68",
            "q": searchText
        ]
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { (response) in
            
            //print("\(response.result)\n")
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print ("JSON: \(json)")
                
//                print("\nПоиск групп завершен")
                
                let  group  = json["response"]["items"].flatMap {Group (json: $0.1) }
             
                DispatchQueue.main.async {
                    completionHandler(group)
                }


                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }

   
    func loadFriends() -> [User] {
        do {
            let realm = try Realm()
//            let user  = realm.objects(User.self)
//            self.user  =  Array(user)
            return Array(realm.objects(User.self))
        } catch {
            print(error)
            return []
        }
    }

    
    func loadGroups() -> [Group] {
        do {
            let realm = try Realm()
            return Array(realm.objects(Group.self))
        } catch {
            print(error)
            return []
        }
    }

    func joinToGroup(groupID: Int, completion: @escaping () -> () ) {

        let path = "/method/groups.join?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "group_id": groupID,
            "access_token": MainService.accessToken,
            "v": "5.68"
        ]

        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { response in
            completion()
        }
    }
    
    func leaveFromGroup(groupID: Int, completion: @escaping () -> () ) {
        
        let path = "/method/groups.leave?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        //параметры
        let parameters: Parameters = [
            "group_id": groupID,
            "access_token": MainService.accessToken,
            "v": "5.68"
        ]

        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { response in
            completion()
        }
    }

    
    
    private let parser: JsonParser1 = ParserFactory().newsFeed()
    
    func downloadsNews(completionHandler: @escaping ([News]) -> Void){
        
        var path = "/method/newsfeed.get"
        
        var parameters: Parameters {
            return [
                "filters": "post,photo",
                "access_token": MainService.accessToken,
                "v": "5.68",
                "count": 20
            ]
        }

        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
       
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                //print ("JSON: \(json)")
                
                //let  news  = json["response"]["items"].flatMap {News (json: $0.1) }
                let news = self.parser.parse(json) as? [News]
                
                //добавляю асинхронную загрузку данных
                DispatchQueue.main.async {
                    completionHandler(news ?? [])
                }

//                completionHandler(news ?? [])

                //Realm.replaceAllObjectOfType(toNewObjects: photo)
                
//                completionHandler(news)
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }


    
    //private let parserWalls: JsonParser1 = ParserFactory().newsFeed()
    
    func downloadsWalls(completionHandler: @escaping ([Walls]) -> Void){
        
        var path = "/method/wall.get"
        
        var parameters: Parameters {
            return [
                "owner_id": MainService.currentUserId,
                "access_token": MainService.accessToken,
                "v": "5.68",
                "count": 20
            ]
        }
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print ("walls JSON: \(json)")
                
                let walls  = json["response"]["items"].flatMap {Walls (json: $0.1) }

                //добавляю асинхронную загрузку данных
                DispatchQueue.main.async {
                    completionHandler(walls)
                }
                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }
        }
        
    }


    func postWall(message: String?, attachments: String?, completion: @escaping (String) -> Void) {
        
        let path = "/method/wall.post?"
        
        //составляем url из базового адреса сервиса и кокртетного пути к ресурсу
        let url = baseUrl+path

        //параметры
        var parameters: Parameters = [
            "owner_id": MainService.currentUserId,
            "access_token": MainService.accessToken,
            "v": "5.68"
        ]

        if let attachments = attachments {
            parameters["attachments"] = attachments
        }
        if let message1 = message {
            parameters["message"] = message1
        }

        Alamofire.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInitiated)) { response in

            switch response.result {
            case .success(let value):
                
                //print("value = \(value)")
                completion("success")
                
            case .failure(let error):
                print("Error while quering database: \(String(describing: error))")
                return
            }

        }
    }


}
