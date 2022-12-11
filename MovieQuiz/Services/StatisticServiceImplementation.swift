//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation
final class StatisticServiceImplementation: StatisticService {
    
    private(set) var totalCorrect: Int {
           get {
               return userDefaults.integer(forKey: Keys.correct.rawValue)
           }
           set {
               userDefaults.set(newValue, forKey: Keys.correct.rawValue)
           }
       }

       private(set) var totalAnswers: Int {
           get {
               return userDefaults.integer(forKey: Keys.total.rawValue)
           }
           set {
               userDefaults.set(newValue, forKey: Keys.total.rawValue)
           }
       }

       internal var totalAccuracy: Double {
           get {
               return Double(totalCorrect) / Double(totalAnswers) * 100
           }
       }

       private(set) var gamesCount: Int {
           get {
               return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
           }
           set {
               userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
           }
       }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    func store(correct count: Int, total amount: Int) {

        gamesCount += 1
        totalCorrect += count
        totalAnswers += amount

        if amount >= bestGame.correct {
            bestGame = GameRecord(
                correct: count,
                total: amount,
                date: Date()
            )
        }
    }
}
