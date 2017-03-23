//
//  UserProfileTests.swift
//  UserProfileTests
//
//  Created by Appaji Tholeti on 22/03/2017.
//  Copyright © 2017 Tholeti Consultancy Ltd. All rights reserved.
//

import XCTest

@testable import UserProfile

class UserProfileModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSessionModel() {
        let userid = 2
        let token = "[B@65b43f74"
        let json = ["userid": userid, "token": token] as [String : Any]
        let session = Session(JSON: json)
        XCTAssertNotNil(session)
        XCTAssertTrue(session?.userid == userid)
        XCTAssertTrue(session?.token == token)
    }
    
    func testUserProfleModel() {
        let email = "user@gmail.com"
        let avatar = "base64_encoded_data"
        let json = ["email": email, "avatar": avatar] as [String : Any]
        let profle = UserProfile(JSON: json)
        XCTAssertNotNil(profle)
        XCTAssertTrue(profle?.email == email)
        XCTAssertTrue(profle?.avatar == avatar)
    }
    
    func testAvatarModel() {
        let avatar = "base64_encoded_data"
        let json = ["avatar": avatar] as [String : Any]
        let avatarModel = Avatar(JSON: json)
        XCTAssertNotNil(avatarModel)
        XCTAssertTrue(avatarModel?.avatar == avatar)
    }
    
}
