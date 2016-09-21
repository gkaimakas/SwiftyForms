//
//  Section.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation

open class Section {
	open let name: String
	
	open var data: [String: Any] {
		return _inputs
			.map() { $0.data }
			.filter() { $0 != nil }
			.map() { $0! }
			.reduce([String: Any]()) {
				return $0.0.mergeWith($0.1)
		}
	}
	
	open var enabled: Bool {
		didSet {
			for event in _enabledEvents {
				event(self)
			}
		}
	}
	
	open var errors: [String] {
		var array: [String] = []
		
		for input in _inputs {
			array.append(contentsOf: input.errors)
		}
		
		return array
	}
	
	open var hidden: Bool {
		didSet {
			for event in _hiddenEvents {
				event(self)
			}
		}
	}
	
	open var isSubmitted: Bool {
		return _submitted
	}
	
	open var isValid: Bool {
		_validate()
		
		return _valid
	}
	
	open var numberOfInputs: Int {
		return _inputs
			.filter() { $0.hidden == false }
			.count
	}
	
	fileprivate var _valid: Bool = true
	fileprivate var _submitted: Bool = false
	
	fileprivate var _inputs: [Input] = []
	
	fileprivate var _enabledEvents: [(Section) -> Void] = []
	fileprivate var _hiddenEvents: [(Section) -> Void] = []
	fileprivate var _valueEvents: [(Section, Input) -> Void] = []
	fileprivate var _validateEvents: [(Section) -> Void] = []
	fileprivate var _submitEvents: [(Section) -> Void] = []
	
	fileprivate var _inputAddedEvents: [(Section, Input, Int) -> Void] = []
	fileprivate var _inputRemovedEvents: [(Section, Input, Int) -> Void] = []
	fileprivate var _inputHiddenEvents: [(Section, Input, Int) -> Void] = []
	
	public init(name: String, inputs: [Input] = []) {
		self.name = name
		self.enabled = true
		self.hidden = false
		
		for input in inputs {
			let _ = addInput(input)
		}
	}
	
	open func addInput(_ input: Input) -> Self {
		
		let _ = input
			.on(value: { input in
				let _ = self._valueEvents
					.map() { $0(self, input) }
			})
			.on(hidden: { input in
				self._inputHiddenEvents
					.iterate() { event in
				}
			})
		
		if input.hidden == true {
			_inputs.append(input)
		}
		
		if input.hidden == false {
			let index = _inputs.count
			_inputs.append(input)
			
			for event in _inputAddedEvents {
				event(self, input, index)
			}
		}
		
		
		return self
	}
	
	open func inputAtIndex(_ index: Int) -> Input {
		let visibleInputs = _inputs
			.filter() { $0.hidden == false }
		
		return visibleInputs[index]
	}
	
	open func on(value: ((Section, Input)-> Void)? = nil,
	                     validated: ((Section) -> Void)? = nil,
	                     enabled: ((Section) -> Void)? = nil,
	                     hidden: ((Section) -> Void)? = nil,
	                     submit: ((Section) -> Void)? = nil
		) -> Self {
		
		if let event = value {
			_valueEvents.append(event)
		}
		
		if let event = validated {
			_validateEvents.append(event)
		}
		
		if let event = enabled {
			_enabledEvents.append(event)
		}
		
		if let event = hidden {
			_enabledEvents.append(event)
		}
		
		
		if let event = submit {
			_submitEvents.append(event)
		}
		
		return self
	}
	
	open func on(inputAdded: ((Section, Input, Int) -> Void)? = nil,
	                          inputHidden: ((Section, Input, Int) -> Void)? = nil,
	                          inputRemoved: ((Section, Input, Int) -> Void)? = nil) -> Self {
		
		if let event = inputAdded {
			_inputAddedEvents.append(event)
		}
		
		if let event = inputHidden {
			_inputHiddenEvents.append(event)
		}
		
		if let event = inputRemoved {
			_inputRemovedEvents.append(event)
		}
		
		return self
	}
	
	open func submit() {
		let _ = _inputs
			.map() { $0.submit() }
		
		for event in _submitEvents {
			event(self)
		}
	}
	
	open func validate() -> Bool {
		_validate()
		
		for event in _validateEvents {
			event(self)
		}
		
		return _valid
	}
	
	fileprivate func _validate() {
		_valid = _inputs
			.map() { $0.validate() }
			.reduce(true) { $0 && $1 }
		
	}
}
