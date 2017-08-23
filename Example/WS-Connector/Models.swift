//
//  Models.swift
//  WS-Connector
//
//  Created by QACG MAC2 on 8/23/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

struct ParametrosRequest <A>  {
    var url: URL
    var bodys: Any
    var contexts: String
    let parses: (NSData) -> A?
    
}

struct SimpleRequest <A> {
    let url: NSURL
    let parser: (NSData) -> A?
}
