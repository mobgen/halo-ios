//
//  Grammar.swift
//  HaloSDK
//
//  Created by Borja Santos-Díez on 30/03/16.
//  Copyright © 2016 MOBGEN Technology. All rights reserved.
//

import Foundation

enum GrammarToken {
    case ParensOpen
    case ParensClose
    case StringOpen
    case StringClose
    case Number(Float)
    case Identifier(String)
}