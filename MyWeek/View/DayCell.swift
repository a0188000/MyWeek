//
//  DayCell.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/29.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    private var studentLabel = UILabel {
        $0.textAlignment = .center
        $0.adjustsFontSizeToFitWidth = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        defaultConfigure()
    }
    
    private func setView() {
        contentView.addSubview(studentLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        studentLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func defaultConfigure() {
        studentLabel.text = nil
        contentView.backgroundColor = .white
    }
    
    func setContent(_ student: Gym_Student) {
        studentLabel.text = student.name
        
        guard let typeCode = StudentTypeCode(rawValue: student.typeCode) else { return }
        switch typeCode {
        case .normal, .busy, .holiday:
            studentLabel.text = nil
        case .scheduled:
            #if COAHDEBUG || COAHRELEASE
            studentLabel.text = student.name
            #endif
        }
        contentView.backgroundColor = typeCode.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
