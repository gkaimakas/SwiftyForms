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
	                       validate: InputEvent? = nil,
	                       submit: InputEvent? = nil,
	                       enabled: InputEvent? = nil,
	                       hidden: InputEvent? = nil,
	                       hint: ((String?) -> Void)? = nil) -> Input{
		
		if let event = value {
			_valueEvents.append(event)
		}
		
		if let event = validate {
			_validateEvents.append(event)
		}
		
		if let event = submit {
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
	
	public func submit() {
		_submitted = true
	}
	
	public func updateValue(value: String) -> Input {
		return update(value: { value })
	}
	
	public func updateHidden(hidden: Bool) -> Input {
		return update(hidden: { hidden })
	}
	
	public func updateEnabled(enabled: Bool) -> Input {
		return update(enabled: { enabled })
	}
	
	public func updateHint(hint: String?) -> Input {
		return update(hint: { hint })
	}
	
	public func update(value value: (() -> String)? = nil,
	                         hidden: (() -> Bool)? = nil,
	                         enabled: (() -> Bool)? = nil,
	                         hint: (() -> String?)? = nil
		) -> Input {
		
		if let value = value {
			self.value = value()
		}
		
		if let hint = hint {
			self.hint = hint()
		}
		
		if let hidden = hidden {
			self.hidden = hidden()
		}
		
		if let enabled = enabled {
			self.enabled = enabled()
		}
		
		return self
	}
	
	public func validate() -> Bool {
		
		for event in _validateEvents {
			event(self)
		}
		
		return isValid
	}
	
	public func withValidationRule(rule: Validation, message: String) -> Input {
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
