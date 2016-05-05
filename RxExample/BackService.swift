//
//  BackService.swift
//  RxExample
//
//  Created by Steven Chan on 30/4/2016.
//  Copyright © 2016 oursky. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

func stackOverflowResultMapper(result: AnyObject?) -> [String] {
    if result == nil {
        return []
    }

    return (result!["items"] as! NSArray)
        .map { ($0 as! NSDictionary)["title"] as! String }
}

func searchStackOverflow(keywords: String) throws -> Observable<(Float, AnyObject?)> {
    if keywords.characters.count == 0 {
        return Observable.just((0, nil))
    }

    let endpoint = "https://api.stackexchange.com/2.2/search?order=desc&sort=activity&site=stackoverflow&intitle="
    let request = Manager.sharedInstance.request(.GET, endpoint + keywords)

    let progress = request.rx_progress()
    let json = request.rx_JSON()

    return Observable
        .combineLatest(progress, json) { ($0.floatValue(), $1) }
}
