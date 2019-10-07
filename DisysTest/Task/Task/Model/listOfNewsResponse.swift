//
//  listOfNewsResponse.swift
//  Task
//
//  Created by Arjun babu k.s on 10/7/19.
//  Copyright © 2019 Arjun babu k.s. All rights reserved.
//

import Foundation

//MARK: - ListOfNewsResponse
struct ListOfNewsResponse: Codable {
    let payload: [Payload]
    let success: Bool
}

// MARK: - Payload
struct Payload: Codable {
    let title, payloadDescription: String
    let date: DateEnum
    let image: String

    enum CodingKeys: String, CodingKey {
        case title
        case payloadDescription = "description"
        case date, image
    }
}

enum DateEnum: String, Codable {
    case the02Mar2016 = "02-Mar-2016"
    case the29Feb2016 = "29-Feb-2016"
}
