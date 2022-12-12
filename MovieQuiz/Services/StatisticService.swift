//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation
protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
} 
