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
    @IBOutlet weak var startDateTextField   : UITextField!
    @IBOutlet weak var endDateTextField     : UITextField!
    @IBOutlet weak var searchRecordButton   : UIButton!
    @IBOutlet weak var creditedLabel        : UILabel!
    @IBOutlet weak var debitedLabel         : UILabel!
    @IBOutlet weak var balanceLabel         : UILabel!
        
    let startDatePicker = UIDatePicker()
    let endDatePicker = UIDatePicker()
    
    let coreData = CoreData()
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
        fetchRecords()
    }
    
    func setUpView() {
        bindView()
        setUpDates()
        setUpNavigation()
        
        searchRecordButton.setBorder(withColor: .systemIndigo, borderWidth: 1, cornerRadius: 5)
    }
    
    func setUpNavigation() {
        self.title = "Records"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    func setUpDates() {
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        startDatePicker.date = Date().startOfMonth()
        endDatePicker.date = Date().endOfMonth()
        startDateTextField.text = startDatePicker.date.getString() ?? ""
        endDateTextField.text = endDatePicker.date.getString() ?? ""
        
        creditedLabel.textColor = .green
        debitedLabel.textColor = .red
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
                        return $0 + $1.amount
                    }
                let debitedAmount = self.records.value
                    .filter { $0.amountType == .debited }
                    .reduce(0) {
                        return $0 + $1.amount
                    }
                self.setAmount(credited: creditedAmount, debited: debitedAmount)
            })
            .disposed(by: disposeBag)
        
        startDatePicker.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.startDateTextField.text = self.startDatePicker.date.getString() ?? ""
        })
        .disposed(by: disposeBag)
        
        endDatePicker.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.endDateTextField.text = self.endDatePicker.date.getString() ?? ""
        })
        .disposed(by: disposeBag)
        
        searchRecordButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.coreData.fetchRecords(startDate: self.startDatePicker.date as NSDate, endDate: self.endDatePicker.date as NSDate)
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
    
    func fetchRecords() {
        coreData.records.subscribe(onNext: { [weak self] records in
            self?.records.accept(records)
        })
        .disposed(by: disposeBag)
        coreData.error.subscribe(onNext: { errorMessage in
            debugPrint(errorMessage)
        })
        .disposed(by: disposeBag)
        coreData.loading.subscribe(onNext: { isLoading in
            debugPrint(isLoading)
        })
        .disposed(by: disposeBag)
        coreData.fetchRecords(startDate: startDatePicker.date as NSDate, endDate: endDatePicker.date as NSDate)
    }
    
    func deleteRecord(_ indexPathRow: Int) {
        let recordToDelete = self.records.value[indexPathRow]
        var array = self.records.value
        array.remove(at: indexPathRow)
        self.coreData.deleteRecord(recordToDelete)
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
