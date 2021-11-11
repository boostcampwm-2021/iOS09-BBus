//
//  StationViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class StationViewModel {
    
    let usecase: StationUsecase
    private let arsId: String
    private var cancellables: Set<AnyCancellable>
    
    init(usecase: StationUsecase, arsId: String) {
        self.usecase = usecase
        self.arsId = arsId
        self.cancellables = []
        self.bindingWithStationInfo()
        self.usecase.stationInfoWillLoad(with: arsId)
        self.usecase.refreshInfo(about: arsId)
    }
    
    func bindingWithStationInfo() {
    }
}
