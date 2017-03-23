//
//  UserProfilePresenterTests.swift
//  UserProfile
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//
import XCTest
@testable import UserProfile

class UserProfilePresenterTests: XCTestCase {
    
    private var profilePresenter: UserProfilePresenter?
    private var userCredentials: UserCredentials?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        userCredentials = UserCredentials(email: "user1@gmail.com", password: "test")
        profilePresenter = UserProfilePresenter(service: MockUserProfileService(),
                                                    userCredentials: userCredentials)
        XCTAssertNotNil(profilePresenter)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        profilePresenter = nil
        userCredentials = nil
    }
    
    func testFetchUserProfile() {
        
        let promiseToCallBack = expectation(description: "calls back")
        profilePresenter?.fetchUserProfile { (result) in
            
            switch result {
            case .Success(let userProfileViewModel):
                XCTAssertNotNil(userProfileViewModel)
                XCTAssertTrue(userProfileViewModel.email == self.userCredentials?.email)
                XCTAssertTrue(userProfileViewModel.password == self.userCredentials?.password)
                XCTAssertNotNil(userProfileViewModel.profilePhoto)
            case .Failure(_):
                XCTFail("The result should be success")
                
            }
            promiseToCallBack.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in
            print("timed out: \(error)")
        }
    }
    
    func testProfilePhoto() {
        
        let promiseToCallBack = expectation(description: "calls back")
        let bundle = Bundle(for: type(of: self))
        let photo = UIImage(named: "profile", in: bundle, compatibleWith: nil)
        profilePresenter?.uploadProfilePhoto(photo: photo!, uploadProfilePhotoCompletionHandler: { (result) in
            
            switch result {
            case .Success(_): break
            case .Failure(_):
                XCTFail("The result should be success")
            }
            promiseToCallBack.fulfill()
        })
        
        waitForExpectations(timeout: 5) { error in
            print("timed out: \(error)")
        }
    }
}

