//
//  PagePresenter.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

import Foundation

struct PageData {
    let componentsOfPage: [String]
    let sizesForCells: [Double]
}

class PagePresenter: PageViewControllerOutputProtocol {
    
    unowned let view: PageViewControllerInputProtocol
    var interactor: PageInteractorInputProtocol!
    
    required init(view: PageViewControllerInputProtocol) {
        self.view = view
    }
     
    func showPages(with width: Double) {
        interactor.provideBasicInformation()
        interactor.providePageData(with: width)
//        print("Из presenter \(width - 32)")
    }
    
    func getWordsDatabase() {
        interactor.provideWordsDatabase()
    }
    
    func nextButtonPressed() {
        interactor.provideNextPageData()
    }
    
    func backButtonPressed() {
        interactor.provideBackPageData()
    }
    
}

extension PagePresenter: PageInteractorOutputProtocol {
    
    func receiveNameBook(with name: String, countPages: Int) {
        view.displayTitleBook(with: name)
        view.displayNumberOfPages(with: String(countPages))
    }
    
    func receivePageData(with pageData: PageData) {
        view.getComponentsOfPage(with: pageData.componentsOfPage)
        view.getArrayWidthCell(sizesForCells: pageData.sizesForCells)
    }
    
    func receiveWordsDatabase(iKnowTheseWords: [WordIKnow], learnTheseWords: [LearnWord]) {
        view.displayWordsIKnow(iKnowTheseWords: iKnowTheseWords)
        view.displayWordsLearn(learnTheseWords: learnTheseWords)
    }
    
}
