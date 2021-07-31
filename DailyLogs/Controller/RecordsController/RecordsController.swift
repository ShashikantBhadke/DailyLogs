//
//  RecordsController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase
import FirebaseAuth
import RxDataSources

final class RecordsController: UIViewController {
    
    @IBOutlet weak var recordsTableView     : UITableView!
    @IBOutlet weak var createRecordButton   : UIButton!
    
    let disposeBag = DisposeBag()
    var totalBalanceAmount = 0.0
    let records = BehaviorRelay<[RecordModel]>(value: [])
    let section = BehaviorRelay<[TableViewSection]>(value: [])
    
    let dataSource = RxTableViewSectionedReloadDataSource<TableViewSection>(
      configureCell: { _, tableView, indexPath, item in
        if indexPath.section == 0 {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecordHeaderCell.self)) as? RecordHeaderCell,
                let spedingObject = item as? SpendingDetailsModel
            else { return RecordHeaderCell() }
            
            cell.setData(spedingObject)
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecordCell.self)) as? RecordCell,
                let recordObj = item as? RecordModel
            else { return RecordCell() }
            cell.setData(recordObj)
            return cell
        }
    })
    
    var startTimeStamp = Date().startOfMonth().timestamp
    var endTimeStamp = Date().endOfMonth().timestamp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpView() {
        bindView()
        firebaseMethodsForRecords()
        setUpNavigation()
    }
    
    func setUpNavigation() {
        self.title = "Records"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func bindView() {
        dataSource.canEditRowAtIndexPath = { _, indexPath in
            return indexPath.section == 1
        }

        section
            .bind(to: recordsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        recordsTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.deleteRecord(indexPath.row)
            })
            .disposed(by: disposeBag)
        recordsTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self,
                      let records = self.section.value.last?.items as? [RecordModel],
                      records.count > indexPath.row else { return }
                self.pushCreateRecordController(editRecord: records[indexPath.row])
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction private func onCreateNewRecordButtonPressed(_ sender: UIButton) {
        pushCreateRecordController()
    }
    
    @IBAction private func onFilterButtonPressed(_ sender: UIBarButtonItem) {
        pushFilterController()
    }
    @IBAction private func onLogoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            pushLoginController()
        } catch {
            Alert.show("", error.localizedDescription)
        }
        
    }
    
    func pushCreateRecordController(editRecord: RecordModel? = nil) {
        guard let createRecordController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: CreateRecordController.self)) as? CreateRecordController else { return }
        if let record = editRecord {
            createRecordController.recordViewModel.record.accept(record)
        }
        self.navigationController?.pushViewController(createRecordController, animated: true)
    }
    
    private func pushLoginController() {
        guard let loginController = UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: LoginController.self)) as? LoginController else { return }
        self.navigationController?.setViewControllers([loginController], animated: true)
    }
    
    private func pushFilterController() {
        guard let filterController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: FilterController.self)) as? FilterController else { return }
        filterController.startDate.accept(Date(timestamp: startTimeStamp))
        filterController.endDate.accept(Date(timestamp: endTimeStamp))
        filterController.onApplyFilter = { [weak self] (startTime, endTime) in
            guard let self = self else { return }
            self.startTimeStamp = startTime
            self.endTimeStamp = endTime
            let arrRecords = self.records.value
            self.filterRecords(arrRecords)
        }
        self.navigationController?.pushViewController(filterController, animated: true)
    }
    
    func firebaseMethodsForRecords() {
        FirebaseHelper.observeNewAddedRecord()
        FirebaseHelper.observeRecordUpdate()
        FirebaseHelper.observeRemoveRecord()
        FirebaseHelper.newRecord
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords.append(record)
                self.records.accept(arrRecords)
                self.filterRecords(arrRecords)
                self.getOverAllData()
            })
            .disposed(by: disposeBag)
        
        FirebaseHelper.updatedRecord
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords.removeAll {record.id == $0.id}
                arrRecords.append(record)
                self.records.accept(arrRecords)
                self.filterRecords(arrRecords)
                self.getOverAllData()
            })
            .disposed(by: disposeBag)
        
        FirebaseHelper.deletedRecord
            .subscribe(onNext: {[weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords = arrRecords.filter {$0 != record}
                self.records.accept(arrRecords)
                self.filterRecords(self.records.value)
                self.getOverAllData()
            })
            .disposed(by: disposeBag)
    }
    
    func deleteRecord(_ indexPathRow: Int) {
        guard let records = section.value.last?.items as? [RecordModel],
              records.count > indexPathRow else { return }
        let recordToDelete = records[indexPathRow]
        FirebaseHelper.deleteRecord(recordId: recordToDelete.id)
    }
    
    func filterRecords(_ arrRecords: [RecordModel]) {
        var filteredRecords = arrRecords
        filteredRecords = filteredRecords
            .filter {
                $0.timeStamp >= startTimeStamp && $0.timeStamp <= endTimeStamp
            }
            .sorted {$0.timeStamp > $1.timeStamp}
        
        let creditedAmount = filteredRecords
            .filter { $0.amountType == .credited }
            .reduce(0) {
                return $0 + (Double($1.amount) ?? 0)
            }
        let debitedAmount = filteredRecords
            .filter { $0.amountType == .debited }
            .reduce(0) {
                return $0 + (Double($1.amount) ?? 0)
            }
        getOverAllData()
        setNewData(credited: creditedAmount, debited: debitedAmount, arrRecords: filteredRecords)
    }
    
    func setNewData(credited: Double, debited: Double, arrRecords: [RecordModel]) {
        if let arrSpending = section.value.first?.items as? [SpendingDetailsModel], let spending = arrSpending.first {
            var spendingObj = spending
            spendingObj.credited = "\(credited)"
            spendingObj.debited = "\(debited)"
            let balanceAmount = credited - debited
            spendingObj.balance = "\(balanceAmount)"
            spendingObj.balanceColor = balanceAmount >= 0 ? .green : .red
            spendingObj.date = (Date(timestamp: startTimeStamp).getString() ?? "") + " - " + (Date(timestamp: endTimeStamp).getString() ?? "")
            
            let lastTotalAmount = totalBalanceAmount - balanceAmount
            spendingObj.balanceColor = lastTotalAmount >= 0 ? .green : .red
            spendingObj.totalBalance = "\(lastTotalAmount)"
            
            var arrItems = section.value
            arrItems[0].items = [spendingObj]
            arrItems[1].items = arrRecords
            section.accept(arrItems)
        } else {
            var spendingObj = SpendingDetailsModel()
            spendingObj.credited = "\(credited)"
            spendingObj.debited = "\(debited)"
            let balanceAmount = credited - debited
            spendingObj.balance = "\(balanceAmount)"
            spendingObj.balanceColor = balanceAmount >= 0 ? .green : .red
            spendingObj.date = (Date(timestamp: startTimeStamp).getString() ?? "") + " - " + (Date(timestamp: endTimeStamp).getString() ?? "")
            
            let lastTotalAmount = totalBalanceAmount - balanceAmount
            spendingObj.balanceColor = lastTotalAmount >= 0 ? .green : .red
            spendingObj.totalBalance = "\(lastTotalAmount)"
            
            var arrItems = [TableViewSection]()
            arrItems.append(TableViewSection(header: "", items: [spendingObj]))
            arrItems.append(TableViewSection(header: "", items: arrRecords))
            section.accept(arrItems)
        }
    }
    
    func getOverAllData() {
        let creditedAmount = records.value
            .filter { $0.amountType == .credited && $0.timeStamp <= self.endTimeStamp }
            .reduce(0) {
                return $0 + (Double($1.amount) ?? 0)
            }
        let debitedAmount = records.value
            .filter { $0.amountType == .debited  && $0.timeStamp <= self.endTimeStamp}
            .reduce(0) {
                return $0 + (Double($1.amount) ?? 0)
            }
        totalBalanceAmount = creditedAmount - debitedAmount
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
