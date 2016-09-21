//
//  SelectInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

open class SelectInput: TextInput {
	
	public struct Option {
		public let description: String?
		public let value: String
		
		public init(description: String?, value: String) {
			self.description = description
			self.value = value
		}
	}
	
	fileprivate var _options: [Option] = []
	fileprivate var _optionAddEvents: [(SelectInput, Option) -> Void] = []
	fileprivate var _optionRemoveEvents: [(SelectInput, Option) -> Void] = []
	fileprivate var _optionSelectEvents: [(SelectInput, Option, Int) -> Void] = []
	
	fileprivate var _selectedOptionIndex: Int? = nil
	
	open var selectedOptionIndex: Int? {
		return _selectedOptionIndex
	}
	
	open var numberOfOptions: Int {
		return _options.count
	}
	
	open func on(add: ((SelectInput, Option) -> Void)? = nil,
	                   select: ((SelectInput, Option, Int) -> Void)? = nil,
	                   remove: ((SelectInput, Option) -> Void)? = nil
	                   ) -> SelectInput {
		
		if let event = add {
			_optionAddEvents.append(event)
		}
		
		if let event = select {
			_optionSelectEvents.append(event)
		}
		
		if let event = remove {
			_optionRemoveEvents.append(event)
		}
		
		return self
	}
	
	open func optionAtIndex(_ index: Int) -> Option {
		return _options[index]
	}
	
	/// Removes all options
	
	open func removeAllOptions() {
		for _ in _options {
			self.removeOptionAtIndex(0)
		}
	}
	
	/// Removes the specified option at index
	
	open func removeOptionAtIndex(_ index: Int) {
		let option = _options[index]
		_options.remove(at: index)
		
		for event in _optionRemoveEvents {
			event(self, option)
		}
	}
	
	open func selectOptionAtIndex(_ index: Int) -> SelectInput {
		let option = _options[index]
		value = option.value
		_selectedOptionIndex = index
		
		for event in _optionSelectEvents {
			event(self, option, index)
		}
		
		return self
	}
	
	open func addOption(_ option: Option) -> SelectInput {
		_options.append(option)
		
		for event in _optionAddEvents {
			event(self, option)
		}
		
		return self
	}
	
	open func addOptionWithDescription(_ description: String?, value: String) -> SelectInput {
		return addOption(SelectInput.Option(description: description, value: value))
	}
}
