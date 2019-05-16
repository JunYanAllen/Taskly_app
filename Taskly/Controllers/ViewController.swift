//
//  ViewController.swift
//  Taskly
//
//  Created by 張駿彥 on 2019/2/23.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var taskStore: TaskStore!{
        didSet{
            //取得資料
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            
            tableView.reloadData()
        }
    }
    var newTask : String = "",newDate :String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
        
//        let indexPath = IndexPath(row: 0,section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func cancelButton(segue:UIStoryboardSegue) {}
    @IBAction func saveButton(segue:UIStoryboardSegue) {
        let DetailVC = segue.source as! CreateTaskController
        newTask = DetailVC.task
        newDate = DetailVC.date_text
        
        if newTask == "",newDate == ""{
            
        }else{
            let new = Task(task: newTask, date: newDate)
            self.taskStore.add(new, at: 0)
            //重新整理頁面
            let indexPath = IndexPath(row: 0,section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    @IBAction func backButton(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSegue"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let Dvc:DetailViewController = segue.destination as! DetailViewController
                
                Dvc.getTask = taskStore.tasks[indexPath.section][indexPath.row].task
                Dvc.getDate = taskStore.tasks[indexPath.section][indexPath.row].date
                
            }
        }
    }
}

// MARK: - DataSource
extension ViewController{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "代辦工作" : "完成"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].task
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
            
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
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
