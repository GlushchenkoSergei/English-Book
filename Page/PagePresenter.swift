//
//  PagePresenter.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

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
    
    func selectionPage(number: String?) {
        guard let numberInt = Int(number ?? "") else { return }
        interactor.provideSelectedPage(number: numberInt)
    }
    
}

extension PagePresenter: PageInteractorOutputProtocol {
    
    func receiveNameBook(with name: String, countPages: Int) {
        view.displayTitleBook(with: name)
        view.displayNumberOfPages(with: String(countPages))
    }
    
    func receivePageData(with pageData: PageData, page: Int) {
        view.getComponentsOfPage(with: pageData.componentsOfPage)
        view.getArrayWidthCell(sizesForCells: pageData.sizesForCells)
        view.reloadData()
        view.displayCurrentPage(String(page))
    }
    
    func receiveWordsDatabase(iKnowTheseWords: [WordIKnow], learnTheseWords: [LearnWord]) {
        view.displayWordsIKnow(iKnowTheseWords: iKnowTheseWords)
        view.displayWordsLearn(learnTheseWords: learnTheseWords)
    }
    
}
