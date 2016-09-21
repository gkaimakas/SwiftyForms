//
//  SwitchInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

open class SwitchInput: Input {
	open static let OnValue = String(true)
	open static let OffValue = String(false)
	
	public convenience init(name: String) {
		self.init(name: name, enabled: true, hidden: true)
	}
	
	public override init(name: String, enabled: Bool, hidden: Bool) {
		super.init(name: name, enabled: enabled, hidden: hidden)
	}
	
	
	open var isOn: Bool {
		return value == SwitchInput.OnValue
	}
	
	open func on() {
		self.value = SwitchInput.OnValue
	}
	
	open func off() {
		self.value = SwitchInput.OffValue
	}
	
	open func toogle() {
		self.value = (isOn) ? SwitchInput.OffValue : SwitchInput.OnValue
	}
}
