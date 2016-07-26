//
//  Color.swift
//  JSONQuery
//
//  Created by Ryan Cortez on 7/25/16.
//  Copyright © 2016 Ryan Cortez. All rights reserved.
//

import UIKit

class Color: NSObject {
    var title: String
    var thumbnailURL: String
    
    init(title: String, thumbnailURL: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
}
