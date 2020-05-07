//
//  TimeView.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/27.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit

class TimeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        configureUI()
    }
    
    var lastLabel: UILabel?
    
    private func configureUI() {
        for i in 8..<24 {
            let label = UILabel {
                $0.text = "\(i):00\r｜\r\(i + 1):00"
                $0.numberOfLines = 0
                $0.textAlignment = .center
                $0.backgroundColor = .white
                $0.font = .systemFont(ofSize: 12)
                $0.adjustsFontSizeToFitWidth = true
            }
            addSubview(label)
            
            let height = Int((UIScreen.main.bounds.height - 112) / 16) - 1
            
            if let lastLabel = self.lastLabel {
                label.snp.makeConstraints { (make) in
                    make.left.right.height.equalTo(lastLabel)
                    make.top.equalTo(lastLabel.snp.bottom).offset(1)
                }
            } else {
                label.snp.makeConstraints { (make) in
                    make.left.top.equalToSuperview()
                    make.right.equalTo(-1)
                    make.height.equalTo(height)
                }
            }
            lastLabel = label
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
