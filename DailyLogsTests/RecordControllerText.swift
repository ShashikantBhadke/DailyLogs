//
//  RecordControllerText.swift
//  DailyLogsTests
//
//  Created by Shashikant Bhadke on 02/07/21.
//

import XCTest
@testable import DailyLogs

class RecordControllerText: XCTestCase {

    var recordController: RecordController!
    
    override func setUpWithError() throws {
        loadRecordController()
    }

    private func loadRecordController() {
        recordController = UIStoryboard.main.instantiateViewController(identifier: String(describing: LoginController.self)) as? LoginController
        recordController?.loadView()
    }
    
    func test_IBOutlets() {
        do {
            
            _ = try XCTUnwrap(recordController?.recordsTableView, "Record Tableview is not connected")
            _ = try XCTUnwrap(recordController?.createRecordButton, "Create record button is not connected.")
                        
        } catch {}
    }
    
    override func tearDownWithError() throws {
    }

}
