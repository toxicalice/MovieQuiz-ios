import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var contentStack: UIStackView!
    @IBOutlet private weak var loaderView: UIActivityIndicatorView!
    
    @IBAction private func noButtonDidTap(_ sender: Any) {
        let isCorrect = currentQuestion?.correctAnswer == false
        showAnswerResult(isCorrect: isCorrect)
    }
    
    @IBAction private func yesButtonDidTap(_ sender: Any) {
        let isCorrect = currentQuestion?.correctAnswer == true
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactory = QuestionFactory(moviesLoader: MoviesLoader())
    private var currentQuestion: QuizQuestion?
    
    private let presenter = MovieQuizPresenter()
    private var alertPresenter: AlertPresenter = AlertPresenter()
    private var statisticsService: StatisticService = StatisticServiceImplementation()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imageView.layer.cornerRadius = 20
        questionFactory.delegate = self
        alertPresenter.viewController = self
        
        loadData()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        show(quiz: viewModel)
    }
    
    func didFailToLoadData(with error: String) {
        showNetworkError(message: error)
    }
    
    func didLoadDataFromServer() {
        loaderView.isHidden = true
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - Private functions

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        
        if isCorrect == true {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
        
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        hideLoadingIndicator()
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = AlertModel(id: "Game results", title: result.title, message: result.text, buttonText: result.buttonText, completion: { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory.requestNextQuestion()
        })
        alertPresenter.makeAlertController(alertModel: alert)
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticsService.store(correct: correctAnswers, total: presenter.questionsAmount)

            let text = """
                Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                Количество сыгранных квизов: \(String(describing: statisticsService.gamesCount))
                Рекорд:\(String(describing:statisticsService.bestGame.correct))/\(String(describing:statisticsService.bestGame.total))(\(String(describing: statisticsService.bestGame.date.dateTimeString)))
                Средняя точность: \(String(format: "%.2f", statisticsService.totalAccuracy))%
                """
            
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!", text: text, buttonText: "Сыграть ещё раз"))
        } else {
            presenter.switchToNextQuestion()
            questionFactory.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String){
        let model = AlertModel(
            id: "Error",
            title: "Что-то пошло не так",
            message: "Невозможно загрузить данные",
            buttonText: "Попробовать еще раз")
        { [weak self] _ in
            self?.loadData()
        }
        
        alertPresenter.makeAlertController(alertModel: model)
    }
    
    private func loadData(){
        questionFactory.loadData()
        showLoadingIndicator()
    }
    
    private func showLoadingIndicator(){
        loaderView.isHidden = false
        contentStack.isHidden = true
    }
    
    private func hideLoadingIndicator(){
        loaderView.isHidden = true
        contentStack.isHidden = false
    }
}
