//
//  ViewController.swift
//  Sample project
//
//  Created by Sven Svetina on 10/10/2019.
//  Copyright © 2019 Sven Svetina. All rights reserved.
//

import UIKit
import Foundation

class UserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var networkService = NetworkService()
    var userModel = [UserModel]()
    var refreshControl = UIRefreshControl()
    
    let tableView = UITableView()
    
    override func loadView() {
        super.loadView()
        setupLayout()
        fetchData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableViewCell") as! UserTableViewCell
        cell.configureWithCellModel(userModel[indexPath.row], photoModel: userModel[indexPath.row].albumModel[indexPath.row].photoModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action,view,completion) in
            
            self.userModel.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completion(true)
        })
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let presentAlbums = UIContextualAction(style: .normal, title: "Albums", handler: { [weak self] action, view, completion in
            let albumViewController = AlbumViewController()
            let albumModelForUser = self?.userModel[indexPath.row].albumModel
            albumViewController.albumModelForUser = albumModelForUser!
            let photoModelForUser = self?.userModel[indexPath.section].albumModel[indexPath.row].photoModel
            albumViewController.photoModelForUser = photoModelForUser!
            
            self?.navigationController?.pushViewController(albumViewController, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        })
        presentAlbums.backgroundColor = .gray
        
        let presentPosts = UIContextualAction(style: .normal, title: "Posts", handler: { [weak self] action, view, completion in
            let postViewController = PostViewController()
            let postModelForUser = self?.userModel[indexPath.row].postModel
            postViewController.postModelForUser = postModelForUser!
            let userModelForPosts = self?.userModel
            postViewController.userModel = userModelForPosts!
            
            self?.navigationController?.pushViewController(postViewController, animated: true)
            
            tableView.deselectRow(at: indexPath, animated: true)
        })
        presentPosts.backgroundColor = .brown
        
        let configuration = UISwipeActionsConfiguration(actions: [presentPosts, presentAlbums])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        navigationItem.title = "Users"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Users")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    
    func fetchData() {
        networkService.fetchData() { [weak self] users in
            self?.userModel = users
            self?.tableView.dataSource = self
            self?.tableView.delegate = self
            self?.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "userTableViewCell")
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc func refreshTableView() {
        fetchData()
    }
}
