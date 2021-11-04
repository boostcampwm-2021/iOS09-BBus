//
//  AlarmSettingButton.swift
//  BBus
//
//  Created by 최수정 on 2021/11/04.
//

import UIKit

class AlarmSettingButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }

    private func configure() {
        let borderWidth: CGFloat = 0.5
        
        self.setImage(AlarmSettingViewController.Image.alarmIcon, for: .normal)
        self.setImage(AlarmSettingViewController.Image.waypoint, for: .selected)
        self.tintColor = AlarmSettingViewController.Color.alarmTint
        self.clipsToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = AlarmSettingViewController.Color.alarmTint?.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}
