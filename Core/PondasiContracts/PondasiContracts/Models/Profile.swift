//
//  Profile.swift
//  PondasiContracts
//
//  Created by Leo Wirasanto Laia on 02/04/26.
//

import Foundation

public struct Profile: Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let profilePicture: ProfilePicture
}

public struct ProfilePicture: Equatable {
    let id: String
    let fileName: String
    let filePath: String
}
