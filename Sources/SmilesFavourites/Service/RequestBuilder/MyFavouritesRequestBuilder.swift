//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 07/03/2024.
//

import Foundation
import NetworkingLayer
import SmilesUtilities

// if you wish you can have multiple services like this in a project
enum MyFavouritesRequestBuilder {
    // organise all the end points here for clarity
    case getFavouriteStackList(request: FavouriteStackListRequest)
    case getFavouriteVoucher(request: FavouriteVoucherRequest)
    case getFavouriteFood(request: FavouriteFoodRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getFavouriteStackList, .getFavouriteVoucher, .getFavouriteFood:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(endPoint: MyFavouritesEndPoint) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(from: AppCommonMethods.serviceBaseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getFavouriteStackList(let request):
            return request
        case .getFavouriteVoucher(let request):
            return request
        case .getFavouriteFood(let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(from baseUrl: String, for endPoint: MyFavouritesEndPoint) -> String {
        let endPoint = endPoint.url
        
        switch self {
        case .getFavouriteStackList:
            return "\(baseUrl)\(endPoint)"
        case .getFavouriteVoucher:
            return "\(baseUrl)\(endPoint)"
        case .getFavouriteFood:
            return "\(baseUrl)\(endPoint)"
        }
    }
}
