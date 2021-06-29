//
//  RecordsController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

final class RecordsController: UIViewController {
    
    @IBOutlet weak var recordsTableView     : UITableView!
    @IBOutlet weak var createRecordButton   : UIButton!
    @IBOutlet weak var creditedLabel        : UILabel!
    @IBOutlet weak var debitedLabel         : UILabel!
    @IBOutlet weak var balanceLabel         : UILabel!
        
    let disposeBag = DisposeBag()
    let userObject = PublishSubject<NSManagedObject>()
    let records = BehaviorRelay<[RecordModel]>(value: [])
    
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
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    func bindView() {
        records.asObservable()
            .bind(to: recordsTableView.rx.items(cellIdentifier: String(describing: RecordCell.self), cellType: RecordCell.self)) { _, model, cell in
                cell.setData(model)
            }
            .disposed(by: disposeBag)
        
        records.asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let creditedAmount = self.records.value
                    .filter { $0.amountType == .credited }
                    .reduce(0) {
                        return $0 + (Double($1.amount) ?? 0)
                    }
                let debitedAmount = self.records.value
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
    
    func pushCreateRecordController() {
        guard let createRecordController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: CreateRecordController.self)) as? CreateRecordController else { return }
        self.navigationController?.pushViewController(createRecordController, animated: true)
    }
    
    func firebaseMethodsForRecords() {
        FirebaseHelper.observeNewAddedRecord()
        FirebaseHelper.observeRemoveRecord()
        FirebaseHelper.newRecord
            .subscribe(onNext: { [weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords.append(record)
                arrRecords = arrRecords.sorted {$0.timeStamp > $1.timeStamp}
                self.records.accept(arrRecords)
            })
            .disposed(by: disposeBag)
        
        FirebaseHelper.deletedRecord
            .subscribe(onNext: {[weak self] record in
                guard let self = self else { return }
                var arrRecords = self.records.value
                arrRecords = arrRecords.filter {$0 != record}
                self.records.accept(arrRecords)
            })
            .disposed(by: disposeBag)
    }
    
    func deleteRecord(_ indexPathRow: Int) {
        let recordToDelete = self.records.value[indexPathRow]
        var array = self.records.value
        array.remove(at: indexPathRow)
        FirebaseHelper.deleteRecord(id: recordToDelete.id)
        self.records.accept(array)
    }
    
    func setAmount(credited: Double, debited: Double) {
        creditedLabel.text = "\(credited)"
        debitedLabel.text = "\(debited)"
        let balanceAmount = credited - debited
        balanceLabel.text = "\(balanceAmount)"
        balanceLabel.textColor = balanceAmount >= 0 ? .green : .red
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
