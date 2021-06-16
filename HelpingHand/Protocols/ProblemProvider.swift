//
//  ProblemProvider.swift
//  HelpingHand
//
//  Created by Viktor Krasilnikov on 28.08.2018.
//  Copyright © 2018 Viktor Krasilnikov. All rights reserved.
//

import Foundation
import UIKit

protocol ProblemProvider {
    
    func provideProblemsDefault() -> Array<Problem>
    func provideProblemsRemote() -> Array<Problem>
}

extension ProblemProvider {
    
    func provideProblemsDefault() -> Array<Problem> {
        
       return Problem.defaultProblems()
    }
    
    func provideProblemsRemote() -> Array<Problem> {
        let problems = Array<Problem>()
        
        return problems
    }
}
