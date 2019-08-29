//
//  APIRequestExtension.swift
//  MMBSwift
//
//  Created by jinzhenlu on 2019/8/7.
//  Copyright © 2019 jinzhenlu. All rights reserved.
//

import Foundation
import HandyJSON
import RxSwift
import Moya

extension ObservableType where Element == Response {
    public func mapModel<T: HandyJSON>(_ type:T.Type) ->Observable<T> {
        return flatMap { response -> Observable<T> in
            return Observable.just(try response.mapModel(T.self))
        }
    }
}

extension Response {
    func mapModel<T: HandyJSON>(_ type: T.Type) throws -> T {
        guard let object = JSONDeserializer<T>.deserializeFrom(json: try mapString()) else {
            throw MoyaError.jsonMapping(self)
        }
        return object
    }
}
