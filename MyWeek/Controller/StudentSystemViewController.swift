//
//  StudentSystemViewController.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/5.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import FirebaseDatabase

class StudentSystemViewController: UIViewController {

    private var tableView: UITableView!
    private var students: [Gym_Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        configureUI()
        studentObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseManager.shared.removeStudentObserver()
    }
    
    private func configureUI() {
        congifureNavBarItem()
        setTableView()
    }
    
    private func setTableView() {
        tableView = UITableView {
            $0.weekRegister(UITableViewCell.self)
            $0.delegate = self
            $0.dataSource = self
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
        }
    }
    
    private func congifureNavBarItem() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        navigationItem.rightBarButtonItem = addItem
    }
    
    private func studentObserver() {
        FirebaseManager.shared.studentObserver { (students) in
            DispatchQueue.main.async {
                self.students = students
                self.tableView.reloadData()
            }
        }
    }
    
    private func saveStudentName(_ name: String) {
        FirebaseManager.shared.saveStudentName(name, successHandler: {
            
        }, errorHandler: { error in
            
        })
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "新增學生", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "新增", style: .default) { (action) in
            guard let studentname = alert.textFields?.first?.text else { return }
            self.saveStudentName(studentname)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        alert.addTextField { $0.placeholder = "請輸入學生姓名" }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
}

extension StudentSystemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.weekDequeueReusableCell(UITableViewCell.self, indexPath: indexPath)
        cell.textLabel?.text = students[indexPath.row].name
        return cell
    }
}
