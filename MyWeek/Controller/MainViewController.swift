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
    
    private var month = Calendar.current.component(.month, from: Date())
    private var today = Calendar.current.component(.day, from: Date())
    private var selectedDay = 0
    
    private var students = [Gym_Student]()
    private var weekCurriculum = [Gym_WeekCurriculum]()
    private var dayCurriculum = [Gym_DayCurriculum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "\(month)月課表"
        view.backgroundColor = .white
        configureUI()
        fetchDayCurriculum()
        fetchStudentList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: .init(row: 0, section: self.today - 1), at: .centeredHorizontally, animated: true)
    }
    
    private func configureUI() {
        configureNavBarItem()
        setWeekView()
        setTimeView()
        setCollectionView()
    }
    
    private func configureNavBarItem() {
        let changeItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("更換教練", for: .normal)
            $0.addTarget(self, action: #selector(changeCoach(_:)), for: .touchUpInside)
        }))
        #if STUDENTDEBUG || STUDENTRELEASE
        navigationItem.rightBarButtonItem = changeItem
        #endif
        
        let studentItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("學生管理", for: .normal)
            $0.addTarget(self, action: #selector(studentButtonPressed(_:)), for: .touchUpInside)
        }))
        studentItem.isEnabled = IsOwner
        
        let changeItme = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("換教練", for: .normal)
            $0.addTarget(self, action: #selector(changeCoach(_:)), for: .touchUpInside)
        }))
        
        #if COAHDEBUG || COAHRELEASE
        navigationItem.leftBarButtonItem = changeItme
        navigationItem.rightBarButtonItem = studentItem
        #endif
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
            .child(CoachName)
            .child("Curriculum")
            .child("\(month)")
            .observe(.value, with: { snapshot in
                guard let value = snapshot.value as? [String: [String: Any]] else { return }
                self.dayCurriculum = []
                for (day, element) in value {
                    guard let studentsDic = element["Students"] as? [String: Any] else { return }
                    self.dayCurriculum.append(.init(day: Int(day.dropFirst())!, dictionary: studentsDic))
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            })
    }
    
    private func fetchStudentList() {
        FirebaseManager.shared.studentObserver(autoObserver: true) { (students) in
            self.students = students
        }
    }
    
    @objc private func changeCoach(_ sender: UIButton) {
        NotificationCenter.default.post(name: .init("ChangeCoach"), object: nil)
    }
    
    @objc private func studentButtonPressed(_ sender: UIButton) {
        let ctrl = StudentSystemViewController()
        navigationController?.pushViewController(ctrl, animated: true)
    }
}

extension MainViewController: WeekViewDelegate {
    func weekView(_ view: WeekView, userPressDay day: Int) {
        #if COAHDEBUG || COAHRELEASE
        let alert = UIAlertController(title: "修改\(month)/\(day)日行程", message: "nil", preferredStyle: .actionSheet)
        let holidayAction = UIAlertAction(title: "放假", style: .default) { (_) in
            FirebaseManager.shared.updateDayCurriculumToHoliday(month: self.month, day: day)
        }
        let clearAction = UIAlertAction(title: "清除當日行程", style: .default) { (_) in
            FirebaseManager.shared.removeDayCurriculum(month: self.month, day: day)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(holidayAction)
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        #endif
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 31
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.weekDequeueReusableCell(DayCell.self, indexPath: indexPath)
        if let student = self.dayCurriculum.first(where: { $0.day == indexPath.section + 1 })?.students.first(where: { $0.postion == indexPath.row}) {
            cell.setContent(student)
        } else {
            cell.defaultConfigure()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay = indexPath.section + 1
        
        let day = indexPath.section + 1
        let postion = indexPath.row
        
        print("month: \(month)")
        print("day: \(indexPath.section + 1)")
        print("postion: \(indexPath.row)")
        print("========================")
        
        #if COAHDEBUG || COAHRELEASE
        if !IsOwner { return }
        guard
            let dayCurriculum = self.dayCurriculum.first(where: { $0.day == selectedDay }),
            let student = dayCurriculum.students.first(where: { $0.postion == indexPath.row })
        else {
            let ctrl = SelectStudentViewController(month: month, day: day, postion: postion,  students: students, selectedStudent: nil)
            present(UINavigationController(rootViewController: ctrl), animated: true, completion: nil)
            return
        }
        let ctrl = SelectStudentViewController(month: month, day: day, postion: postion,  students: students, selectedStudent: student)
        present(UINavigationController(rootViewController: ctrl), animated: true, completion: nil)
        #endif
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 65, height: (collectionView.bounds.height - 13) / 14)
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
