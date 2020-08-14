//
//  SelectStudentViewController.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/6.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class SelectStudentViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var doneButtonItem: UIBarButtonItem!
    
    private var students: [Gym_Student] = []
    private var statusStudent: [Gym_Student] = [.init(name: "空堂", typeCode: .normal),
                                                .init(name: "忙碌", typeCode: .busy),
                                                .init(name: "放假", typeCode: .holiday)]
    private var selectedStudent: Gym_Student?
    private var newSelectedStudent: Gym_Student? {
        didSet {
            doneButtonItem.isEnabled = newSelectedStudent != nil
        }
    }
    private var month: Int!
    private var day: Int!
    private var postion: Int!
    
    private var allStudents: [Gym_Student] {
        return statusStudent + students
    }
    
    convenience init(month: Int, day: Int, postion: Int, students: [Gym_Student], selectedStudent: Gym_Student?) {
        self.init()
        self.month = month
        self.day = day
        self.postion = postion
        self.students = students
        self.selectedStudent = selectedStudent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        title = "安排學生"
        title = "安排客人"
        view.backgroundColor = .white
        configureUI()
    }

    private func configureUI() {
        configureNavBarItem()
        setCollectionView()
    }
    
    private func configureNavBarItem() {
        let closeItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("關閉", for: .normal)
            $0.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        }))
        
        navigationItem.leftBarButtonItem = closeItem
        
        doneButtonItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("儲存", for: .normal)
            $0.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        }))
        doneButtonItem .isEnabled = false
        
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout {
            $0.itemSize = UICollectionViewFlowLayout.automaticSize
            $0.estimatedItemSize = CGSize(width: 1, height: 1)
            $0.minimumInteritemSpacing = 6
            $0.minimumLineSpacing = 12
//            $0.delegate = self
        }
        collectionView = UICollectionView(layout: layout, {
            $0.backgroundColor = .white
            $0.weekRegister(StudentItemCell.self)
            $0.delegate = self
            $0.dataSource = self
        })
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.top.equalTo(view.layoutMarginsGuide.snp.top).offset(4)
            make.right.bottom.equalTo(-4)
        }
    }
    
    private func handleselectedStudent(_ student: Gym_Student?) {
        newSelectedStudent = student
        newSelectedStudent?.postion = postion
        if !statusStudent.contains(where: { $0.name == student?.name }) {
            newSelectedStudent?.typeCode = 1
        }
        collectionView.reloadData()
    }
    
    @objc private func closeView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonPressed(_ sender: UIButton) {
        FirebaseManager.shared.updateDayCurriculumStudent(month: month, day: day, postion: postion, oldStudent: selectedStudent, newStudent: newSelectedStudent!, completionHandle: {
            self.dismiss(animated: true, completion: nil)
        })
    }
}

extension SelectStudentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allStudents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.weekDequeueReusableCell(StudentItemCell.self, indexPath: indexPath)
        if let _ = newSelectedStudent {
            cell.setContent(allStudents[indexPath.row], isSelected: self.newSelectedStudent?.name == allStudents[indexPath.row].name)
        } else {
            cell.setContent(allStudents[indexPath.row], isSelected: self.selectedStudent?.name == allStudents[indexPath.row].name)
        }
        cell.studentItemButtonCallback = { [weak self] student in
            self?.handleselectedStudent(student)
        }
        return cell
    }
}
