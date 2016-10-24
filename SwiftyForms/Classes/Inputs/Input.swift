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
internal typealias ValidationRule = (rule: Validator, message: String)

open class Input {
	open let name: String
	
	open var data: [String: Any]? {
		if isValid == false {
			return nil
		}
		
		return  [name: value]
	}
	
	open var enabled: Bool {
		didSet {
			for event in _enabledEvents {
				event(self)
			}
		}
	}
	
	open var hidden: Bool {
		didSet {
			for event in _hiddenEvents {
				event(self)
			}
		}
	}
	
	open var hint: String? = nil {
		didSet {
			for event in _hintEvents {
				event(hint)
			}
		}
	}
	
	open var isDirty: Bool {
		return _dirty
	}
	
	open var isSubmitted: Bool {
		return _submitted
	}
	
	open var isValid: Bool {
		return _validate()
	}
	
	open var previousValue: String? {
		return _previousValue
	}
	
	open var value: String {
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
	
	fileprivate var _valueEvents: [InputEvent] = []
	fileprivate var _submitEvents: [InputEvent] = []
	fileprivate var _validateEvents: [InputEvent] = []
	fileprivate var _hiddenEvents: [InputEvent] = []
	fileprivate var _hintEvents: [(String?)->Void] = []
	fileprivate var _enabledEvents: [InputEvent] = []
	internal var _validationRules: [ValidationRule] = []
	fileprivate var _previousValue: String? = nil
	
	internal var _dirty: Bool = false
	fileprivate let _originalValue: String
	fileprivate var _valid: Bool = true
	
	
	internal var _submitted: Bool = false {
		didSet {
			if _submitted == true {
				for event: InputEvent in _submitEvents {
					event(self)
				}
			}
		}
	}
	
	public convenience init(name: String, value: String) {
		self.init(name: name, enabled: true, hidden: false)
	}
	
	public init(name: String, enabled: Bool = true, hidden: Bool = false) {
		self.name = name
		self.enabled = enabled
		self.value = ""
		self.hidden = hidden
		self._originalValue = value
	}
	
	open var errors: [String] {
		return _validationRules
			.map() { ($0.rule(value), $0.message)}
			.filter() { $0.0 == false }
			.map() { $0.1 }
	}

	@discardableResult
	open func on(value: InputEvent? = nil,
	                       validated: InputEvent? = nil,
	                       submitted: InputEvent? = nil,
	                       enabled: InputEvent? = nil,
	                       hidden: InputEvent? = nil,
	                       hint: ((String?) -> Void)? = nil) -> Self{
		
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

	@discardableResult
	open func setValue(_ value: String) -> Self {
		self.value = value
		return self
	}
	
	/**
	
	Sets the hidden property and notifies all subscribers
	
	- parameter hidden: Bool The hidden property's new value
	
	- returns: Input The updated input
	
	*/

	@discardableResult
	open func setHidden(_ hidden: Bool) -> Self {
		self.hidden = hidden
		return self
	}
	
	/**
	
	Sets the enabled property and notifies all subscribers
	
	- parameter enabled: Bool The enabled property's new value
	
	- returns: Input The updated input
	
	*/

	@discardableResult
	open func setEnabled(_ enabled: Bool) -> Self {
		self.enabled = enabled
		return self
	}
	
	/**
	
	Sets the hint and notifies all subscribers
	
	- parameter hint: String The hint's new value
	
	- returns: Input The updated input
	
	*/

	@discardableResult
	open func setHint(_ hint: String?) -> Self {
		self.hint = hint
		return self
	}
	
	/**
	
	Sets the submitted flag to true and notifies all subscribers. 
	Normally the `submit()` will be called whenever the form is submitted. 
	It should not be called on an input instance.
	
	*/
	
	open func submit() {
		_submitted = true
	}
	
	/**
	
	Validates the input for its current value.
	Notifies all subscribers for the validation event.
	
	*/
	
	open func validate() -> Bool {
		
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

	@discardableResult
	open func addValidationRule(_ rule: @escaping Validator, message: String) -> Self {
		_validationRules.append((rule: rule, message: message))
		return self
	}
	
	fileprivate func _validate() -> Bool {
		return _validationRules
			.map() { $0.rule }
			.map() { $0(value) }
			.reduce(true) { $0 && $1 }
	}
	
}
