//
//  PageInteractor.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

//import Foundation

protocol PageInteractorInputProtocol: AnyObject {
    var currentPage: Int { get set }
    init(presenter: PageInteractorOutputProtocol, nameBook: String, pages: [String])
    func provideBasicInformation()
    func providePageData()
    func provideNextPageData()
    func provideBackPageData()
    func provideWordsDatabase()
}

protocol PageInteractorOutputProtocol: AnyObject {
    func receiveNameBook(with name: String, countPages: Int)
    func receivePageData(with nameData: PageData)
    func receiveWordsDatabase(iKnowTheseWords: [WordIKnow], learnTheseWords: [LearnWord])
}

// MARK: -  Interactor
class PageInteractor {
    
    unowned let presenter: PageInteractorOutputProtocol!
    
    var nameBook: String!
    var pages: [String]!
    
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
    
    func providePageData() {
        var componentsOfPage = TextAssistant.shared.divisionIntoParts(this: pages[currentPage])
        TextAssistant.shared.addingSpacerForLine(&componentsOfPage)
        
        let sizesForCells = CalculationWidthLabel.shared.createArrayWidthCells(componentsOfPage)
        
        let pageData = PageData(componentsOfPage: componentsOfPage, sizesForCells: sizesForCells)
        
        presenter.receivePageData(with: pageData)
    }
    
    func provideWordsDatabase() {
        let iKnowTheseWords = StorageManager.shared.fetchWordsIKnow() ?? []
        let learnTheseWords = StorageManager.shared.fetchLearnWords() ?? []
        
        presenter.receiveWordsDatabase(iKnowTheseWords: iKnowTheseWords, learnTheseWords: learnTheseWords)
    }
    
    
    func provideNextPageData() {
        if currentPage <= pages.count {
            currentPage += 1
            providePageData()
        }
    }
    
    func provideBackPageData() {
        if currentPage > 0 {
            currentPage -= 1
            providePageData()
        }
    }
    
}
