//
//  BaseViewController.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import Cartography
import RxSwift

class BaseViewController: UIViewController {
    
    // ************************************************
    // MARK: Properties
    // ************************************************
    
    // private
    private var _placeholder: Placeholder?
    private let _disposeBag = DisposeBag()
    private var _backgroundImageView: UIImageView?
    
    // internal
    internal let basePresenter: BasePresenterProtocol

    // ************************************************
    // MARK: Init | Lifecycle
    // ************************************************
    
    init(presenter: BasePresenterProtocol, nibName: String? = nil) {
        basePresenter = presenter
        super.init(nibName: nibName, bundle: nil)
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()

        view.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupOnLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController as? BaseNavigationController {
            navigationController.style = .transparent
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        print("dealloc ---> \(String(describing: type(of: self)))")
    }
    
    // ************************************************
    // MARK: Setup
    // ************************************************
    
    private func setupOnLoad() {
        self.removeBackButtonTitle()
        self.applyLayout()
        self.bind()
    }
    
    internal func applyLayout() {
        // do nothing... this must be implemented by descendants classes to customize this behavior
    }
    
    internal func bind() {

        basePresenter.viewState
            .bind {[weak self] (state) in
                guard let strongSelf = self else { return }
                switch state {
                    
                case .normal:
                    strongSelf.dismissPlaceholder()
                    
                case .loading(let viewModel):
                    strongSelf.presentPlaceholder(type: .loading(viewModel))
                    
                case .error(let viewModel):
                    strongSelf.presentPlaceholder(type: .error(viewModel))
                }
            }
            .disposed(by: _disposeBag)
    }
    
    // ************************************************
    // MARK: Utils
    // ************************************************
    
    private func removeBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// ************************************************
// MARK: BackgroundImage
// ************************************************

extension BaseViewController {

    internal func addBackgroundImage(_ image: UIImage, withBlurEffect: Bool = false) {

        _backgroundImageView?.removeFromSuperview()
        _backgroundImageView = UIImageView(image: image)
        _backgroundImageView?.contentMode = .scaleAspectFill
        self.view.addSubview(_backgroundImageView!)
        self.view.sendSubview(toBack: _backgroundImageView!)
        constrain(self.view, _backgroundImageView!) { (container, image) in
            image.edges == container.edges
        }

        if withBlurEffect {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark) //extraLight, light, dark
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = _backgroundImageView!.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            _backgroundImageView!.addSubview(blurEffectView)
        }
    }
}

// ************************************************
// MARK: Placeholders
// ************************************************

extension BaseViewController {

    private func presentPlaceholder(type: PlaceholderType) {
        view.endEditing(true)
        self.enableNavbarIntems(false)
        
        switch type {
        case .loading(let viewModel):
            self.showLoading(viewModel: viewModel)
            
        case .error(let viewModel):
            self.showError(viewModel: viewModel)
        }
    }
    
    private func dismissPlaceholder() {
        _placeholder?.dismiss()
        _placeholder = nil
        self.enableNavbarIntems(true)
    }

    private func showLoading(viewModel: LoadingViewModel) {
        self.dismissPlaceholder()
        
        let loadingView = LoadingView(viewModel: viewModel)
        loadingView.present(on: self.view)
        _placeholder = loadingView
    }
    
    private func showError(viewModel: ErrorViewModel) {
        self.dismissPlaceholder()
        
        let errorView = ErrorView(viewModel: viewModel)
        errorView.present(on: self.view)
        _placeholder = errorView
    }
}

// ************************************************
// MARK: NavigationBar
// ************************************************

extension BaseViewController {
    
    private func enableNavbarIntems(_ isEnable: Bool) {
        if let leftButtons = navigationItem.leftBarButtonItems {
            leftButtons.forEach { $0.isEnabled = isEnable }
        }
        
        if let rightButtons = navigationItem.rightBarButtonItems {
            rightButtons.forEach { $0.isEnabled = isEnable }
        }
    }
}
