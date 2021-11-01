//
//  HomeViewModel.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/01.
//

import Foundation
import Combine

class HomeViewModel {

    private let useCase: HomeUseCase

    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}
