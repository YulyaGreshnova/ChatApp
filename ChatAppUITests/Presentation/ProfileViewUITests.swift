//
//  ProfileViewUITests.swift
//  ProfileViewUITests
//
//  Created by Yulya Greshnova on 17.05.2022.
//

import XCTest

class ProfileViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    // Тестирование наличия элементов на окне профиля пользователя сделала двумя способами - в одном тесте проверила наличие всех элементов, разбила проверку каждого элемента на отдельные тесты (данный вариант закомментировала).
    // Предпочтение отдаю проверки в рамках одного теста, так как она осущетсвляется значительно быстрее.
    
    func testProfileViewHasRequiredElements() {
        let expectedTextFieldCount = 2
        
        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        
        let profileView = app.otherElements["ProfileView"]
        guard profileView.waitForExistence(timeout: 3.0) else {
            XCTFail("Profile view не откралось в течение трех секунд")
            return
        }
        
        let avatarView = app.otherElements["AvatarView"]
        let isAvatarImagesExist = avatarView.images["AvatarImageView"].exists
        
        let headerView = app.otherElements["HeaderView"]
        let isHeaderViewExist = headerView.exists
        
        let isEditButtonExist = profileView.scrollViews.otherElements.buttons["Edit"].exists
        
        profileView.scrollViews.otherElements.buttons["Edit"].tap()
        let textFieldCount = profileView.textFields.count + profileView.textViews.count
        let isEditAvatarButtonExist = profileView.buttons["EditAvatarButton"].exists
        let isSaveButtonExist = profileView.buttons["Save GCD"].exists
        
        XCTAssertTrue(isAvatarImagesExist)
        XCTAssertEqual(textFieldCount, expectedTextFieldCount)
        XCTAssertTrue(isHeaderViewExist)
        XCTAssertTrue(isEditButtonExist)
        XCTAssertTrue(isEditAvatarButtonExist)
        XCTAssertTrue(isSaveButtonExist)
    }
    
//    func testProfileViewHasAvatarImageView() {
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//        let avatarView = app.otherElements["AvatarView"]
//        let isAvatarImagesExist = avatarView.images["AvatarImageView"].exists
//
//        XCTAssertTrue(isAvatarImagesExist)
//    }
    
//    func testProfileHasTwoTextField() {
//        let expectedTextFieldCount = 2
//
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//        let profileView = app.otherElements["ProfileView"]
//
//        profileView.scrollViews.otherElements.buttons["Edit"].tap()
//
//
//
//        let textFieldCount = profileView.textFields.count + profileView.textViews.count
//
//        XCTAssertEqual(textFieldCount, expectedTextFieldCount)
//    }
    
//    func testProfileViewHasHeaderView() {
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//        let headerView = app.otherElements["HeaderView"]
//
//        XCTAssertTrue(headerView.exists)
//    }
   
//    func testProfileViewHasEditButton() {
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//
//        let profileView = app.otherElements["ProfileView"]
//        let isEditButtonExist = profileView.scrollViews.otherElements.buttons["Edit"].exists
//        XCTAssertTrue(isEditButtonExist)
//    }
    
//    func testProfileViewHasEditAvatarButton() {
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//
//        let profileView = app.otherElements["ProfileView"]
//        profileView.scrollViews.otherElements.buttons["Edit"].tap()
//
//        let isEditAvatarButtonExist = profileView.buttons["EditAvatarButton"].exists
//
//        XCTAssertTrue(isEditAvatarButtonExist)
//    }
    
//    func testProfileViewHasSaveButton() {
//        app.navigationBars["Channels"]/*@START_MENU_TOKEN@*/.otherElements["avatarViewBarButtonItem"]/*[[".otherElements[\"avatarViewBarButtonItem\"]",".otherElements[\"AvatarView\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
//
//        let profileView = app.otherElements["ProfileView"]
//        profileView.scrollViews.otherElements.buttons["Edit"].tap()
//
//        let isSaveButtonExist = profileView.buttons["Save GCD"].exists
//
//        XCTAssertTrue(isSaveButtonExist)
//    }
}
