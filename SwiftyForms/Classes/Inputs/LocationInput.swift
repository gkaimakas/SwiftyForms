//
//  LocationInput.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 29/06/16.
//
//

import Foundation

public typealias LocationInputEvent = (LocationInput) -> Void

public class LocationInput: Input {
	
	
	public static let Latitude = "latitude"
	public static let Longitude = "longitude"
	
	private var _previousLatitude: String? = nil
	private var _previousLongitude: String? = nil
	private var _locationEvents: [LocationInputEvent] = []
	
	override public var data: [String : Any]? {
		if isValid == false {
			return nil
		}
		
		return [
			attributeLatitude :  latitude,
			attributeLongitude : longitude
		]
	}
	
	override public var isValid: Bool {
		return _validate()
	}
	
	public var latitude: String {
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
	
	public var longitude: String {
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
	
	public var previousLatitude: String? {
		return _previousLatitude
	}
	
	public var previousLongitude: String? {
		return _previousLongitude
	}
	
	public var attributeLatitude: String = LocationInput.Latitude
	public var attributeLongitude: String = LocationInput.Longitude
	
	public convenience init(name: String) {
		self.init(name: name, enabled: true, hidden: false)
	}
	
	public override init(name: String, enabled: Bool, hidden: Bool) {
		self.latitude = "0.0"
		self.longitude = "0.0"
		
		super.init(name: name, enabled: enabled, hidden: hidden)
	}
	
	public func on(location: LocationInputEvent? = nil) {
		if let event = location {
			_locationEvents.append(event)
		}
	}
	
	public func setAttributeLatitude(name: String) -> LocationInput {
		attributeLatitude = name
		return self
	}
	
	public func setAttributeLongitude(name: String) -> LocationInput {
		attributeLongitude = name
		return self
	}
	
	private func _validate() -> Bool {
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