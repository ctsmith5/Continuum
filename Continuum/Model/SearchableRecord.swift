//
//  SearchableRecord.swift
//  Continuum
//
//  Created by Colin Smith on 4/10/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
