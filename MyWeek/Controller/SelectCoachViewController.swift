//
//  SelectCoachViewController.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/12.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class SelectCoachViewController: UIViewController {

    private var doneBarButtonItem: UIBarButtonItem!
    private var pickerView: UIPickerView!
    
    private var coachs = [String]()
    private var coachName: String = "" {
        didSet {
            doneBarButtonItem.isEnabled = coachName != "" && coachName != "請選擇"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "選擇教練"
        view.backgroundColor = .lightGray
        configureUI()
        fetchCoachs()
    }
    
    private func fetchCoachs() {
        coachs = ["請選擇"]
        FirebaseManager.shared.fetchAllCoach { (coachs) in
            self.coachs += coachs
            DispatchQueue.main.async { self.pickerView.reloadAllComponents() }
        }
    }
    
    private func configureUI() {
        configureNavbarItem()
        setPickerView()
    }
    
    private func configureNavbarItem() {
        doneBarButtonItem = UIBarButtonItem(customView: UIButton(type: .system, {
            $0.setTitle("確認", for: .normal)
            $0.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        }))
        doneBarButtonItem.isEnabled = false
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    private func setPickerView() {
        pickerView = UIPickerView {
            $0.backgroundColor = .lightGray
            $0.delegate = self
            $0.dataSource = self
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(150)
        }
    }
    
    private func postNotification(isOwner: Bool? = true) {
        UserDefaults.standard.setValue(self.coachName, forKey: "Coach_Key")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .init("GoToMain"), object: isOwner)
    }
    
    @objc private func doneButtonPressed(_ sender: UIButton) {
        #if COAHDEBUG || COAHRELEASE
        let alert = UIAlertController(title: "請選擇", message: "管理課表呢？還是查看其他教練課表？", preferredStyle: .alert)
        let managementAction = UIAlertAction(title: "管理", style: .default) { (_) in
            self.postNotification()
        }
        let lookAction = UIAlertAction(title: "查看", style: .default) { (_) in
            self.postNotification(isOwner: false)
        }
        alert.addAction(lookAction)
        alert.addAction(managementAction)
        present(alert, animated: true, completion: nil)
        #else
        postNotification()
        #endif
    }
}

extension SelectCoachViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coachs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coachs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coachName = coachs[row]
    }
}
