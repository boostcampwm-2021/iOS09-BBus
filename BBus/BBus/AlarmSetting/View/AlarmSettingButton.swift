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
        
        self.setImage(BBusImage.alarmOffIcon, for: .normal)
        self.setImage(BBusImage.alarmOnIcon, for: .selected)
        self.tintColor = BBusColor.alarmTint
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = BBusColor.alarmTint?.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}
