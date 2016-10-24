//
//  TimeInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 29/06/16.
//
//

import Foundation
import SwiftValidators

open class TimeInput: TextInput {
	open var timeFormat: String = "hh:mm"

	@discardableResult
	open func setTimeFormat(_ format: String) -> Self {
		timeFormat = format
		return self
	}
}
