//
//  GestorWS.swift
//  WS-Connector
//
//  Created by QACG MAC2 on 8/23/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

typealias JSONObjects = [String: AnyObject]
typealias JSON = AnyObject
enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Sequence {
    public func failingFlatMap<T>( transform: (Self.Iterator.Element) throws -> T?) rethrows -> [T]? {
        var result: [T] = []
        for element in self {
            guard let transformed = try transform(element) else { return nil }
            result.append(transformed)
        }
        return result
    }
}

private let url = NSURL(string: "URL_MASTER".localized)!
private let contexts = "login"
private let body : NSDictionary = [
    "username" : "admin",
    "password" : "123"
]

var all = SimpleRequest<Any>(url: url as NSURL, parser: { data in
    // let json = try? JSONSerialization.jsonObject(with: data as Data, options: [])
    //  print(json)
    return data
})

var request = ParametrosRequest<NSDictionary>(url: url as URL, bodys: body as! JSONDictionary , contexts: contexts , parses: { data in
    var dataString = String(data: data as Data, encoding: String.Encoding.utf8)!
    var dataStrings = String(data: data as Data, encoding: String.Encoding.ascii)!
    var dataStrinss = String(data: data as Data, encoding: String.Encoding.unicode)!
    // print(dataString)
    // print(dataStrings)
    /*dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
     let cleanData: NSData = dataString.dataUsingEncoding(String.Encoding.utf8)! as NSData
     //print all content response
     */
    do {
        if let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary {
            // print(jsonResult)
            return jsonResult
        }
    } catch let error as NSError {
        // print(error.localizedDescription)
    }
    return nil
})

var indicador: UIActivityIndicatorView!
enum ResultType {
    case Success(r: NSDictionary)
    case Error(e: Error)
}

final class GestorPeticiones {
    func checkConnectWS<A>(resource: SimpleRequest<A>, completion: @escaping (A?) -> ()){
        let url = NSURL(string: "URL_MASTER".localized)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            print("\(String(describing: error))")
            if error != nil {
                print("Error de conexxion")
                //completion(ResultType.Error(e: error!))
                completion(nil)
            } else {
                print("Connnected ok")
                completion(resource.parser(data! as NSData ))
            }
        }
        task.resume()
    }
    
    func sendAnyRequest<A>(resource: ParametrosRequest<A>, completion: @escaping (A?) -> ()){
        //  print("url \(resource.url)")
        print("body reqyest\(resource.bodys)" )
        //  print(" \(resource.contexts)" )
        let newURL = NSURL(string:  String(format: "%@%@" ,resource.url as CVarArg, resource.contexts)
            )!
        print(" nueva URL \(newURL)" )
        let request = NSMutableURLRequest(url: newURL as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: resource.bodys, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //  request.timeoutInterval = 70
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
           // print("Response: \(response)")
            if let HTTPResponse = response as? HTTPURLResponse {
                let sCode = HTTPResponse.statusCode
                print("statusCode: \(sCode)")
                if sCode == 200 {
             //       print("Response: \(response)")
                    DispatchQueue.main.async {
                        if let data = data {
                            completion(resource.parses((data as NSData) as Data as Data as NSData))
                        } else {
                            completion(nil)
                        }
                    }
                } else if sCode == 400 {
                 //   print("Response: \(response)")
                    DispatchQueue.main.async {
                        if let data = data {
                            completion(resource.parses((data as NSData) as Data as Data as NSData))
                        } else {
                            completion(nil)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                          print("Response error: \(String(describing: response))")
                    }
                }
            }
        })
        task.resume()
    }
}
