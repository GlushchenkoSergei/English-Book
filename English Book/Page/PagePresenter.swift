//
//  PagePresenter.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

import Foundation

struct PageData {
//    let nameBook: String
    let componentsOfPage: [String]
    let sizesForCells: [Double]
//    let numberOfPages: Int
}

class PagePresenter: PageViewControllerOutputProtocol {
    
    unowned let view: PageViewControllerInputProtocol
    var interactor: PageInteractorInputProtocol!
    
    required init(view: PageViewControllerInputProtocol) {
        self.view = view
    }
    
    func showPages() {
        interactor.provideBasicInformation()
        interactor.providePageData()
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
    
    
}
