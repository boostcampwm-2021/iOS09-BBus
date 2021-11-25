//
//  BusArriveInfos.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/25.
//

import Foundation

typealias BusArriveInfo = (firstBusArriveRemainTime: BusRemainTime?, firstBusRelativePosition: String?, firstBusCongestion: BusCongestion?, secondBusArriveRemainTime: BusRemainTime?, secondBusRelativePosition: String?, secondBusCongestion: BusCongestion?, stationOrd: Int, busRouteId: Int, nextStation: String, busNumber: String, routeType: BBusRouteType)

struct BusArriveInfos {

    private var infos: [BusArriveInfo]

    subscript(item: Int) -> BusArriveInfo? {
        guard 0..<self.infos.count ~= item else { return nil }
        return self.infos[item]
    }

    init(infos: [BusArriveInfo] = []) {
        self.infos = infos
    }

    static func +(lhs: BusArriveInfos, rhs: BusArriveInfos) -> BusArriveInfos {
        let newInfos = lhs.infos + rhs.infos
        return BusArriveInfos(infos: newInfos)
    }

    func descended() -> BusArriveInfos {
        let newInfos = self.infos.map { (info) -> BusArriveInfo in
            var result = info
            result.firstBusArriveRemainTime?.descend()
            result.secondBusArriveRemainTime?.descend()
            return result
        }
        return BusArriveInfos(infos: newInfos)
    }

    func count() -> Int {
        return self.infos.count
    }
}
