//
//  DateInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation
import SwiftValidators

public class DateInput: Input {
	public var dateFormat: String = "dd-MM-yyyy"
	
	/// Sets the format of the displayed date
	
	public func setDateFormat(format: String) -> DateInput {
		dateFormat = format
		return self
	}
	
}
