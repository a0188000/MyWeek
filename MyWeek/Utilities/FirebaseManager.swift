//
//  FirebaseManager.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/5.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseManager {
    static let shared = FirebaseManager()
    
    private var studentObserverRef: DatabaseReference?
    private var studentObserverRefHandle: DatabaseHandle!
    
    private init() { }
    
    func fetchAllCoach(_ completionHandle: @escaping (_ coachs: [String]) -> Void) {
        let ref = Database.database().reference()
        var refHandle: DatabaseHandle!
        refHandle = ref.child("Coach").observe(.value) { (snapshot) in
            guard let dic = snapshot.value as? [String: [String: Any]] else { return }
            let coachs = dic.map { $0.key }
            completionHandle(coachs)
            ref.removeObserver(withHandle: refHandle)
        }
    }
    
    func saveStudentName(_ name: String,
                         successHandler: (() -> Void)?,
                         errorHandler: ((_ error: Error) -> Void)?) {
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Students")
            .childByAutoId()
            .setValue(["Name": name]) { (error, ref) in
                if let error = error {
                    errorHandler?(error)
                } else {
                    successHandler?()
                }
        }
//        func addStudent() {
//            Database.database().reference()
//                .child("Coach")
//                .child(CoachName)
//                .child("Students")
//                .childByAutoId()
//                .setValue(["Name": name]) { (error, ref) in
//                    if let error = error {
//                        errorHandler?(error)
//                    } else {
//                        successHandler?()
//                    }
//            }
//        }
//
//        fetchStudent(name) { (students) in
//            if students.isEmpty {
//                addStudent()
//            } else {
//                print("重複囉")
//            }
//        }
    }
    
    func studentObserver(autoObserver: Bool = true, valueChangeCallback: @escaping (_ students: [Gym_Student]) -> Void) {
        
        studentObserverRef = Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Students")
        
        studentObserverRefHandle = studentObserverRef?.observe(.value) { (snapshot) in
            valueChangeCallback(self.handleStudentSnapshot(snapshot))
            
            if !autoObserver {
                self.studentObserverRef?.removeObserver(withHandle: self.studentObserverRefHandle)
            }
        }
    }
    
//    func saveDayCurriculum(month: Int, day: Int, postion: Int, student: Gym_Student) {
//        Database.database().reference()
//            .child("Coach")
//            .child(CoachName)
//            .child("Curriculum")
//            .child("\(month)")
//            .child("0\(day)")
//            .child("Students")
//            .childByAutoId()
//            .setValue(["Name": student.name ?? "",
//                       "Postion": postion])
//    }
    
    func removeDayCurriculumStudent(week: Int, day: Int, student: Gym_Student) {
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .child("Students")
            .child(student.key)
            .removeValue()
    }
    
    func updateDayCurriculumStudent(month: Int, day: Int, postion: Int, oldStudent: Gym_Student?, newStudent: Gym_Student, completionHandle: @escaping () -> Void) {
        if let oldStudent = oldStudent {
            Database.database().reference()
                .child("Coach")
                .child(CoachName)
                .child("Curriculum")
                .child("\(month)")
                .child("0\(day)")
                .child("Students")
                .child(oldStudent.key)
                .removeValue()
        }
        
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Curriculum")
            .child("\(month)")
            .child("0\(day)")
            .child("Students")
            .childByAutoId()
            .setValue(["Name": newStudent.name ?? "",
                       "Postion": postion,
                       "TypeCode": newStudent.typeCode])
        completionHandle()
    }
    
    func removeDayCurriculum(month: Int, day: Int) {
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Curriculum")
            .child("\(month)")
            .child("0\(day)")
            .removeValue()
    }
    
    func updateDayCurriculumToHoliday(month: Int, day: Int) {
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Curriculum")
            .child("\(month)")
            .child("0\(day)")
            .removeValue()
        
        for i in 0...15 {
            let student = Gym_Student(name: "", typeCode: .holiday)
            Database.database().reference()
                .child("Coach")
                .child(CoachName)
                .child("Curriculum")
                .child("\(month)")
                .child("0\(day)")
                .child("Students")
                .childByAutoId()
                .setValue(["Name": student.name ?? "",
                          "Postion": i,
                          "TypeCode": student.typeCode])
        }
    }
    
    func deleteStudent(_ student: Gym_Student) {
        Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Students")
            .child(student.key)
            .removeValue()
    }
    
    func fetchStudent(_ studentName: String, completion: @escaping(_ student: [Gym_Student]) -> Void) {
        let ref = Database.database().reference()
            .child("Coach")
            .child(CoachName)
            .child("Students")
            .queryOrdered(byChild: "Name")
            .queryEqual(toValue: studentName)
            
        var refHandle: DatabaseHandle!
        refHandle = ref.observe(.value) { (snapshot) in
            ref.removeObserver(withHandle: refHandle)
            completion(self.handleStudentSnapshot(snapshot))
        }
    }
    
    func removeStudentObserver() {
        studentObserverRef?.removeObserver(withHandle: self.studentObserverRefHandle)
    }
}

extension FirebaseManager {
    private func handleStudentSnapshot(_ snapshot: DataSnapshot) -> [Gym_Student] {
        guard let value = snapshot.value as? [String: [String: Any]] else { return [] }
        var students = [Gym_Student]()
        for (key, element) in value {
            students.append(.init(key: key, dictionary: element))
        }
        return students
    }
}
