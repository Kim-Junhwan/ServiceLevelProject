//
//  ViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/05.
//

import Foundation
import SwiftUI

protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Input
    
    var state: State { get }
    func trigger(_ input: Input)
}
