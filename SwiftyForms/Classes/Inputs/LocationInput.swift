//
//  LocationInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 29/06/16.
//
//

import Foundation

public typealias LocationInputEvent = (LocationInput) -> Void

open class LocationInput: Input {
	
	
	open static let Latitude = "latitude"
	open static let Longitude = "longitude"
	
	fileprivate var _previousLatitude: String? = nil
	fileprivate var _previousLongitude: String? = nil
	fileprivate var _locationEvents: [LocationInputEvent] = []
	
	override open var data: [String : Any]? {
		if isValid == false {
			return nil
		}
		
		return [
			attributeLatitude :  latitude,
			attributeLongitude : longitude
		]
	}
	
	override open var isValid: Bool {
		return _validate()
	}
	
	open var latitude: String {
		willSet {
			_previousLatitude = self.latitude
		}
		
		didSet {
			self._dirty = true
			
			for event in _locationEvents {
				event(self)
			}
		}
	}
	
	open var longitude: String {
		willSet {
			_previousLongitude = self.longitude
		}
		
		didSet {
			self._dirty = true
			
			for event in _locationEvents {
				event(self)
			}
		}
	}
	
	open var previousLatitude: String? {
		return _previousLatitude
	}
	
	open var previousLongitude: String? {
		return _previousLongitude
	}
	
	open var attributeLatitude: String = LocationInput.Latitude
	open var attributeLongitude: String = LocationInput.Longitude
	
	public convenience init(name: String) {
		self.init(name: name, enabled: true, hidden: false)
	}
	
	public override init(name: String, enabled: Bool, hidden: Bool) {
		self.latitude = "0.0"
		self.longitude = "0.0"
		
		super.init(name: name, enabled: enabled, hidden: hidden)
	}
	
	open func on(_ location: LocationInputEvent? = nil) {
		if let event = location {
			_locationEvents.append(event)
		}
	}
	
	open func setAttributeLatitude(_ name: String) -> LocationInput {
		attributeLatitude = name
		return self
	}
	
	open func setAttributeLongitude(_ name: String) -> LocationInput {
		attributeLongitude = name
		return self
	}
	
	fileprivate func _validate() -> Bool {
		let latitudeValidation = self._validationRules
			.map() { $0.rule }
			.map() { $0(latitude) }
			.reduce(true) { $0 && $1 }
		
		let longitudeValidation = self._validationRules
			.map() { $0.rule }
			.map() { $0(latitude) }
			.reduce(true) { $0 && $1 }
		
		return latitudeValidation && longitudeValidation
	}
}
