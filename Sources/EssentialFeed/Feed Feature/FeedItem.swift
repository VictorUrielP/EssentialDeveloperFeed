//
//  File.swift
//  
//
//  Created by Victor Pacheco on 23/12/20.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
