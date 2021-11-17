//
//  ThrottleButton.swift
//  BBus
//
//  Created by 최수정 on 2021/11/17.
//

import UIKit

class ThrottleButton: UIButton {

    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: (() -> Void)?
    
    func addTouchUpEventWithThrottle(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
        
        self.addTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
    }
    
    @objc private func touchUpInside(_ sender: UIButton) {
        if self.workItem == nil {
            self.callback?()
            
            let workItem = DispatchWorkItem(block: { [weak self] in
                self?.workItem?.cancel()
                self?.workItem = nil
            })
            self.workItem = workItem
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
    
    deinit {
        self.removeTarget(self, action: #selector(self.touchUpInside(_:)), for: .touchUpInside)
    }

}
