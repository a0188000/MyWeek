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
    
    func saveStudentName(_ name: String,
                         successHandler: (() -> Void)?,
                         errorHandler: ((_ error: Error) -> Void)?) {

        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Students")
            .childByAutoId()
            .setValue(["Name": name]) { (error, ref) in
                if let error = error {
                    errorHandler?(error)
                } else {
                    successHandler?()
                }
        }
    }
    
    func studentObserver(autoObserver: Bool = true, valueChangeCallback: @escaping (_ students: [Gym_Student]) -> Void) {
        
        studentObserverRef = Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Students")
        
        studentObserverRefHandle = studentObserverRef?.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String: [String: Any]] else { return valueChangeCallback([]) }
            var students = [Gym_Student]()
            for (key, element) in value {
                students.append(.init(key: key, dictionary: element))
            }
            valueChangeCallback(students)
            
            if !autoObserver {
                self.studentObserverRef?.removeObserver(withHandle: self.studentObserverRefHandle)
            }
        }
    }
    
    func saveDayCurriculum(week: Int, day: Int, postion: Int, student: Gym_Student) {
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .child("Students")
            .childByAutoId().setValue(["Name": student.name ?? "",
                                       "Postion": postion])
    }
    
    func removeDayCurriculumStudent(week: Int, day: Int, student: Gym_Student) {
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .child("Students")
            .child(student.key)
            .removeValue()
    }
    
    func updateDayCurriculumStudent(week: Int, day: Int, postion: Int, oldStudent: Gym_Student?, newStudent: Gym_Student, completionHandle: @escaping () -> Void) {
        if let oldStudent = oldStudent {
            Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .child("Students")
            .child(oldStudent.key)
            .removeValue()
        }
        
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .child("Students")
            .childByAutoId()
            .setValue(["Name": newStudent.name ?? "",
                       "Postion": postion,
                       "TypeCode": newStudent.typeCode])
        completionHandle()
    }
    
    func removeDayCurriculum(week: Int, day: Int) {
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .removeValue()
    }
    
    func updateDayCurriculumToHoliday(week: Int, day: Int) {
        Database.database().reference()
            .child("Coach")
            .child("Eason")
            .child("Curriculum")
            .child("\(week)")
            .child("0\(day)")
            .removeValue()
        
        for i in 0...15 {
            let student = Gym_Student(name: "", typeCode: .holiday)
            Database.database().reference()
                .child("Coach")
                .child("Eason")
                .child("Curriculum")
                .child("\(week)")
                .child("0\(day)")
                .child("Students")
                .childByAutoId()
                .setValue(["Name": student.name ?? "",
                          "Postion": i,
                          "TypeCode": student.typeCode])
        }
    }
    
    func removeStudentObserver() {
        studentObserverRef?.removeObserver(withHandle: self.studentObserverRefHandle)
    }
}
