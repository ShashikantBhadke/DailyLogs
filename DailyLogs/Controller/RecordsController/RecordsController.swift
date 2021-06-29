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

final class RecordsController: UIViewController {
    
    @IBOutlet weak var recordsTableView     : UITableView!
    @IBOutlet weak var createRecordButton   : UIButton!
    @IBOutlet weak var creditedLabel        : UILabel!
    @IBOutlet weak var debitedLabel         : UILabel!
    @IBOutlet weak var balanceLabel         : UILabel!
    @IBOutlet weak var dateLabel            : UILabel!
    
    let disposeBag = DisposeBag()
    let records = BehaviorRelay<[RecordModel]>(value: [])
    let filteredRecords = BehaviorRelay<[RecordModel]>(value: [])
    
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
    
    func setUpDate() {
        dateLabel.text = (Date(timestamp: startTimeStamp).getString() ?? "") + " - " + (Date(timestamp: endTimeStamp).getString() ?? "")
    }
    
    func setUpNavigation() {
        self.title = "Records"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func bindView() {
        filteredRecords.asObservable()
            .bind(to: recordsTableView.rx.items(cellIdentifier: String(describing: RecordCell.self), cellType: RecordCell.self)) { _, model, cell in
                cell.setData(model)
            }
            .disposed(by: disposeBag)
        
        filteredRecords.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let creditedAmount = self.filteredRecords.value
                    .filter { $0.amountType == .credited }
                    .reduce(0) {
                        return $0 + (Double($1.amount) ?? 0)
                    }
                let debitedAmount = self.filteredRecords.value
                    .filter { $0.amountType == .debited }
                    .reduce(0) {
                        return $0 + (Double($1.amount) ?? 0)
                    }
                self.setAmount(credited: creditedAmount, debited: debitedAmount)
            })
            .disposed(by: disposeBag)
        
        recordsTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.deleteRecord(indexPath.row)
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
    
    func pushCreateRecordController() {
        guard let createRecordController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: CreateRecordController.self)) as? CreateRecordController else { return }
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
        FirebaseHelper.observeRemoveRecord()
        FirebaseHelper.newRecord
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords.append(record)
                self.records.accept(arrRecords)
                self.filterRecords(arrRecords)
            })
            .disposed(by: disposeBag)
        
        FirebaseHelper.deletedRecord
            .subscribe(onNext: {[weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords = arrRecords.filter {$0 != record}
                self.records.accept(arrRecords)
                self.filterRecords(self.records.value)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteRecord(_ indexPathRow: Int) {
        let recordToDelete = self.filteredRecords.value[indexPathRow]
        FirebaseHelper.deleteRecord(id: recordToDelete.id)
    }
    
    func setAmount(credited: Double, debited: Double) {
        creditedLabel.text = "\(credited)"
        debitedLabel.text = "\(debited)"
        let balanceAmount = credited - debited
        balanceLabel.text = "\(balanceAmount)"
        balanceLabel.textColor = balanceAmount >= 0 ? .green : .red
    }
    
    func filterRecords(_ arrRecords: [RecordModel]) {
        var filteredRecords = arrRecords
        filteredRecords = filteredRecords
            .filter {
                $0.timeStamp >= startTimeStamp && $0.timeStamp <= endTimeStamp
            }
            .sorted {$0.timeStamp > $1.timeStamp}
        
        self.filteredRecords.accept(filteredRecords)
        self.setUpDate()
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
