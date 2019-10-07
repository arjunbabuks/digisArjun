//
//  loginResponse.swift
//  Task
//
//  Created by Arjun babu k.s on 10/7/19.
//  Copyright © 2019 Arjun babu k.s. All rights reserved.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let message: String
    let success: Bool
    let payload: PayloadInLogin
}

// MARK: - Payload
struct PayloadInLogin: Codable {
    let referenceNo: Int
}
