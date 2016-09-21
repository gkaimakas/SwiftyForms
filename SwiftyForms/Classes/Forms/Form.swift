//
//  Form.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 14/06/16.
//
//

import Foundation

open class Form {
	open let name: String
	
	fileprivate var _sections: [Section]
	
	open var data: [String: Any]? {
		return self._sections
			.map() { $0.data }
			.filter() { $0 != nil }
			.map() { $0! }
			.reduce([String: Any]()) {
				return $0.0?.mergeWith($0.1)
			}
	}
	
	open var errors: [String] {
		var array:[String] = []
		for section in _sections {
			array.append(contentsOf: section.errors)
		}
		return array
	}
	
	open var isSubmitted: Bool {
		return _submitted
	}
	
	open var isValid: Bool {
		return _valid
	}
	
	open var numberOfSections: Int {
		return _sections
			.filter() { $0.hidden == false }
			.count
	}
	
	open func toObject<T: FormDataSerializable>(_ type: T.Type) -> T? {
		return T(data: self.data)
	}
	
	fileprivate var _valid = false
	fileprivate var _submitted = false
	
	fileprivate var _valueEvents: [(Form, Section, Input) -> Void] = []
	fileprivate var _validateEvents: [(Form) -> Void] = []
	fileprivate var _submitEvents: [(Form) -> Void] = []
	
	public init (name: String, sections: [Section] = []) {
		self.name = name
		self._sections = sections
	}
	
	open func addSection(_ section: Section) -> Form {
		_sections.append(section)
		return self
	}
	
	open func on(_ value: ((Form, Section, Input) -> Void)? = nil,
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
	
	open func sectionAtIndex(_ index: Int) -> Section {
		let sections = _sections
			.filter() { $0.hidden == false}
		
		return sections[index]
	}
	
	open func submit() {
		let _ = _sections
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
		_valid = _sections
			.map() { $0.validate() }
			.reduce(true) { $0 && $1 }
		
	}
}
