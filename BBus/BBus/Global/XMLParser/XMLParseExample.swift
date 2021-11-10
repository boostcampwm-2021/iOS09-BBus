//
//  XMLParseExample.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/10.
//

import Foundation

let xml = "<ServiceResult><comMsgHeader/><msgHeader><headerCd>0</headerCd><headerMsg>정상적으로 처리되었습니다.</headerMsg><itemCount>0</itemCount></msgHeader><msgBody><itemList><arrmsg1>7분18초후[2번째 전]</arrmsg1><arrmsg2>12분50초후[4번째 전]</arrmsg2><arsId>23278</arsId><avgCf1>0</avgCf1><avgCf2>0</avgCf2><brdrde_Num1>3</brdrde_Num1><brdrde_Num2>0</brdrde_Num2><brerde_Div1>4</brerde_Div1><brerde_Div2>0</brerde_Div2><busRouteId>104000006</busRouteId><busType1>0</busType1><busType2>0</busType2><deTourAt>00</deTourAt><dir> </dir><expCf1>1</expCf1><expCf2>1</expCf2><exps1>395</exps1><exps2>732</exps2><firstTm>20211110055700</firstTm><full1>0</full1><full2>0</full2><goal1>3772</goal1><goal2>3927</goal2><isArrive1>0</isArrive1><isArrive2>0</isArrive2><isLast1>0</isLast1><isLast2>0</isLast2><kalCf1>0</kalCf1><kalCf2>0</kalCf2><kals1>575</kals1><kals2>784</kals2><lastTm>20211111002400</lastTm><mkTm>2021-11-10 15:32:40.0</mkTm><namin2Sec1>0</namin2Sec1><namin2Sec2>0</namin2Sec2><neuCf1>0</neuCf1><neuCf2>0</neuCf2><neus1>445</neus1><neus2>774</neus2><nextBus> </nextBus><nmain2Ord1>0</nmain2Ord1><nmain2Ord2>0</nmain2Ord2><nmain2Stnid1>0</nmain2Stnid1><nmain2Stnid2>0</nmain2Stnid2><nmain3Ord1>0</nmain3Ord1><nmain3Ord2>0</nmain3Ord2><nmain3Sec1>0</nmain3Sec1><nmain3Sec2>0</nmain3Sec2><nmain3Stnid1>0</nmain3Stnid1><nmain3Stnid2>0</nmain3Stnid2><nmainOrd1>0</nmainOrd1><nmainOrd2>0</nmainOrd2><nmainSec1>0</nmainSec1><nmainSec2>0</nmainSec2><nmainStnid1>0</nmainStnid1><nmainStnid2>0</nmainStnid2><nstnId1>122000200</nstnId1><nstnId2>122000390</nstnId2><nstnOrd1>70</nstnOrd1><nstnOrd2>68</nstnOrd2><nstnSec1>0</nstnSec1><nstnSec2>147</nstnSec2><nstnSpd1>0</nstnSpd1><nstnSpd2>8</nstnSpd2><plainNo1>8서울74사1598</plainNo1><plainNo2>서울74사4285</plainNo2><repTm1>2021-04-15 12:06:41.0</repTm1><rerdie_Div1>4</rerdie_Div1><rerdie_Div2>4</rerdie_Div2><reride_Num1>3</reride_Num1><reride_Num2>3</reride_Num2><routeType>3</routeType><rtNm>242</rtNm><sectOrd1>70</sectOrd1><sectOrd2>68</sectOrd2><stId>122000175</stId><stNm>8Hello</stNm><staOrd>72</staOrd><stationNm1>영동중앙교회</stationNm1><stationNm2>8신한은행데이터센터</stationNm2><term>14</term><traSpd1>13</traSpd1><traSpd2>10</traSpd2><traTime1>438</traTime1><traTime2>770</traTime2><vehId1>104011173</vehId1><vehId2>104010107</vehId2></itemList><itemList><arrmsg1>7분18초후[2번째 전]</arrmsg1><arrmsg2>12분50초후[4번째 전]</arrmsg2><arsId>23278</arsId><avgCf1>0</avgCf1><avgCf2>0</avgCf2><brdrde_Num1>3</brdrde_Num1><brdrde_Num2>0</brdrde_Num2><brerde_Div1>4</brerde_Div1><brerde_Div2>0</brerde_Div2><busRouteId>104000006</busRouteId><busType1>0</busType1><busType2>0</busType2><deTourAt>00</deTourAt><dir> </dir><expCf1>1</expCf1><expCf2>1</expCf2><exps1>395</exps1><exps2>732</exps2><firstTm>20211110055700</firstTm><full1>0</full1><full2>0</full2><goal1>3772</goal1><goal2>3927</goal2><isArrive1>0</isArrive1><isArrive2>0</isArrive2><isLast1>0</isLast1><isLast2>0</isLast2><kalCf1>0</kalCf1><kalCf2>0</kalCf2><kals1>575</kals1><kals2>784</kals2><lastTm>20211111002400</lastTm><mkTm>2021-11-10 15:32:40.0</mkTm><namin2Sec1>0</namin2Sec1><namin2Sec2>0</namin2Sec2><neuCf1>0</neuCf1><neuCf2>0</neuCf2><neus1>445</neus1><neus2>774</neus2><nextBus> </nextBus><nmain2Ord1>0</nmain2Ord1><nmain2Ord2>0</nmain2Ord2><nmain2Stnid1>0</nmain2Stnid1><nmain2Stnid2>0</nmain2Stnid2><nmain3Ord1>0</nmain3Ord1><nmain3Ord2>0</nmain3Ord2><nmain3Sec1>0</nmain3Sec1><nmain3Sec2>0</nmain3Sec2><nmain3Stnid1>0</nmain3Stnid1><nmain3Stnid2>0</nmain3Stnid2><nmainOrd1>0</nmainOrd1><nmainOrd2>0</nmainOrd2><nmainSec1>0</nmainSec1><nmainSec2>0</nmainSec2><nmainStnid1>0</nmainStnid1><nmainStnid2>0</nmainStnid2><nstnId1>122000200</nstnId1><nstnId2>122000390</nstnId2><nstnOrd1>70</nstnOrd1><nstnOrd2>68</nstnOrd2><nstnSec1>0</nstnSec1><nstnSec2>147</nstnSec2><nstnSpd1>0</nstnSpd1><nstnSpd2>8</nstnSpd2><plainNo1>8서울74사1598</plainNo1><plainNo2>서울74사4285</plainNo2><repTm1>2021-04-15 12:06:41.0</repTm1><rerdie_Div1>4</rerdie_Div1><rerdie_Div2>4</rerdie_Div2><reride_Num1>3</reride_Num1><reride_Num2>3</reride_Num2><routeType>3</routeType><rtNm>242</rtNm><sectOrd1>70</sectOrd1><sectOrd2>68</sectOrd2><stId>122000175</stId><stNm>8Hello</stNm><staOrd>72</staOrd><stationNm1>영동중앙교회</stationNm1><stationNm2>8신한은행데이터센터</stationNm2><term>14</term><traSpd1>13</traSpd1><traSpd2>10</traSpd2><traTime1>438</traTime1><traTime2>770</traTime2><vehId1>104011173</vehId1><vehId2>104010107</vehId2></itemList><itemList><arrmsg1>7분18초후[2번째 전]</arrmsg1><arrmsg2>12분50초후[4번째 전]</arrmsg2><arsId>23278</arsId><avgCf1>0</avgCf1><avgCf2>0</avgCf2><brdrde_Num1>3</brdrde_Num1><brdrde_Num2>0</brdrde_Num2><brerde_Div1>4</brerde_Div1><brerde_Div2>0</brerde_Div2><busRouteId>104000006</busRouteId><busType1>0</busType1><busType2>0</busType2><deTourAt>00</deTourAt><dir> </dir><expCf1>1</expCf1><expCf2>1</expCf2><exps1>395</exps1><exps2>732</exps2><firstTm>20211110055700</firstTm><full1>0</full1><full2>0</full2><goal1>3772</goal1><goal2>3927</goal2><isArrive1>0</isArrive1><isArrive2>0</isArrive2><isLast1>0</isLast1><isLast2>0</isLast2><kalCf1>0</kalCf1><kalCf2>0</kalCf2><kals1>575</kals1><kals2>784</kals2><lastTm>20211111002400</lastTm><mkTm>2021-11-10 15:32:40.0</mkTm><namin2Sec1>0</namin2Sec1><namin2Sec2>0</namin2Sec2><neuCf1>0</neuCf1><neuCf2>0</neuCf2><neus1>445</neus1><neus2>774</neus2><nextBus> </nextBus><nmain2Ord1>0</nmain2Ord1><nmain2Ord2>0</nmain2Ord2><nmain2Stnid1>0</nmain2Stnid1><nmain2Stnid2>0</nmain2Stnid2><nmain3Ord1>0</nmain3Ord1><nmain3Ord2>0</nmain3Ord2><nmain3Sec1>0</nmain3Sec1><nmain3Sec2>0</nmain3Sec2><nmain3Stnid1>0</nmain3Stnid1><nmain3Stnid2>0</nmain3Stnid2><nmainOrd1>0</nmainOrd1><nmainOrd2>0</nmainOrd2><nmainSec1>0</nmainSec1><nmainSec2>0</nmainSec2><nmainStnid1>0</nmainStnid1><nmainStnid2>0</nmainStnid2><nstnId1>122000200</nstnId1><nstnId2>122000390</nstnId2><nstnOrd1>70</nstnOrd1><nstnOrd2>68</nstnOrd2><nstnSec1>0</nstnSec1><nstnSec2>147</nstnSec2><nstnSpd1>0</nstnSpd1><nstnSpd2>8</nstnSpd2><plainNo1>8서울74사1598</plainNo1><plainNo2>서울74사4285</plainNo2><repTm1>2021-04-15 12:06:41.0</repTm1><rerdie_Div1>4</rerdie_Div1><rerdie_Div2>4</rerdie_Div2><reride_Num1>3</reride_Num1><reride_Num2>3</reride_Num2><routeType>3</routeType><rtNm>242</rtNm><sectOrd1>70</sectOrd1><sectOrd2>68</sectOrd2><stId>122000175</stId><stNm>8Hello</stNm><staOrd>72</staOrd><stationNm1>영동중앙교회</stationNm1><stationNm2>8신한은행데이터센터</stationNm2><term>14</term><traSpd1>13</traSpd1><traSpd2>10</traSpd2><traTime1>438</traTime1><traTime2>770</traTime2><vehId1>104011173</vehId1><vehId2>104010107</vehId2></itemList></msgBody></ServiceResult>"



struct GovernmentMessageHeader: BBusXMLDTO {
    private let headerCode: String
    private let headerMessage: String
    private let itemCount: String // 제대로 출력되지 않음.
    init?(dict: [String : [Any]]) {
        guard let headerCode = ((dict["headerCd"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let headerMessage = ((dict["headerMsg"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }),
              let itemCount = ((dict["itemCount"]?[0] as? [String:[Any]])?["bbus"] as? [String])?.reduce("", { $0 + $1 }) else { return nil }

        self.headerCode = headerCode
        self.headerMessage = headerMessage
        self.itemCount = itemCount
    }
}

struct GovernmentMessageBody: BBusXMLDTO {
    private let itemList: [ArrInfoByRouteDTO]

    init?(dict: [String : [Any]]) {
        dump(dict["itemList"]!)
        guard let itemList = dict["itemList"] as? [[String:[Any]]] else { return nil }
        self.itemList = itemList.map({ ArrInfoByRouteDTO(dict: $0)! })
    }
}

struct GovernmentServiceResult: BBusXMLDTO {
    var header: GovernmentMessageHeader
    var body: GovernmentMessageBody

    init?(dict: [String : [Any]]) {
        guard let headerDict = dict["msgHeader"]?[0] as? [String:[Any]],
              let bodyDict = dict["msgBody"]?[0] as? [String:[Any]],
              let header = GovernmentMessageHeader(dict: headerDict),
              let body = GovernmentMessageBody(dict: bodyDict) else { return nil }

        self.header = header
        self.body = body
    }
}

class BBusParser: NSObject, XMLParserDelegate {

    var stack = [[String:[Any]]]()

    func parse<T: BBusXMLDTO>(dtoType: T.Type, xml: Data) -> T? {
        let parser = XMLParser(data: xml)
        parser.delegate = self
        parser.parse()

        return T.init(dict: self.stack.first!["ServiceResult"]![0] as! [String:[Any]])
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.stack.append([elementName:[Any]()])
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        var tempDict = [String:[Any]]()
        while (self.stack.last![elementName] == nil) {
            let lastElement = self.stack.popLast()!
            tempDict.merge(lastElement) { tempDictValue, lastElementValue in
                return lastElementValue + tempDictValue
            }
        }
        self.stack.popLast()
        self.stack.append([elementName:[tempDict]])
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.stack.append(["bbus":[string]])
    }
}

protocol BBusXMLDTO {
    init?(dict: [String:[Any]])
}


