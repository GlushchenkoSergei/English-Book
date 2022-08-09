//
//  PageConfigurator.swift
//  English Book
//
//  Created by mac on 04.08.2022.
//

protocol PageConfiguratorInputProtocol {
    func configure(with view: PageViewController, and pagesOfBook: [String], nameBook: String)
}

class PageConfigurator: PageConfiguratorInputProtocol {
    
    
    func configure(with view: PageViewController, and pagesOfBook: [String], nameBook: String) {
        let presenter = PagePresenter(view: view)
        let interactor = PageInteractor(presenter: presenter, nameBook: nameBook, pages: pagesOfBook)

        view.presenter = presenter
        presenter.interactor = interactor
    }
    
    
}
