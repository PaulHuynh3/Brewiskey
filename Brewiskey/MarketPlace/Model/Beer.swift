//
//  Beer.swift
//  Brewiskey
//
//  Created by Paul on 2019-03-23.
//  Copyright © 2019 Paul. All rights reserved.
//

import Foundation

struct Beer: Decodable {
    let alcoholPercent: String
    let country: String
    let name: String
    let singleBottle: BeerSingleMetaData
    let singleCan: BeerSingleMetaData
    let sixPackBottle: BeerSixPackMetaData
    let sixPackCan: BeerSixPackMetaData
    

//    let shortDescription: String
//    let singleCanPrice: Double
//    let singleCanContent: Int
//    let singleCanImageUrlString: String
//    let singleCanType: String
//    let singleBottlePrice: Double
//    let singleBottleContent: Int
//    let singleBottleImageUrlString: String
//    let singleBottleType: String
//    let sixPackCanPrice: Double
//    let sixPackCanImageUrlString: String
//    let sixPackCanType: String
//    let sixPackBottlePrice: Double
//    let sixPackBottleImageUrlString: String
//    let sixPackBottleType: String
}

struct BeerSingleMetaData: Decodable {
    let content: String
    let imageUrl: String
    let price: Double
    let type: String
}

struct BeerSixPackMetaData: Decodable {
    let imageUrl: String
    let price: Double
    let type: String
}
