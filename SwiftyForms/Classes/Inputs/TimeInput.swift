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
	
	open func setTimeFormat(_ format: String) -> TimeInput {
		timeFormat = format
		return self
	}
}
