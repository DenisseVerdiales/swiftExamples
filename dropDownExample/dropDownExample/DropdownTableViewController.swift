//
//  DropdownTableViewController.swift
//  dropDownExample
//
//  Created by Cynthia Denisse Verdiales Moreno on 26/02/24.
//

import UIKit

class DropdownTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    let containerView = UIView()
    var tableItems: UITableView!
    let searchBar = UISearchBar()
    let dismissBtn = UIButton(type: .system)
    var dataArray : [String] = []
    var didSelectItem: ((String) -> Void)?
    var filteredData: [String] = []

       override func viewDidLoad() {
           super.viewDidLoad()
           
           filteredData = dataArray
           setupContainerView()
           setupSearchBar()
           setupTableView()
           setupDismissBtn()
       }

    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 10
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
         containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
         containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
         containerView.heightAnchor.constraint(equalToConstant: 600),
         containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = .white
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.delegate = self
        
        containerView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56),
            searchBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
        ])
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            let placeHolderAtt = [NSAttributedString.Key.foregroundColor: UIColor(red: 46/255, green: 79/255, blue: 119/255, alpha: 1)]
            let attPlaceHolder = NSAttributedString(string: "Search", attributes: placeHolderAtt)
            textFieldInsideSearchBar.attributedPlaceholder = attPlaceHolder
            
            textFieldInsideSearchBar.layer.borderColor =  UIColor(red: 94/255, green: 106/255, blue: 120/255, alpha: 1).cgColor
            textFieldInsideSearchBar.layer.borderWidth = 1.0
            textFieldInsideSearchBar.layer.cornerRadius = 10
            
        }
    }

    func setupTableView() {
        tableItems = UITableView()
        tableItems.separatorStyle = .none
        tableItems.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableItems)
        
        NSLayoutConstraint.activate([
            tableItems.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableItems.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableItems.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableItems.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
        
        tableItems.delegate = self
        tableItems.dataSource = self
        
        tableItems.register(DropdownTableViewCell.self, forCellReuseIdentifier: "DropdownTableViewCell")
        
    }
    
    func setupDismissBtn() {
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
        dismissBtn.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        containerView.addSubview(dismissBtn)
        
        NSLayoutConstraint.activate([
            dismissBtn.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            dismissBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    @objc func dismissModal() {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownTableViewCell", for: indexPath) as! DropdownTableViewCell
        cell.countryName.text = filteredData[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedItem = filteredData[indexPath.row]
       didSelectItem?(selectedItem)
       dismiss(animated: true, completion: nil)
    }
 

}
extension DropdownTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            filteredData = dataArray.filter {$0.lowercased().contains(searchText.lowercased())}
        } else {
            filteredData = dataArray
        }
        tableItems.reloadData()
    }
}
