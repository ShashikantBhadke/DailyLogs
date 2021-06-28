//
//  CreateRecordCell.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateRecordCell: UITableViewCell {
    
    @IBOutlet weak var amountTypeSegmentControl : UISegmentedControl!
    @IBOutlet weak var amountTextField          : UITextField!
    @IBOutlet weak var titleTextField           : UITextField!
    @IBOutlet weak var detailTextView           : UITextView!
    @IBOutlet weak var dateTextField            : UITextField!
    @IBOutlet weak var categoryTextField        : UITextField!
    
    let categorySubject = PublishSubject<Void>()
    var categoryObserver: Observable<Void> {
        return categorySubject.asObservable()
    }
    
    var disposeBag = DisposeBag()
    let datePicker = UIDatePicker()
    let recordObject = BehaviorRelay<RecordModel>(value: RecordModel.getDummy())
    
    override func awakeFromNib() {
        setUpView()
        bindView()
        bindableFields()
    }
    
    func setDisposeBag() {
        disposeBag = DisposeBag()
        setUpView()
        bindView()
        bindableFields()
    }
    
    private func setUpView() {
        detailTextView.setBorder(withColor: .border, borderWidth: 1, cornerRadius: 10)
        dateTextField.inputView = datePicker
        categoryTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                self?.categorySubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        datePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                var record = self.recordObject.value
                record.timeStamp = self.datePicker.date.timestamp
                self.recordObject.accept(record)
            })
            .disposed(by: disposeBag)
        
        recordObject.subscribe(onNext: { [weak self] record in
            guard let self = self else { return }
            self.setUpData(record)
        })
        .disposed(by: disposeBag)
        
        amountTextField.rx.text
            .map {
                if !($0 ?? "").isEmpty, !($0 ?? "").isDouble {
                    return String(($0 ?? "").dropLast())
                } else {
                    return $0 ?? ""
                }
            }.bind(to: amountTextField.rx.text)
            .disposed(by: disposeBag)
        
        amountTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] _ in
            guard let self = self, !(self.amountTextField.text ?? "").isEmpty else { return }
            self.amountTextField.text = String(format: "%.2f", (Double(self.amountTextField.text ?? "") ?? 0))
        }).disposed(by: disposeBag)
    }
    
    private func bindableFields() {
        let obser1 = amountTypeSegmentControl.rx.selectedSegmentIndex.map {AmountType(rawValue: $0)}
        let obser2 = amountTextField.rx.text.map {Double($0 ?? "0.0") ?? 0}
        let obser3 = titleTextField.rx.text.orEmpty
        let obser4 = detailTextView.rx.text.orEmpty
        let obser5 = dateTextField.rx.text.orEmpty.map {$0.getDate()}
        let obser6 = categoryTextField.rx.text.orEmpty
        
        let observableCombine =  Observable.combineLatest(obser1, obser2, obser3, obser4, obser5, obser6) { (amountType, amount, title, detail, date, category) -> RecordModel in
            
            let recordObj = RecordModel(amountType: amountType ?? .credited, amount: amount, title: title, timeStamp: date?.timestamp ?? 0, detail: detail, category: category)
            return recordObj
        }
        
        observableCombine.subscribe(onNext: { [weak self] record in
            guard let self = self else { return }
            self.recordObject.accept(record)
        })
        .disposed(by: disposeBag)
    }

    private func setUpData(_ recordObj: RecordModel) {
        amountTextField.text = "\(recordObj.amount)"
        titleTextField.text = recordObj.title
        detailTextView.text = recordObj.detail
        dateTextField.text = Date(timestamp: recordObj.timeStamp).getString()
        categoryTextField.text = recordObj.category
    }
    
}
