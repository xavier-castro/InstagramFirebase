//
// Created by Xavier Castro on 2019-04-05.
// Copyright (c) 2019 Xavier Castro. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    let cellId = "cellId"
    var filteredUsers = [User]()
    var users = [User]()

    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240, alpha: 1)
        sb.delegate = self
        return sb
    }()

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { user -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .white

        navigationController?.navigationBar.addSubview(searchBar)

        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8))

        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)

        collectionView.alwaysBounceVertical = true

        fetchUsers()
    }

    fileprivate func fetchUsers() {
        let ref = Firebase.Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                return
            }
            dictionaries.forEach { key, value in
                guard let userDictionary = value as? [String: Any] else {
                    return
                }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            }
            self.users.sort { (user, user2) -> Bool in
                return user.username.compare(user2.username) == .orderedAscending
            }
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch users for search:")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 66)
    }
}
