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
        contentSize = .init(width: label.bounds.width * 7, height: label.bounds.height)
        showsHorizontalScrollIndicator = false
    }
    
    private func configure() {
        var day = 1
        ["ㄧ", "二", "三", "四", "五", "六", "日"].forEach { week in
            let label = UILabel {
                $0.tag = day
                $0.text = week
                $0.textColor = .black
                $0.textAlignment = .center
                $0.backgroundColor = week.isEmpty ? .clear : .lightGray
                $0.isUserInteractionEnabled = true
                $0.addGestureRecognizer(configureRecognizer())
            }
            
            addSubview(label)
            
            let width = 65//week.isEmpty ? 32 : ((UIScreen.main.bounds.width - 32) / 7) - 1
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
            day += 1
        }
    }
    
    private func configureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(longPressed(_:)))
    }
    
    @objc private func longPressed(_ recognizer: UITapGestureRecognizer) {
        guard let label = recognizer.view as? UILabel else { return }
        weekDelegate?.weekView(self, userPressDay: label.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
