//
//  ViewController.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/24.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController {

    private var timeView = TimeView()
    private var weekView = WeekView()
    private var collectionView: UICollectionView!
    
    private var students = [Gym_Student]()
    
    private var dayCurriculum = [Gym_DayCurriculum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "一週課表"
        view.backgroundColor = .white
        configureUI()
        fetchDayCurriculum()
        fetchStudentList()
    }

    private func configureUI() {
        configureNavBarItem()
        setWeekView()
        setTimeView()
        setCollectionView()
    }
    
    private func configureNavBarItem() {
        let studentItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("學生管理", for: .normal)
            $0.addTarget(self, action: #selector(studentButtonPressed(_:)), for: .touchUpInside)
        }))
        
        navigationItem.rightBarButtonItem = studentItem
    }
    
    private func setWeekView() {
        weekView.delegate = self
        weekView.weekDelegate = self
        
        view.addSubview(weekView)
        weekView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.layoutMarginsGuide.snp.top)
            make.height.equalTo(25)
        }
    }
    
    private func setTimeView() {
        view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(weekView.snp.bottom)
            make.width.equalTo(50)
        }
    }

    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout( {
            $0.scrollDirection = .horizontal
            $0.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 1)
        })
        
        collectionView = UICollectionView(layout: layout, {
            $0.bounces = false
            $0.backgroundColor = .black
            $0.weekRegister(DayCell.self)
            $0.delegate = self
            $0.dataSource = self
        })

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(timeView.snp.right)
            make.right.bottom.equalToSuperview()
            make.top.equalTo(weekView.snp.bottom)
        }
    }
    
    private func fetchDayCurriculum() {
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .queryOrdered(byChild: "19")
            .observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [String: Any] else { return }
                let values = [String: Any](uniqueKeysWithValues: value.sorted(by: { $0.key < $1.key }))
                var weekC: Gym_WeekCurriculum?
                for (week, element) in values {
                    guard let dictionary = element as? [String: Any] else { break }
                    weekC = .init(week: Int(week)!, dictionary: dictionary)
                }
                self.dayCurriculum = weekC?.dayCurriculum ?? []
                DispatchQueue.main.async { self.collectionView.reloadData() }
            })
    }
    
    private func fetchStudentList() {
        FirebaseManager.shared.studentObserver(autoObserver: false) { (students) in
            self.students = students
        }
    }
    
    @objc private func studentButtonPressed(_ sender: UIButton) {
        let ctrl = StudentSystemViewController()
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension MainViewController: WeekViewDelegate {
    func weekView(_ view: WeekView, userPressDay day: Int) {
        
        let alert = UIAlertController(title: "設定一日行程", message: nil, preferredStyle: .actionSheet)
        let holidayAction = UIAlertAction(title: "放假", style: .default) { (_) in
            FirebaseManager.shared.updateDayCurriculumToHoliday(week: Calendar.current.component(.weekOfYear, from: Date()), day: day)
        }
        let clearAction = UIAlertAction(title: "清除當日行程", style: .default) { (_) in
            FirebaseManager.shared.removeDayCurriculum(week: Calendar.current.component(.weekOfYear, from: Date()), day: day)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(holidayAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.weekDequeueReusableCell(DayCell.self, indexPath: indexPath)
        if let dayCurriculum = dayCurriculum.first(where: { $0.day - 1 == indexPath.section }) {
            if let student = dayCurriculum.students.first(where: { $0.postion == indexPath.row}) {
                cell.setContent(student)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let week = Calendar.current.component(.weekOfYear, from: Date())
        let day = indexPath.section + 1
        let postion = indexPath.row
        
        print("week: \(Calendar.current.component(.weekOfYear, from: Date()))")
        print("day: \(indexPath.section + 1)")
        print("postion: \(indexPath.row)")
        print("========================")
        guard
            let dayCurriculum = dayCurriculum.first(where: { $0.day - 1 == indexPath.section }),
            let student = dayCurriculum.students.first(where: { $0.postion == indexPath.row})
        else {
//            let student = Gym_Student(key: "", dictionary: ["Name": "Bill"])
//            FirebaseManager.shared.saveDayCurriculum(week: week, day: indexPath.section + 1, postion: indexPath.row, student: student)
            let ctrl = SelectStudentViewController(week: week, day: day, postion: postion,  students: students, selectedStudent: nil)
            present(UINavigationController(rootViewController: ctrl), animated: true, completion: nil)
            return
        }
        let ctrl = SelectStudentViewController(week: week, day: day, postion: postion,  students: students, selectedStudent: student)
        present(UINavigationController(rootViewController: ctrl), animated: true, completion: nil)
//        FirebaseManager.shared.removeDayCurriculumStudent(week: week, day: indexPath.section + 1, student: student)
        
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 65, height: Int((collectionView.bounds.height) / 16 - 1))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            weekView.contentOffset.x = -50 + scrollView.contentOffset.x
        }
    }
}
