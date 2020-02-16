//
//  TaskCell.swift
//  Task
//
//  Created by Andrey Sokolov on 16.02.2020.
//  Copyright © 2020 Andrey Sokolov. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setCell(task: DescriptTaskModel?) {
        if let title = task?.title {
            descriptionLabel.text = title
            descriptionLabel.isHidden = false
        } else {
            descriptionLabel.isHidden = true
        }
        
        if let date = task?.dueBy?.trackDate() {
            dateLabel.text = date
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }
        
        if let priority = task?.priority {
            priorityLabel.text = priority
            priorityLabel.isHidden = false
        } else {
            priorityLabel.isHidden = true
        }
    }
}
