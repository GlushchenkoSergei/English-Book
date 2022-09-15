//
//  PageInteractor.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

protocol PageInteractorInputProtocol: AnyObject {
    var currentPage: Int { get set }
    init(presenter: PageInteractorOutputProtocol, nameBook: String, pages: [String])
    func provideBasicInformation()
    func providePageData(with width: Double)
    func provideNextPageData()
    func provideBackPageData()
    func provideWordsDatabase()
    func provideSelectedPage(number: Int)
}

protocol PageInteractorOutputProtocol: AnyObject {
    func receiveNameBook(with name: String, countPages: Int)
    func receivePageData(with nameData: PageData, page: Int)
    func receiveWordsDatabase(iKnowTheseWords: [WordIKnow], learnTheseWords: [LearnWord])
}

// MARK: - Interactor
class PageInteractor {
    
    unowned let presenter: PageInteractorOutputProtocol!
    
    var nameBook: String!
    var pages: [String]!
    var widthScreen: Double = 0

    var currentPage: Int {
        get {
            StorageManager.shared.getCurrentPageOf(book: nameBook)
        }
        set {
            StorageManager.shared.setCurrentPageOf(book: nameBook, page: newValue)
        }
    }
    
    required init(presenter: PageInteractorOutputProtocol, nameBook: String, pages: [String]) {
        self.presenter = presenter
        self.nameBook = nameBook
        self.pages = pages
    }

}

extension PageInteractor: PageInteractorInputProtocol {
    
    func provideBasicInformation() {
        presenter.receiveNameBook(with: nameBook, countPages: pages.count)
    }

    func providePageData(with width: Double) {
        widthScreen = width
        var componentsOfPage = TextAssistant.shared.divisionIntoParts(this: pages[currentPage])
        TextAssistant.shared.addingSpacerForLine(&componentsOfPage, widthScreen: width)
        
        let sizesForCells = CalculationWidthLabel.shared.createArrayWidthCells(componentsOfPage)
        
        let pageData = PageData(componentsOfPage: componentsOfPage, sizesForCells: sizesForCells)
        
        presenter.receivePageData(with: pageData, page: currentPage + 1)
//        presenter
    }
    
    func provideWordsDatabase() {
        let iKnowTheseWords = StorageManager.shared.fetchWordsIKnow() ?? []
        let learnTheseWords = StorageManager.shared.fetchLearnWords() ?? []
        
        presenter.receiveWordsDatabase(iKnowTheseWords: iKnowTheseWords, learnTheseWords: learnTheseWords)
    }
    
    func provideNextPageData() {
        if currentPage < pages.count - 1 {
            currentPage += 1
            providePageData(with: widthScreen)
        }
    }
    
    func provideBackPageData() {
        if currentPage > 0 {
            currentPage -= 1
            providePageData(with: widthScreen)
        }
    }
    
    func provideSelectedPage(number: Int) {
        if number > 0 && number <= pages.count {
            currentPage = number - 1
            providePageData(with: widthScreen)
        }
    }
    
}
