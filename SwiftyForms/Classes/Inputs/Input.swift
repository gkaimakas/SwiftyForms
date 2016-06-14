//
//  Input.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation
import SwiftValidators

public typealias InputEvent = (Input) -> Void
private typealias ValidationRule = (rule: Validation, message: String)

public class Input {
	public let name: String
	
	public var data: [String: Any]? {
		if isValid == false {
			return nil
		}
		
		return  [name: value]
	}
	
	public var enabled: Bool {
		didSet {
			for event in _enabledEvents {
				event(self)
			}
		}
	}
	
	public var hidden: Bool {
		didSet {
			for event in _hiddenEvents {
				event(self)
			}
		}
	}
	
	public var hint: String? = nil {
		didSet {
			for event in _hintEvents {
				event(hint)
			}
		}
	}
	
	public var isDirty: Bool {
		return _dirty
	}
	
	public var isSubmitted: Bool {
		return _submitted
	}
	
	public var isValid: Bool {
		return _validate()
	}
	
	public var previousValue: String? {
		return _previousValue
	}
	
	public var value: String {
		willSet {
			_previousValue = value
		}
		
		didSet {
			_dirty = true
			
			for event: InputEvent in _valueEvents {
				event(self)
			}
		}
	}
	
	private var _valueEvents: [InputEvent] = []
	private var _submitEvents: [InputEvent] = []
	private var _validateEvents: [InputEvent] = []
	private var _hiddenEvents: [InputEvent] = []
	private var _hintEvents: [(String?)->Void] = []
	private var _enabledEvents: [InputEvent] = []
	private var _validationRules: [ValidationRule] = []
	private var _previousValue: String? = nil
	private var _dirty: Bool = false
	private let _originalValue: String
	private var _valid: Bool = true
	
	
	private var _submitted: Bool = false {
		didSet {
			if _submitted == true {
				for event: InputEvent in _submitEvents {
					event(self)
				}
			}
		}
	}
	
	public convenience init(name: String, value: String) {
		self.init(name: name, value: value, enabled: true, hidden: false)
	}
	
	public init(name: String, value: String = "", enabled: Bool = true, hidden: Bool = false) {
		self.name = name
		self.enabled = enabled
		self.value = value
		self.hidden = hidden
		self._originalValue = value
	}
	
	public var errors: [String] {
		return _validationRules
			.map() { ($0.rule(value), $0.message)}
			.filter() { $0.0 == false }
			.map() { $0.1 }
	}
	
	public func on(value value: InputEvent? = nil,
	                       validated: InputEvent? = nil,
	                       submitted: InputEvent? = nil,
	                       enabled: InputEvent? = nil,
	                       hidden: InputEvent? = nil,
	                       hint: ((String?) -> Void)? = nil) -> Input{
		
		if let event = value {
			_valueEvents.append(event)
		}
		
		if let event = validated {
			_validateEvents.append(event)
		}
		
		if let event = submitted {
			_submitEvents.append(event)
		}
		
		if let event = enabled {
			_enabledEvents.append(event)
		}
		
		if let event = hidden {
			_hiddenEvents.append(event)
		}
		if let event = hint {
			_hintEvents.append(event)
		}
		
		return self
	}
	
	/**
	
	Sets the value and notifies all subscribers
	
	- parameter value: String The value's new value
	
	- returns: Input The updated input
	
	*/
	
	public func setValue(value: String) -> Input {
		self.value = value
		return self
	}
	
	/**
	
	Sets the hidden property and notifies all subscribers
	
	- parameter hidden: Bool The hidden property's new value
	
	- returns: Input The updated input
	
	*/
	
	public func setHidden(hidden: Bool) -> Input {
		self.hidden = hidden
		return self
	}
	
	/**
	
	Sets the enabled property and notifies all subscribers
	
	- parameter enabled: Bool The enabled property's new value
	
	- returns: Input The updated input
	
	*/
	
	public func setEnabled(enabled: Bool) -> Input {
		self.enabled = enabled
		return self
	}
	
	/**
	
	Sets the hint and notifies all subscribers
	
	- parameter hint: String The hint's new value
	
	- returns: Input The updated input
	
	*/
	
	public func setHint(hint: String?) -> Input {
		self.hint = hint
		return self
	}
	
	/**
	
	Sets the submitted flag to true and notifies all subscribers. 
	Normally the `submit()` will be called whenever the form is submitted. 
	It should not be called on an input instance.
	
	*/
	
	public func submit() {
		_submitted = true
	}
	
	/**
	
	Validates the input for its current value.
	Notifies all subscribers for the validation event.
	
	*/
	
	public func validate() -> Bool {
		
		for event in _validateEvents {
			event(self)
		}
		
		return isValid
	}
	
	/**
	
	Adds a validation rule.
	
	- parameter rule: Validation. The validation to apply on the input's value.
	- parameter message: String. The error message the is returned when the validation fails.
	
	- returns: Input
	
	*/
	
	public func addValidationRule(rule: Validation, message: String) -> Input {
		_validationRules.append((rule: rule, message: message))
		return self
	}
	
	private func _validate() -> Bool {
		return _validationRules
			.map() { $0.rule }
			.map() { $0(value) }
			.reduce(true) { $0 && $1 }
	}
	
}
