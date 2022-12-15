//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let id: String
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
