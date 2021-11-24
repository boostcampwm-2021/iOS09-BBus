//
//  XMLParseExample.swift
//  BBus
//
//  Created by 김태훈 on 2021/11/10.
//

import Foundation

//class BBusXMLParser: NSObject, XMLParserDelegate {
//    
//    var stack = [[String:[Any]]]()
//    
//    static let baseKey = "bbus"
//
//    func parse<T: BBusXMLDTO>(dtoType: T.Type, xml: Data) -> T? {
//        let parser = XMLParser(data: xml)
//        
//        parser.delegate = self
//        parser.parse()
//
//        if let serviceResult = self.stack.first?.values.first?[0] as? [String:[Any]] {
//            return T.init(dict: serviceResult)
//        }
//        else {
//            return nil
//        }
//    }
//
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        self.stack.append([elementName:[Any]()])
//    }
//
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        var tempDict = ["bbus": []]
//        while (self.stack.last?[elementName] == nil) {
//            if let lastElement = self.stack.popLast() {
//                tempDict.merge(lastElement) { tempDictValue, lastElementValue in
//                    return lastElementValue + tempDictValue
//                }
//            }
//        }
//        _ = self.stack.popLast()
//        self.stack.append([elementName:[tempDict]])
//    }
//
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        self.stack.append([Self.baseKey:[string]])
//    }
//}
