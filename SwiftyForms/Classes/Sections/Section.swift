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
	
	public var data: [String: Any] {
		return _inputs
			.map() { $0.data }
			.filter() { $0 != nil }
			.map() { $0! }
			.reduce([String: Any]()) {
				return $0.0.mergeWith($0.1)
			}
	}
	
	private var _valid: Bool = true
	
	private var _inputs: [Input]
	
	private var _enabledEvents: [(Section) -> Void] = []
	private var _hiddenEvents: [(Section) -> Void] = []
	private var _valueEvents: [(Section, Input) -> Void] = []
	private var _validateEvents: [(Section) -> Void] = []
	
	public init(name: String, inputs: [Input] = []) {
		self.name = name
		self.enabled = true
		self.hidden = false
		self._inputs = inputs
		
		
		for input in inputs {
			input
				.on(value: { input in
					for event in self._valueEvents {
						event(self, input)
					}
				})
		}
	}
	
	public func on(value value: ((Section, Input)-> Void)? = nil,
	                     validate: ((Section) -> Void)? = nil,
	                     enabled: ((Section) -> Void)? = nil,
	                     hidden: ((Section) -> Void)? = nil
		) -> Section {
		
		if let event = value {
			_valueEvents.append(event)
		}
		
		if let event = validate {
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
	
	public func validate() -> Bool {
		_validate()
		
		for event in _validateEvents {
			event(self)
		}
		
		return _valid
	}
	
	private func _validate() {
		_valid = _inputs
			.map() { $0.validate() }
			.reduce(true) { $0 && $1 }
		
	}
}
