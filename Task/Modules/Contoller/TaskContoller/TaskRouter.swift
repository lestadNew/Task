//
//  TaskRouter.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import Foundation

class TaskRouter: BaseRouter {
    func pushTaskController() {
        let controller = TaskController()
        push(controller: controller)
    }
    
    func pushAddedController() {
        let controller = TaskController()
        push(controller: controller)
    }
    
    func pushAddedController<C>(delegate: C) where C: AddedControllerDelegate {
        let controller = AddedController()
        controller.delegate = delegate
        push(controller: controller)
    }
}
