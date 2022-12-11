//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation
protocol QuestionFactoryDelegate: class {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
