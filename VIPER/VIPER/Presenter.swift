//
//  Presenter.swift
//  VIPER
//
//  Created by Pushkar Deshmukh on 06/07/23.
//

import Foundation

// object
// protocol
// ref to interactor, router, view

protocol AnyPresenter: AnyObject {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var router: AnyRouter?
    
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getUsers()
        }
    }
    
    weak var view: AnyView?
    
    func interactorDidFetchUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
            
        case .failure:
            view?.update(with: "Something went wrong")
        }
        
    }
}
