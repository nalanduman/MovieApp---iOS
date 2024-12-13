//
//  BaseViewController.swift
//  MovieApp
//
//  Created by Nalan Duman on 11.12.2024.
//

import UIKit

class BaseViewController: UIViewController {

    private var activityIndicator: UIActivityIndicatorView?
    private var loadingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupIndıcatorUI()
    }
    
    func showNavigationItem(leftImage: UIImage? = nil, rightImage: UIImage? = nil, title: String? = "") {
        let customLeftButton = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(self.dismissPage))
        let customLRightButton = UIBarButtonItem(image: rightImage, style: .plain, target: self, action: #selector(self.clickRightIcon))
        self.navigationItem.title = title
        self.navigationItem.leftItemsSupplementBackButton = false
        self.navigationItem.leftBarButtonItem = customLeftButton
        self.navigationItem.rightBarButtonItem = customLRightButton
    }
    
    @objc func dismissPage() {
        DispatchQueue.main.async(execute: {
            self.dismiss(animated: true)
        })
    }
    
    @objc func clickRightIcon() {
    }
    
    private func setupIndıcatorUI() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .blue
        activityIndicator?.center = view.center
        activityIndicator?.hidesWhenStopped = true
    }
    
    func showProgress() {
        loadingView = UIView(frame: self.view.bounds)
        loadingView?.backgroundColor = UIColor(white: 0, alpha: 0.5)
        guard let activityIndicator, let loadingView else { return }
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)

        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }

    func hideProgress() {
        loadingView?.removeFromSuperview()
        loadingView = nil
        activityIndicator?.stopAnimating()
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
}

