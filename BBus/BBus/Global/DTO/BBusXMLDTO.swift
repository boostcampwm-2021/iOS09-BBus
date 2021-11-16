//
//  BBusXMLDTO.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

protocol BBusXMLDTO {
    init?(dict: [String:[Any]])
}

struct GovernmentMessageHeader: BBusXMLDTO {
    private let headerCode: String
    private let headerMessage: String
    private let itemCount: String // 제대로 출력되지 않음.
    init?(dict: [String : [Any]]) {
        guard let headerCode = ((dict["headerCd"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let headerMessage = ((dict["headerMsg"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }),
              let itemCount = ((dict["itemCount"]?[0] as? [String:[Any]])?[BBusXMLParser.baseKey] as? [String])?.reduce("", { $0 + $1 }) else { return nil }

        self.headerCode = headerCode
        self.headerMessage = headerMessage
        self.itemCount = itemCount
    }
}
