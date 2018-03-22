//
//  ContainerRouter.swift
//  Popcorn
//
//  Created by Marsal Silveira.
//  Copyright © 2018 Marsal Silveira. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum ContentScreen {
    case home
}

protocol ContainerRouterProtocol: class {
    func updateCurrentScreen(_ screen: ContentScreen)
}

class ContainerRouter: BaseRouter {
    
    private let _viewController: ContainerViewController
    private let _presenter: ContainerPresenterProtocol
    private var _childRouter: BaseRouter?
    
    private let _disposeBag = DisposeBag()
    private var _currentScreen: ContentScreen?
    
    override init() {
        
        _presenter = ContainerPresenter()
        _viewController = ContainerViewController(presenter: _presenter)

        super.init()
    }
    
    func presentOn(window: UIWindow) {
        
        window.rootViewController = _viewController
        window.makeKeyAndVisible()
        
        // fixed because we have only one possible screen... if we have a session we can change the VC in show automatically just changing current screen value
        self.updateCurrentScreen(.home)
    }
}

extension ContainerRouter: ContainerRouterProtocol {
    
    func updateCurrentScreen(_ screen: ContentScreen) {
        
        guard screen != _currentScreen else { return }
        switch screen {

        case .home:
            let viewController = UIViewController()
            viewController.view.backgroundColor = UIColor.blue
            _viewController.setCurrentViewController(viewController)
            
            TMDbAPI()
                .upcomingMovies(page: 1)
                .subscribe {[weak self] (event) in
                    guard let strongSelf = self else { return }
                    
                    switch event {
                    case .success(let movieObjAPI):
//                        strongSelf.requestResponseVariable.value = .success(())
                        print("result -> \(movieObjAPI)")
                    case .error(let error):
                        print("error -> \(error)")
//                        strongSelf.requestResponseVariable.value = .failure(APIError.error(description: error.localizedDescription))
                    }
                }
                .disposed(by: _disposeBag)
            
//            let topCoinsRouter = TopCoinsRouter()
//            _viewController.setCurrentViewController(topCoinsRouter.viewController)
//            _childRouter = topCoinsRouter
        }
        
        _currentScreen = screen
    }
}
