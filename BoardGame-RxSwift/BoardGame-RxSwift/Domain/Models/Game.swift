//
//  Game.swift
//  BoardGame-RxSwift
//
//  Created by Phetsana PHOMMARINH on 23/10/2020.
//

import Foundation

struct Games: Codable {
    let games: [Game]
}

struct Game: Codable, Identifiable {
    let id: String
    let name: String?
    let imageUrl: URL?
    let thumbUrl: URL?
    let yearPublished: Int?
    let minPlayers: Int
    let maxPlayers: Int
    let description: String?
    let primaryPublisher: String?
    let rank: Int
    let trendingRank: Int
}
