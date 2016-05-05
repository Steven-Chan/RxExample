//
//  FrontState.swift
//  RxExample
//
//  Created by Steven Chan on 30/4/2016.
//  Copyright © 2016 oursky. All rights reserved.
//

import UIKit
import RxSwift

let AppFrontState = FrontState()

struct SearchResultViewModel {
    let keywords = AppBackState.stackOverflowSearch.keywords.asObservable()

    let wordCount = AppBackState.stackOverflowSearch.keywords.asObservable()
        .map { $0.characters.count }

    let result = AppBackState.stackOverflowSearch.searchResult.asObservable()
        .map { $0.result }

    let resultCount = AppBackState.stackOverflowSearch.searchResult.asObservable()
        .map { $0.result.count }

    let resultCountBackgroundColor = AppBackState.stackOverflowSearch.searchResult.asObservable()
        .map { UIColor(red: 1.0, green: 0.0, blue: CGFloat($0.progress), alpha: 1.0) }

    let fxxkWarning = AppBackState.stackOverflowSearch.keywords.asObservable()
        .map { $0.lowercaseString.rangeOfString("fxxk") != nil }

    var keywordsTextColor: Observable<UIColor> {
        get {
            return fxxkWarning.map { $0 ? UIColor.redColor() : UIColor.blackColor() }
        }
    }

    var filteredKeywords: Observable<String> {
        get {
            return Observable
                .zip(
                    fxxkWarning,
                    keywords
                ) { ($0, $1) }
                .scan((false, "")) { $0.0 && $1.0 ? $0 : $1 }
                .map { $0.1 }
        }
    }
}

struct FrontState {
    let stackOverflowSearchViewModel = SearchResultViewModel()
}
