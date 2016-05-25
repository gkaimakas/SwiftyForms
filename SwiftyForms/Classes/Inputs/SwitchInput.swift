//
//  SwitchInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

public class SwitchInput: Input {
	public static let OnValue = String(true)
	public static let OffValue = String(false)
	
	public convenience init(name: String, value: Bool) {
		self.init(name: name, value: value, enabled: true, hidden: true)
	}
	
	public init(name: String, value: Bool, enabled: Bool, hidden: Bool) {
		super.init(name: name, value: String(value), enabled: enabled, hidden: hidden)
	}
	
	
	public var isOn: Bool {
		return value == SwitchInput.OnValue
	}
	
	public func on() {
		self.value = SwitchInput.OnValue
	}
	
	public func off() {
		self.value = SwitchInput.OffValue
	}
	
	public func toogle() {
		self.value = (isOn) ? SwitchInput.OffValue : SwitchInput.OnValue
	}
}
