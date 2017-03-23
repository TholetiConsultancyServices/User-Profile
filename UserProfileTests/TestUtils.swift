//
//  File+Extensions.swift
//  Weather
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import UIKit

class TestUtils {
    
    func loadJSONData(fromFileName: String) -> [String: Any]? {
        
        let testBundle = Bundle(for: type(of: self))
        guard let filePath = testBundle.path(forResource: fromFileName, ofType: "json") else {
            return nil
        }
        
        guard let data = NSData(contentsOfFile: filePath),
              let JSON = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: Any] else{
            return nil
        }
        
        return JSON
        
    }
}
