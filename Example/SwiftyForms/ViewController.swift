//
//  ViewController.swift
//  SwiftyForms
//
//  Created by gkaimakas on 05/24/2016.
//  Copyright (c) 2016 gkaimakas. All rights reserved.
//

import UIKit
import SwiftValidators
import SwiftyForms

class ViewController: UIViewController {

	var input: Input? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		input = Input(name: "TestInput")
			.withValidationRule(Validator.isTrue, message: "err_is_true")
			.on(value: { input in
				print("state \(input.isValid) \(input.value)" )
			})
			.on(validate: { input in
				print("validated: \(input.isValid)")
			})
			.on(hint: { hint in
				print("\(hint)")
			})
		
		input?.value = "hello"
		input?.value = "there"
		
		input?
			.update(hint: {"hello"})
			.update(value: {"gkaimakas"})
			.update(value: {"true"})
			.validate()
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		
    }

}

