//
//  ViewController.swift
//  dropDownExample
//
//  Created by Cynthia Denisse Verdiales Moreno on 13/02/24.
//
import UIKit

class ViewController: UIViewController{
    
    var isDropDownVisible = false
    var dataArray = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func setupButton(){
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
        button.frame = CGRect(x: view.frame.width - 60, y: 60, width: 50, height: 50)
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func showDropdownMenu() {
        let dropdownVC = DropdownTableViewController()
        dropdownVC.modalPresentationStyle = .custom
        dropdownVC.modalTransitionStyle = .crossDissolve
        dropdownVC.transitioningDelegate = self
        dropdownVC.preferredContentSize = CGSize(width: 400, height: 400)
        dropdownVC.dataArray = dataArray
        
        
        dropdownVC.didSelectItem = { selectedItem in
                print(selectedItem)
        }
        

        self.present(dropdownVC, animated: true, completion: nil)
    }

    @objc func toggleDropdown() {
        showDropdownMenu()
    }
}
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FloatingModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
