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
