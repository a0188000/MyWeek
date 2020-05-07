//
//  StudentItemCell.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/5/6.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class StudentItemCell: UICollectionViewCell {
    
    var studentItemButtonCallback = { (_ student: Gym_Student?) -> Void in }
    private var student: Gym_Student?
    
    private var defaultBackgeoundColor = UIColor(red: 204, green: 204, blue: 204)//.withAlphaComponent(0.2)
    private var selectedBackgroundColor = UIColor(red: 215, green: 226, blue: 97)
    private var defaultTextColor = UIColor.black
    private var selectedTextColor = UIColor.black
    
    lazy var itemButton = UIButton {
//        $0.titleLabel?.font = UIFont.pingFangTCFont(.regular, ofSize: 15)
        $0.setTitleColor(self.defaultTextColor, for: .normal)
        $0.setTitleColor(self.selectedTextColor, for: .selected)
        $0.setBackgroundImage(GeneralHelper.getImageWithColor(color: self.defaultBackgeoundColor, size: CGSize(width: 1, height: 1)), for: .normal)
        $0.setBackgroundImage(GeneralHelper.getImageWithColor(color: self.selectedBackgroundColor, size: CGSize(width: 1, height: 1)), for: .selected)
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(itemButtonPressed(_:)), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        self.contentView.addSubview(itemButton)
        self.setConstraints()
    }
    
    private func setConstraints() {
        self.itemButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
    func setContent(_ student: Gym_Student, isSelected: Bool) {
        self.student = student
        itemButton.setTitle("  " + student.name! + "  ", for: .normal)
        itemButton.isSelected = isSelected
    }
    
    @objc private func itemButtonPressed(_ sender: UIButton) {
        if sender.isSelected {
//         studentItemButtonCallback(nil)
        } else {
            studentItemButtonCallback(student)
            sender.isSelected = !sender.isSelected
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
