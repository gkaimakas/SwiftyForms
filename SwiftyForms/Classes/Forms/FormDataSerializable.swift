//
//  FormDataSerializable.swift
//  Pods
//
//  Created by Γιώργος Καϊμακάς on 14/06/16.
//
//

import Foundation

public protocol FormDataSerializable {
	init? (data: [String: Any]?)
}
