//
//  ViewController.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/23.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var taskStore = TaskStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    //新增任務功能
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        //任務視窗設定
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        //任務視窗-新增功能
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            
            //取得文字內容
            guard let name = alertController.textFields?.first?.text else { return }
            
            //建立任務
            let newTask = Task(name: name)
            
            //增加任務
            self.taskStore.add(newTask,at: 0)
            
            //重新整理頁面
            let indexPath = IndexPath(row: 0,section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        //任務視窗-新增功能-預設關閉
        addAction.isEnabled = false
        //任務視窗-取消
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        //任務視窗-
        alertController.addTextField{ textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
    }

}

// MARK: - DataSource
extension ViewController{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-do" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
    
    @objc private func handleTextChanged(_ sender:UITextField){
        guard let alertController = presentedViewController as? UIAlertController,
            let addAction = alertController.actions.first,
            let text = sender.text
            else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - Delegate
extension ViewController{
    //row高度
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    //右側Swipe（刪除）
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){ (action,sourceView,completionHandler) in
            
            let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone
            
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named:"delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    //左側Swipe（完成）
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil){ (action,sourceView,completionHandler) in
            
            //切換任務
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            //移除To-do任務
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            //重整tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //增加done任務
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            //重整tableview
            tableView.insertRows(at: [IndexPath(row:0,section:1)], with: .automatic)
            
            //執行操作
            completionHandler(true)
        }
        
        doneAction.image = UIImage(named:"Done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
