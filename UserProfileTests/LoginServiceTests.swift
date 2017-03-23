//
//  LoginServiceTests.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 23/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import XCTest
@testable import UserProfile

class LoginServiceTests: XCTestCase {
    
    private var loginService: LoginService?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginService = LoginService(networkManager: MockNetworkManager())
        XCTAssertNotNil(loginService)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        loginService = nil
    }
    
    func testManualLogin() {
        
        let promiseToCallBack = expectation(description: "calls back")
        let email =  "user1@gmail.com"
        let password = "test"
        
        loginService?.login(withEmail: email, password: password, completionHandler: { (result) in
            switch result {
            case .Success(let session):
                XCTAssertNotNil(session)
                XCTAssertTrue(session.userid == 2)
                XCTAssertTrue(session.token == "[B@65b43f74")
            case .Failure(_):
                XCTFail("The result should be success")
                
            }
            promiseToCallBack.fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            print("timed out: \(error)")
        }
    }
    
    func testAutoLogin() {
        
        let promiseToCallBack = expectation(description: "calls back")
        let email =  "user1@gmail.com"
        let password = "test"
        
        loginService?.login(withEmail: email, password: password, completionHandler: { (result) in
            switch result {
            case .Success(let session):
                XCTAssertNotNil(session)
                XCTAssertTrue(self.loginService?.canAutoLogin == true)
                XCTAssertTrue(self.loginService?.userCredentials?.email == email)
                XCTAssertTrue(self.loginService?.userCredentials?.password == password)

            case .Failure(_):
                XCTFail("The result should be success")
                
            }
            promiseToCallBack.fulfill()
        })
        
        waitForExpectations(timeout: 2) { error in
            print("timed out: \(error)")
        }
    }
}
