import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    private var correctAnswers:Int = 0
    
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion {
        get{
            questions[currentQuestionIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewModel = convert(model: currentQuestion)
        show(quiz: viewModel)
    }
    
    private func checkAnswer (answer: Bool) -> Bool {
        if currentQuestion.correctAnswer == answer {
            correctAnswers += 1
        }
        return currentQuestion.correctAnswer == answer
    }
    
    @IBAction func NoButtonDidTap(_ sender: Any) {
        let isCorrect = checkAnswer(answer: false)
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction func YesButtonDidTap(_ sender: Any) {
        let isCorrect = checkAnswer(answer: true)
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 6

        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        // сюда бы я добавила дизейбл кнопки, но мне лень
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func show(quiz step: QuizStepViewModel) {
      // здесь мы заполняем нашу картинку, текст и счётчик данными
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }

    private func show(quiz result: QuizResultsViewModel) {
      // здесь мы показываем результат прохождения квиза
        let alert = UIAlertController (title: result.title, message: result.text, preferredStyle: .alert)
        
        let action = UIAlertAction (title: result.buttonText, style: .default) { [weak self] _ in 
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let firstQuestion = questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
            
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // конвертер
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let image = UIImage(named: model.image) ?? UIImage()
        let number = questions.firstIndex { question in
            model.image == question.image
        }
        return QuizStepViewModel(image: image, question: model.text,
                                 questionNumber: "\((number ?? 0) + 1)/ \(questions.count)")
    }
    
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат: \(correctAnswers)/\(questions.count)", buttonText: "Сыграть ещё раз"))
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
}




// для состояния "Вопрос задан"
struct QuizStepViewModel {
  var image: UIImage
  let question: String
  let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
