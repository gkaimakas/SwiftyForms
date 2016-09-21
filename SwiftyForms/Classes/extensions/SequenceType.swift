//
//  SequenceType.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

extension Sequence {
	func iterate(_ closure: (Self.Iterator.Element)-> Void) {
		for element in self {
			closure(element)
		}
	}
}
