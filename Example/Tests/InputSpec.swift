//
//  InputSpec.swift
//  SwiftyForms
//
//  Created by Γιώργος Καϊμακάς on 24/05/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import Nimble
import Quick
import SwiftyForms
import SwiftValidators

class InputSpec: QuickSpec {
	override func spec() {
		super.spec()
		
		describe("Init") {
			it("should be initialized") {
				let input = Input(name: "input")
				expect(input.name) == "input"
				expect(input.enabled) == true
				expect(input.hidden) == false
				expect(input.isSubmitted) == false
				expect(input.isDirty) == false
				expect(input.hint).to(beNil())
				
				let inp = Input(name: "")
					.setHint("hello")
				
				expect(inp.hint).to(equal("hello"))
			}
			
		}
		
		describe("Errors") {
			it("should return an array with errors if the occur") {
				let input = Input(name: "input")
					.addValidationRule(Validator.required, message: "err_required")
					.addValidationRule(Validator.minLength(2), message: "err_min_length")
				
				expect(input.errors.count) == 2
				expect(input.errors[0]) == "err_required"
				
				input.value = "hello"
				expect(input.errors.count) == 0
			}
		}
		
		describe("Events") {
			
			context("Value") {
				it("should call the value event whenever the value changes explicitly") {
					let input = Input(name: "input")
					var called = false
					var value = ""
					
					input.on(value: { input in
						called = true
						value = input.value
					})
					
					input.value = "hello"
					
					expect(called).toEventually(equal(true))
					expect(value).toEventually(equal("hello"))
				}
				
				it("should call the value event whenever the value is updated through the update") {
					let input = Input(name: "input")
					var called = false
					var value = ""
					
					input.on(value: { input in
						called = true
						value = input.value
					})
					
					input.setValue("hello")
					
					expect(called).toEventually(equal(true))
					expect(value).toEventually(equal("hello"))
					
				}
				
				it("should become dirty when the value is updated") {
					let input = Input(name: "input")
					var result = false
					
					expect(input.isDirty) == false
					
					input.on(value: { input in
						result = input.isDirty
					})
					
					input.setValue("hello")
					
					expect(result).toEventually(equal(true))
					
				}
			}
			
			context("Validate") {
				it("should call the validate event each time the input is validated manually") {
					let input = Input(name: "input")
					
					var count = 0
					
					input.on(validated: { input in
						count = count + 1
					})
					
					input.value = "first"
					input.setValue("hello")
					input.validate()
					
					expect(count) == 1
				}
			}
			
			context("Submit") {
				it("should send a submit event each time the input is submitted") {
					let input = Input(name: "input")
					
					var count = 0
					
					input.on(submitted: { input in
						count = count + 1
					})
					
					input.value = "first"
					input.setValue("hello")
					input.validate()
					input.submit()
					
					expect(count) == 1
					expect(input.isSubmitted) == true
					
				}
			}
			
			context("Enabled") {
				it("should send an enabled event") {
					let input = Input(name: "input")
					
					var count = 0
					var state = true
					
					input.on(enabled: { input in
						count = count + 1
						state = input.enabled
					})
					
					input.enabled = false
					input.setValue("hello")
					
					expect(count) == 1
					expect(state) == false
					
				}
			}
			
			
			context("Hidden") {
				it("should send a hidden event") {
					let input = Input(name: "input")
					
					var count = 0
					var state = true
					
					input.on(hidden: { input in
						count = count + 1
						state = input.hidden
					})
					
					input.hidden = true
					input.setHidden(false)
					
					expect(count) == 2
					expect(state) == false
					
				}
			}
		}
		
		describe("Data") {
			it("should return the data as a dictionary if the input is valid") {
				let input = Input(name: "input")
					.addValidationRule(Validator.required, message: "error")
				
				input.value = "test"
				
				expect(input.isValid) == true
				expect(input.isDirty) == true
				expect(input.isSubmitted) == false
				expect(input.data).toNot(beNil())
				if let data = input.data {
					expect(data[input.name]).toNot(beNil())
					if let value = data[input.name] as? String {
						expect(value) == input.value
						expect(value) == "test"
					}
				}
			}
			
			it("should return nil if the input is invalid") {
				let input = Input(name: "input")
					.addValidationRule(Validator.required, message: "error")
				
				input.value = "test"
				input.setValue("")
				
				expect(input.isValid).toEventually(equal(false))
				expect(input.isDirty).toEventually(equal(true))
				expect(input.isSubmitted).toEventually(equal(false))
				expect(input.data).toEventually(beNil())
				
				
				
			}
		}
	}
}
