//
//  Interactor.swift
//  VIPER
//
//  Created by Pushkar Deshmukh on 06/07/23.
//

import Foundation

// object
// protocol
// ref to presenter

// https://jsonplaceholder.typicode.com/users

enum FetchError: Error {
    case failed
}

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
    
}

class UserInteractor: AnyInteractor {
    weak var presenter: AnyPresenter?
    
    func getUsers() {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let response = try decoder.decode([User].self, from: data)
                
                DispatchQueue.main.async {
                    print(response)
                    self?.presenter?.interactorDidFetchUsers(with: .success(response))
                }
            } catch {
                DispatchQueue.main.async {
                    self?.presenter?.interactorDidFetchUsers(with: .failure(error))
                }
            }
        }
        
        task.resume()
        
    }
}
