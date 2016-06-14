//
//  Section.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//
//

import Foundation

public class Section {
	public let name: String
	
	public var data: [String: Any] {
		return _inputs
			.map() { $0.data }
			.filter() { $0 != nil }
			.map() { $0! }
			.reduce([String: Any]()) {
				return $0.0.mergeWith($0.1)
		}
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
	
	public var numberOfInputs: Int {
		return _inputs
			.filter() { $0.hidden == false }
			.count
	}
	
	private var _valid: Bool = true
	
	private var _inputs: [Input] = []
	
	private var _enabledEvents: [(Section) -> Void] = []
	private var _hiddenEvents: [(Section) -> Void] = []
	private var _valueEvents: [(Section, Input) -> Void] = []
	private var _validateEvents: [(Section) -> Void] = []
	
	private var _inputAddedEvents: [(Section, Input, Int) -> Void] = []
	private var _inputRemovedEvents: [(Section, Input, Int) -> Void] = []
	private var _inputHiddenEvents: [(Section, Input, Int) -> Void] = []
	
	public init(name: String, inputs: [Input] = []) {
		self.name = name
		self.enabled = true
		self.hidden = false
		
		for input in inputs {
			addInput(input)
		}
	}
	
	public func inputAtIndex(index: Int) -> Input {
		let visibleInputs = _inputs
			.filter() { $0.hidden == false }
		
		return visibleInputs[index]
	}
	
	public func on(value value: ((Section, Input)-> Void)? = nil,
	                     validated: ((Section) -> Void)? = nil,
	                     enabled: ((Section) -> Void)? = nil,
	                     hidden: ((Section) -> Void)? = nil
		) -> Section {
		
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
		
		return self
	}
	
	public func on(inputAdded inputAdded: ((Section, Input, Int) -> Void)? = nil,
	                          inputHidden: ((Section, Input, Int) -> Void)? = nil,
	                          inputRemoved: ((Section, Input, Int) -> Void)? = nil) -> Section {
		
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
	
	public func validate() -> Bool {
		_validate()
		
		for event in _validateEvents {
			event(self)
		}
		
		return _valid
	}
	
	public func addInput(input: Input) -> Section {
		
		input
			.on(value: { input in
				self._valueEvents
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
	
	private func _validate() {
		_valid = _inputs
			.map() { $0.validate() }
			.reduce(true) { $0 && $1 }
		
	}
}
