//
//  File.swift
//  
//
//  Created by Michael Redig on 3/2/20.
//

import Foundation

public enum DataConvert {

	public static func binStringToData(_ string: String) -> Data {
		let values = string.split(separator: "\n")
			.map { String($0)}
//			.compactMap { $0 }
		let ints = values.map { UInt8($0, radix: 2) }.compactMap { $0 }
		return Data(ints)
	}

}
