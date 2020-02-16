//
//  BaseRouter+Protocol.swift
//  Task
//
//  Created by Andrey Sokolov on 12.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

//MARK: - Router Protocol
protocol RouterProtocol {
    var presenter: UINavigationController? { get }
    func getStoryboard(name: String?) -> UIStoryboard
}

//MARK: - Base Router
class BaseRouter: RouterProtocol {
    
    weak var presenter: UINavigationController?
    
    init() {
        self.presenter = nil
    }
    
    init(presenter: UINavigationController?) {
        self.presenter = presenter
    }
}

//MARK: - Get if used StoryBoard
extension RouterProtocol {
    
    func getStoryboard(name: String? = nil) -> UIStoryboard {
        
        let storyName: String = {
            if let name = name { return name }
            return "\(type(of: self))".replacingOccurrences(of: "Router", with: "")
        }()
        
        return UIStoryboard(name: storyName, bundle: nil)
    }
    
    func getController<T>(type: T.Type, name: String? = nil) -> T? where T: UIViewController {
        
        let controllerName: String = {
            if let name = name { return name }
            return "\(Swift.type(of: T.self))".replacingOccurrences(of: ".Type", with: "")
        }()
        
        return getStoryboard().instantiateViewController(withIdentifier: controllerName) as? T
    }
    
    func controller<T: UIViewController>(name: String? = nil) -> T {
        guard let controller = self.getController(type: T.self, name: name) else {
            fatalError("\(#function) controller can't cast to \(T.self)")
        }
        
        return controller
        
    }
    
}

//MARK: - Navigation
extension RouterProtocol {
    
    func present(controller: UIViewController, animated: Bool = true, presentStyle: UIModalPresentationStyle = .fullScreen, complate: (() -> ())? = nil) {
        controller.modalPresentationStyle = presentStyle
        presenter?.present(controller, animated: animated, completion: complate)
    }
    
    func push(controller: UIViewController, animated: Bool = true) {
        if UIApplication.topViewController()?.viewControllerName == controller.viewControllerName { return }
        presenter?.pushViewController(controller, animated: animated)
    }
    
    func popToController(_ animated: Bool = true) {
        _ = presenter?.popViewController(animated: animated)
    }
    
    func popToRootController(_ animated: Bool = true) {
        _ = presenter?.popToRootViewController(animated: animated)
    }
    
    func dismiss(_ animated: Bool = true, complate: (() -> ())? = nil) {
        presenter?.dismiss(animated: animated, completion: complate)
    }
    
    func popTo(controller: UIViewController, animated: Bool = true) {
        _ = presenter?.popToViewController(controller, animated: animated)
    }
}
