//
//  Form.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 14/06/16.
//
//

import Foundation

public class Form<T: FormDataSerializable> {
	public let name: String
	
	private var _sections: [Section]
	
	public var data: [String: Any]? {
		return nil
	}
	
	public var dataObject: T? {
		return T(data: self.data)
	}
	
	public var numberOfSections: Int {
		return _sections
			.filter() { $0.hidden == false }
			.count
	}
	
	public init (name: String, sections: [Section] = []) {
		self.name = name
		self._sections = sections
	}
	
	public func addSection(section: Section) -> Form {
		_sections.append(section)
		return self
	}
	
	public func sectionAtIndex(index: Int) -> Section {
		let sections = _sections
			.filter() { $0.hidden == false}
		
		return sections[index]
	}
}
