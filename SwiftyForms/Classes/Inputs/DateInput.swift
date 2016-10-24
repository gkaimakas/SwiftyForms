//
//  DateInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation
import SwiftValidators

open class DateInput: TextInput {
	open var dateFormat: String = "dd-MM-yyyy"
	
	/// Sets the format of the displayed date
	
	open func setDateFormat(_ format: String) -> Self {
		dateFormat = format
		return self
	}
	
}
