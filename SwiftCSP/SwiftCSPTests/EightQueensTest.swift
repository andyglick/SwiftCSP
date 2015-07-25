//
//  SwiftCSPTests.swift
//  SwiftCSPTests
//
//  Created by David Kopec on 7/22/15.
//  Copyright (c) 2015 Oak Snow Consulting. All rights reserved.
//

import Cocoa
import XCTest

class EightQueensConstraint<V, D>: ListConstraint <Int, Int> {
    
    override init(variables: [Int]) {
        super.init(variables: variables)
    }
    
    override func isSatisfied(assignment: Dictionary<Int, Int>) -> Bool {
        // not the most efficient check for attacking each other...
        // better to subtract one from the other and go from there
        for q in assignment.values {
            for (var i = q - 1; q % 8 > i % 8; i--) { //same file backwards
                if find(assignment.values, i) != nil {
                    return false
                }
            }
            for (var i = q + 1; q % 8 < i % 8; i++) { //same file forwards
                if find(assignment.values, i) != nil {
                    return false
                }
            }
            for (var i = q - 9; i >= 0 && q % 8 > i % 8; i -= 9) { // diagonal up and back
                if find(assignment.values, i) != nil {
                    return false
                }
            }
            for (var i = q - 7; i >= 0 && q % 8 < i % 8; i -= 7) { // diagonal up and forward
                if find(assignment.values, i) != nil {
                    return false
                }
            }
            for (var i = q + 7; i < 64 && i % 8 < q % 8; i += 7) { // diagonal down and back
                if find(assignment.values, i) != nil {
                    return false
                }
            }
            for (var i = q + 9; i < 64 && q % 8 < i % 8; i += 9) { // diagonal down and forward
                if find(assignment.values, i) != nil {
                    return false
                }
            }
        }
        
        // until we have all of the variables assigned, the assignment is valid
        return true
    }
}

func drawQueens(solution: Dictionary<Int, Int>) {
    var output = "\n"
    for (var i = 0; i < 64; i++) {
        if (find(solution.values, i) != nil) {
            output += "Q"
        } else {
            output += "X"
        }
        if (i % 8 == 7) {
            output += "\n"
        }
    }
    print(output);
}

class EightQueensTest: XCTestCase {
    var csp: CSP<Int, Int>?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let variables: [Int] = [0, 1, 2, 3, 4, 5, 6, 7]
        var domains = Dictionary<Int, [Int]>()
        for variable in variables {
            domains[variable] = []
            for (var i = variable; i < 64; i += 8) {
                domains[variable]?.append(i)
            }
        }
        
        csp = CSP<Int, Int>(variables: variables, domains: domains)
        let smmc = EightQueensConstraint<Int, Int>(variables: variables)
        csp?.addConstraint(smmc)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSolution() {
        // This is an example of a functional test case.
        if let cs: CSP<Int, Int> = csp {
            if let solution = backtrackingSearch(cs, mrv: true) {
                print(solution)
                drawQueens(solution)
                XCTAssertEqual(solution, [2: 58, 4: 20, 5: 53, 6: 14, 7: 31, 0: 0, 1: 33, 3: 43], "Pass")
            } else {
                XCTFail("Fail")
            }
        } else {
            XCTFail("Fail")
        }
    }    
}
