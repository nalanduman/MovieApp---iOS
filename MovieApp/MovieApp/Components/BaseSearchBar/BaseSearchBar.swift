//
//  BaseSearchBar.swift
//  MovieApp
//
//  Created by Nalan Duman on 13.12.2024.
//

import Foundation
import UIKit

protocol BaseSearchBarDelegate: AnyObject {
    func searchBarFilterWith(text: String)
    func searchBarResetSearch()
}

class BaseSearchBar: UISearchBar {
    
    var textField: UITextField?
    
    var baseSearchBarDelegate: BaseSearchBarDelegate?

    private var lengthCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        self.placeholder = "Search"
        self.layer.borderWidth = 1
        self.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.layer.cornerRadius = 12
        self.searchTextField.backgroundColor = .clear
        self.delegate = self
    }
}

extension BaseSearchBar {
    
    private func changeBorderAndTintColor(color: UIColor) {
        self.searchTextField.textColor = color
        self.layer.borderColor = color.cgColor
    }
    
    private func characterCountCheck() -> Bool {
        return lengthCount != 0
    }
    
    private func changeColor() -> UIColor {
        return characterCountCheck() ? .blue : .gray
    }
}

extension BaseSearchBar: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lengthCount = searchText.count
        changeBorderAndTintColor(color: changeColor())
        returnSearchTextWithDelegate(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        changeBorderAndTintColor(color: .blue)
    }
    
    func returnSearchTextWithDelegate(text: String) {
        characterCountCheck() ? baseSearchBarDelegate?.searchBarFilterWith(text: text) : baseSearchBarDelegate?.searchBarResetSearch()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        changeBorderAndTintColor(color: changeColor())
        self.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
