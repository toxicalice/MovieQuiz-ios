//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alice on 10.12.2022.
//

import Foundation
import UIKit

struct AlertPresenter {

    weak var viewController: UIViewController?

    internal func makeAlertController(alertModel: AlertModel) {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default,
            handler: alertModel.completion)

        alert.addAction(action)

        viewController.present(alert, animated: true)
    }
}
