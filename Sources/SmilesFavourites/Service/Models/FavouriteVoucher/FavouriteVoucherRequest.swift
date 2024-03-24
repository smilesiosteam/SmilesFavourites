//
//  File.swift
//
//
//  Created by Hafiz Muhammad Junaid on 11/03/2024.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

class FavouriteVoucherRequest: SmilesBaseMainRequest {
    
    //    var userInfo: AppUserInfo?
    var pageNo: Double?
    var locationLatitude: Double?
    var locationLongitude: Double?
    
    enum CodingKeys: String, CodingKey {
        //        case userInfo
        case pageNo
        case locationLatitude
        case locationLongitude
    }
    
    override init() {
        super.init()
    }
    
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Property Encoder
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.pageNo, forKey: .pageNo)
        try container.encodeIfPresent(self.locationLatitude, forKey: .locationLatitude)
        try container.encodeIfPresent(self.locationLongitude, forKey: .locationLongitude)
    }
    
    //    required init(from decoder: Decoder) throws {
    //        let values = try decoder.container(keyedBy: CodingKeys.self)
    ////        userInfo = try values.decodeIfPresent(AppUserInfo.self, forKey: .userInfo)
    //        pageNo = try values.decodeIfPresent(Double.self, forKey: .pageNo)
    //        locationLatitude = try values.decodeIfPresent(Double.self, forKey: .locationLatitude)
    //        locationLongitude = try values.decodeIfPresent(Double.self, forKey: .locationLongitude)
    //    }
    //
    //    func asDictionary(dictionary: [String: Any]) -> [String: Any] {
    //        let encoder = DictionaryEncoder()
    //        guard let encoded = try? encoder.encode(self) as [String: Any] else {
    //            return [:]
    //        }
    //        return encoded.mergeDictionaries(dictionary: dictionary)
    //    }
}
