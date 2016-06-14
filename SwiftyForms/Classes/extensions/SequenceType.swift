//
//  SequenceType.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

extension SequenceType {
	func iterate(closure: (Self.Generator.Element)-> Void) {
		for element in self {
			closure(element)
		}
	}
}
