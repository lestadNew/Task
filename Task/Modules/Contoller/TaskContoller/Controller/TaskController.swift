//
//  TaskController.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

class TaskController: BaseController {

    private var cellId: String = String(describing: TaskCell.self)
    private var task: TaskModel?
    private var page = 1
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        addTapOnScreen = false
        super.viewDidLoad()
    
        setup()
        loadData(page: page)
    }
    
    
    // MARK: - Setup
    private func setup() {
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        title = "Task"
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(actionAdd))
        tableView.addFooter(withTarget: self,
                            action: #selector(self.footerRefresh(sender:)))
    }
    
    //MARK: - Actions
    @objc func actionAdd() {
        TaskRouter(presenter: navigationController).pushAddedController(delegate: self)
    }
    
    @objc func footerRefresh(sender:AnyObject) {
        
        guard let meta = task?.meta else {
            tableView.footerEndRefreshing()
            return
        }
        
        if meta.count - (meta.limit * meta.current) <= 0 {
            tableView.footerEndRefreshing()
            return
        }
        
        page+=1
        
        loadData(page: page, isLoadMore: true)
    }
}


//MARK: - Load

extension TaskController {
    private func loadData(page: Int, isLoadMore: Bool = false) {
        RestTask().getTask(withСallName: viewControllerName, page: page) {[weak self] (models) in
            guard let `self` = self else { return }
            
            if isLoadMore {
                self.task?.tasks.append(contentsOf: models.tasks)
                self.task?.meta = models.meta
            } else {
                self.task = models
            }
            
            self.tableView.footerEndRefreshing()
            self.tableView.reloadData()
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
        
        cell.setCell(task: task?.tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.task?.tasks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let id = task?.tasks[indexPath.row].id else {
                return
            }
            
            RestTask().deleteTask(withСallName: viewControllerName, id: id) { [weak self] in
                guard let `self` = self else { return }
                
                self.task?.tasks.remove(at: indexPath.row)
                self.tableView.deleteIndexWithoutAnimation(indexPath: indexPath)
            }
        }
    }
}


//MARK: - AddedControllerDelegate
extension TaskController: AddedControllerDelegate{
    func addedController(controller: AddedController, model: OneTaskModel) {
        task?.tasks.insert(model.task, at: 0)
        tableView.insertIndexWithoutAnimation(indexPath: IndexPath(row: 0, section: 0))
    }
}
