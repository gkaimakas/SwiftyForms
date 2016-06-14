//
//  SelectInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//
//

import Foundation

public class SelectInput: Input {
	
	public struct Option {
		public let description: String
		public let value: String
		
		public init(description: String, value: String) {
			self.description = description
			self.value = value
		}
	}
	
	private var _options: [Option] = []
	private var _optionAddEvents: [(SelectInput, Option) -> Void] = []
	private var _optionRemoveEvents: [(SelectInput, Option) -> Void] = []
	private var _optionSelectEvents: [(SelectInput, Option) -> Void] = []
	
	public var numberOfOptions: Int {
		return _options.count
	}
	
	public func on(add add: ((SelectInput, Option) -> Void)? = nil,
	                   select: ((SelectInput, Option) -> Void)? = nil,
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
	
	public func optionAtIndex(index: Int) -> Option {
		return _options[index]
	}
	
	public func removeOptionAtIndex(index: Int) {
		let option = _options[index]
		_options.removeAtIndex(index)
		
		for event in _optionRemoveEvents {
			event(self, option)
		}
	}
	
	public func selectOptionAtIndex(index: Int) {
		let option = _options[index]
		value = option.value
		
		for event in _optionSelectEvents {
			event(self, option)
		}
	}
	
	public func withOption(option: Option) -> SelectInput {
		
		_options.append(option)
		
		for event in _optionAddEvents {
			event(self, option)
		}
		
		return self
	}
}