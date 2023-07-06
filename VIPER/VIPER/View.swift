//
//  View.swift
//  VIPER
//
//  Created by Pushkar Deshmukh on 06/07/23.
//

import UIKit

// ViewController
// protocol
// reference presenter

protocol AnyView: AnyObject {
    var presenter: AnyPresenter? { get set }
    
    func update(with users: [User])
    func update(with error: String)
}

class UserViewController: UIViewController {
    var presenter: AnyPresenter?
    
    var users = [User]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        errorLabel.frame = .init(x: 0, y: 0, width: 200, height: 40)
        errorLabel.center = view.center
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(errorLabel)
    }
}

extension UserViewController: AnyView {
    func update(with users: [User]) {
        self.users = users
        
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    func update(with error: String) {
        tableView.isHidden = true
        errorLabel.isHidden = false
        errorLabel.text = error
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}
