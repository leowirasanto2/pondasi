//
//  Profile.swift
//  PondasiContracts
//
//  Created by Leo Wirasanto Laia on 02/04/26.
//

import Foundation

public struct Profile: Equatable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let profilePicture: ProfilePicture

    public init(id: String, firstName: String, lastName: String, profilePicture: ProfilePicture) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.profilePicture = profilePicture
    }
}

public struct ProfilePicture: Equatable {
    public let id: String
    public let fileName: String
    public let filePath: String

    public init(id: String, fileName: String, filePath: String) {
        self.id = id
        self.fileName = fileName
        self.filePath = filePath
    }
}
