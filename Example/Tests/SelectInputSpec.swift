//
//  SelectInputSpec.swift
//  SwiftyForms
//
//  Created by Γιώργος Καϊμακάς on 25/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
import Quick
import SwiftyForms
import SwiftValidators

class SelectInputSpec: QuickSpec {
	override func spec() {
		super.spec()
		
		describe("Events") {
			it("should send an event each time an option is added") {
				let select = SelectInput(name: "input")
				
				var count = 0
				
				select
					.on(add: { _ in
						count = count + 1
					})
				
				select
					.withOption(SelectInput.Option(description: "hello", value: "there"))
					.withOption(SelectInput.Option(description: "one", value: "two"))
				
				expect(count) == 2
				
				
			}
			
			it("should send an event each time an option is removed") {
				let select = SelectInput(name: "input")
				
				var count = 0
				
				select
					.on(remove: { _ in
						count = count + 1
					})
				
				select
					.withOption(SelectInput.Option(description: "hello", value: "there"))
					.withOption(SelectInput.Option(description: "one", value: "two"))
					.withOption(SelectInput.Option(description: "three", value: "four"))
				
				select.removeOptionAtIndex(1)
				select.removeOptionAtIndex(0)
				
				expect(count) == 2
				
				
			}
			
			it("should send an event each time an option is selected") {
				let select = SelectInput(name: "input")
				
				var count = 0
				
				select
					.on(select: { _ in
						count = count + 1
					})
				
				select
					.withOption(SelectInput.Option(description: "hello", value: "there"))
					.withOption(SelectInput.Option(description: "one", value: "two"))
					.withOption(SelectInput.Option(description: "three", value: "four"))
				
				select.selectOptionAtIndex(0)
				
				expect(count) == 1
				
				
			}
		}
	}
}
