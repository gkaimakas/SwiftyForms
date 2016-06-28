//
//  Form.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 14/06/16.
//
//

import Foundation

public class Form {
	public let name: String
	
	private var _sections: [Section]
	
	public var data: [String: Any]? {
		return self._sections
			.map() { $0.data }
			.filter() { $0 != nil }
			.map() { $0! }
			.reduce([String: Any]()) {
				return $0.0.mergeWith($0.1)
			}
	}
	
	public func toObject<T: FormDataSerializable>(type: T.Type) -> T? {
		return T(data: self.data)
	}
	
	public var isSubmitted: Bool {
		return _submitted
	}
	
	public var _isValid: Bool {
		return _valid
	}
	
	public var numberOfSections: Int {
		return _sections
			.filter() { $0.hidden == false }
			.count
	}
	
	private var _valid = false
	private var _submitted = false
	
	private var _valueEvents: [(Form, Section, Input) -> Void] = []
	private var _validateEvents: [(Form) -> Void] = []
	private var _submitEvents: [(Form) -> Void] = []
	
	public init (name: String, sections: [Section] = []) {
		self.name = name
		self._sections = sections
	}
	
	public func addSection(section: Section) -> Form {
		_sections.append(section)
		return self
	}
	
	public func on(value: ((Form, Section, Input) -> Void)? = nil,
	               validate: ((Form) -> Void)? = nil,
	               submit: ((Form) -> Void)? = nil) -> Self {
		
		if let event = value {
			_valueEvents.append(event)
		}
		
		if let event = validate {
			_validateEvents.append(event)
		}
		
		if let event = submit {
			_submitEvents.append(event)
		}
		
		return self
		
	}
	
	public func sectionAtIndex(index: Int) -> Section {
		let sections = _sections
			.filter() { $0.hidden == false}
		
		return sections[index]
	}
	
	public func submit() {
		let _ = _sections
			.map() { $0.submit() }
		
		for event in _submitEvents {
			event(self)
		}
	}
	
	public func validate() -> Bool {
		_validate()
		
		for event in _validateEvents {
			event(self)
		}
		
		return _valid
	}
	
	private func _validate() {
		_valid = _sections
			.map() { $0.validate() }
			.reduce(true) { $0 && $1 }
		
	}
}
