//
//  WeekView.swift
//  MyWeek
//
//  Created by EVERTRUST on 2020/4/24.
//  Copyright © 2020 Shen Wei Ting. All rights reserved.
//

import UIKit
import SnapKit

protocol WeekViewDelegate: class {
    func weekView(_ view: WeekView, userPressDay day: Int)
}

class WeekView: UIScrollView {
    
    weak var weekDelegate: WeekViewDelegate?
    
    private var lastLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        contentInset = .init(top: 0, left: 50, bottom: 0, right: 0)
        bounces = false
        isScrollEnabled = false
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var label = UIView()
        subviews.filter { $0 is UILabel }.forEach { label = $0 }
        contentSize = .init(width: label.bounds.width * 31, height: label.bounds.height)
        showsHorizontalScrollIndicator = false
    }
    
    private func configure() {
        let month = Calendar.current.component(.month, from: Date())
        let today = Calendar.current.component(.day, from: Date())
        (1...31).forEach { day in
            let label = UILabel {
                $0.tag = day
                $0.text = "\(month)/\(day)"
                $0.textColor = .black
                $0.textAlignment = .center
                $0.backgroundColor = today == day ? UIColor(red: 0, green: 236, blue: 0) : .lightGray
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(configureRecognizer())
            }
            
            addSubview(label)
            
            let width = 65
            if let lastLabel = lastLabel {
                label.snp.makeConstraints { (make) in
                    make.left.equalTo(lastLabel.snp.right).offset(1)
                    make.top.bottom.equalTo(lastLabel)
                    make.width.equalTo(width)
                    make.height.equalTo(24)
                }
            } else {
                label.snp.makeConstraints { (make) in
                    make.left.top.equalToSuperview()
                    make.bottom.equalTo(-1)
                    make.width.equalTo(width)
                    make.height.equalTo(24)
                }
            }
            lastLabel = label
        }
    }
    
    private func configureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(longPressed(_:)))
    }
    
    @objc private func longPressed(_ recognizer: UITapGestureRecognizer) {
        guard let label = recognizer.view as? UILabel, label.tag != 0 else { return }
        weekDelegate?.weekView(self, userPressDay: label.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
