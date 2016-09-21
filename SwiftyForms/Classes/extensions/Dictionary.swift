//
//  Dictionary.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation

extension Dictionary {
	func mergeWith(_ dictionary: Dictionary) -> Dictionary {
		var mutableDict = self
		for (key, value) in dictionary {
			mutableDict[key] = value
		}
		
		return mutableDict
	}

}
