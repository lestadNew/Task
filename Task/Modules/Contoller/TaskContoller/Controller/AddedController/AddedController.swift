//
//  AddedController.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

protocol AddedControllerDelegate: class {
    func addedController(controller: AddedController, added model: OneTaskModel)
    func addedController(controller: AddedController, update model: DescriptTaskModel)
}

class AddedController: BaseController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var prioritySegment: UISegmentedControl!
    
    weak var delegate: AddedControllerDelegate?
    
    var task: DescriptTaskModel?
    
    lazy var priorityType: String = {
        var priority = ""
        
        if let priorityIndex = prioritySegment?.selectedSegmentIndex {
            priority = PriorityEnum(rawValue: priorityIndex)?.name ?? ""
        }
        
        return priority
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    
    //MARK: -Setup
    private func setup() {
        updateUI()
        datePicker.minimumDate = Date()
        textView.setupDoneToolbar()
        title = Constant.Text.added
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: (task != nil) ? Constant.Text.edit : Constant.Text.done, style: .done, target: self, action: #selector(actionDone))
    }
    
    //MARK: - Private methods
    private func updateUI() {
        if let task = task {
            textView.text = task.title
            
            if let selectedIndex = PriorityEnum.fromName(name: task.priority ?? "")?.rawValue {
                prioritySegment.selectedSegmentIndex = selectedIndex
            }
            
            if let date = task.dueBy {
                datePicker.setDate(date, animated: false)
            }
        }
    }
    
    private func createTask() {
    
        let body = ["title": textView.text ?? "",
                    "dueBy": Int(datePicker.date.timeIntervalSince1970),
                    "priority": priorityType] as [String : Any]
        
        RestTask().createTask(withСallName: viewControllerName, body: body) {[weak self] (model) in
            guard let `self` = self else { return }
            self.delegate?.addedController(controller: self, added: model)
            self.actionBack()
        }
    }
    
    private func updateTask() {
        
        guard let id = task?.id else { return }
        
        let body = ["title": textView.text ?? "",
                    "dueBy": Int(datePicker.date.timeIntervalSince1970),
                    "priority": priorityType] as [String : Any]
        
        RestTask().updateTask(withСallName: viewControllerName, id: id, body: body) {[weak self] () in
            guard let `self` = self, var task = self.task else { return }
            
            task.title = self.textView.text
            task.dueBy = self.datePicker.date
            task.priority = self.priorityType
            
            self.delegate?.addedController(controller: self, update: task)
            self.actionBack()
        }
    }
    
    //MARK: - Actions
    @objc func actionDone() {
        if (task != nil) {
            updateTask()
        } else {
            createTask()
        }
    }
}
