//
//  AddedController.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

protocol AddedControllerDelegate: class {
    func addedController(controller: AddedController, model: OneTaskModel)
}

class AddedController: BaseController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    weak var delegate: AddedControllerDelegate?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    
    //MARK: -Setup
    private func setup() {
        datePicker.minimumDate = Date()
        textView.setupDoneToolbar()
        title = "Added"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(actionDone))
    }
    
    //MARK: - Actions
    @objc func actionDone() {
        
        var priority = ""
        
        if let priorityIndex = prioritySegment?.selectedSegmentIndex{
            priority = PriorityEnum(rawValue: priorityIndex)?.name ?? ""
        }
        
        let body = ["title": textView.text ?? "",
                    "dueBy": Int(datePicker.date.timeIntervalSince1970),
                    "priority": priority] as [String : Any]
        
        RestTask().createTask(withСallName: viewControllerName, body: body) {[weak self] (model) in
            guard let `self` = self else { return }
            self.delegate?.addedController(controller: self, model: model)
            self.actionBack()
        }
    }
}
