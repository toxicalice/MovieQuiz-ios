//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
}
