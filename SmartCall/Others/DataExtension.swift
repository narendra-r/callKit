//
//  DataExtension.swift
//  SmartCall
//
//  Created by Narendra Kumar R on 7/3/18.
//  Copyright © 2018 Narendra Kumar R. All rights reserved.
//

import Foundation
extension Data {
    func base16EncodedString(uppercase: Bool = false) -> String {
        let buffer = UnsafeBufferPointer<UInt8>(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count),
                                                count: self.count)
        let hexFormat = uppercase ? "X" : "x"
        let formatString = "%02\(hexFormat)"
        let bytesAsHexStrings = buffer.map {
            String(format: formatString, $0)
        }
        return bytesAsHexStrings.joined(separator: "")
    }
}
