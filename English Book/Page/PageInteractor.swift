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
}

protocol PageInteractorOutputProtocol: AnyObject {
    func receiveNameBook(with name: String, countPages: Int)
    func receivePageData(with nameData: PageData)
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
    
    private func divisionIntoParts(this text: String) -> [String] {
        var components: [String] = []
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords) { _, _, enclosingRange, _ in
            components.append(String(text[enclosingRange]))
        }
        return components
    }
    
    private func addingSpacerForLine(_ componentsOfPage: inout [String]) {
        var value = 0
        var counterOneLine = 0
        
        for index in 0...componentsOfPage.count - 1 {
            
            value += componentsOfPage[index].count
            
            if value > 31 {
                let x = 31 - counterOneLine
                guard x > 0 else { return }
                for _ in 0...x {
                    componentsOfPage[index - 1] += " "
                }
                counterOneLine = 0
                value = componentsOfPage[index].count
            }
            counterOneLine += componentsOfPage[index].count
        }
    }
    
}

extension PageInteractor: PageInteractorInputProtocol {
    
    func provideBasicInformation() {
        presenter.receiveNameBook(with: nameBook, countPages: pages.count)
    }
    
    func providePageData() {
        var componentsOfPage = divisionIntoParts(this: pages[currentPage])
        addingSpacerForLine(&componentsOfPage)
        
        let sizesForCells = CalculationWidthLabel.shared.createArrayWidthCells(componentsOfPage)
    
        let pageData = PageData(componentsOfPage: componentsOfPage, sizesForCells: sizesForCells)
        
        presenter.receivePageData(with: pageData)
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
