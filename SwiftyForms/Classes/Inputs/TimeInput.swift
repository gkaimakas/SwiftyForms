//
//  TimeInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 29/06/16.
//
//

import Foundation
import SwiftValidators

public class TimeInput: TextInput {
	public var timeFormat: String = "hh:mm"
	
	public func setTimeFormat(format: String) -> TimeInput {
		timeFormat = format
		return self
	}
}
