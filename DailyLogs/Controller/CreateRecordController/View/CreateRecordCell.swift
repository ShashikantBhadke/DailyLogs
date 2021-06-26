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
    @IBOutlet weak var personTextField          : UITextField!
    
    let dateObject = PublishSubject<Date>()
    let disposeBag = DisposeBag()
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        setUpView()
    }
    
    private func setUpView() {
        bindView()
        detailTextView.setBorder(withColor: .border, borderWidth: 1, cornerRadius: 10)
        dateObject.onNext(Date())
        dateTextField.inputView = datePicker
        datePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dateObject.onNext(self.datePicker.date)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        dateObject.subscribe(onNext: { [weak self] date in
            guard let self = self else { return }
            self.dateTextField.text = date.getString() ?? ""
        }).disposed(by: disposeBag)
        
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
    
    func bindableView() -> Observable<RecordModel> {
        let obser1 = amountTypeSegmentControl.rx.selectedSegmentIndex.map {AmountType(rawValue: $0)}
        let obser2 = amountTextField.rx.text.map {Double($0 ?? "0.0") ?? 0}
        let obser3 = titleTextField.rx.text.orEmpty
        let obser4 = detailTextView.rx.text.orEmpty
        let obser5 = dateTextField.rx.text.orEmpty.map {$0.getDate()}
        let obser6 = personTextField.rx.text.orEmpty
        
        let observableCombine =  Observable.combineLatest(obser1, obser2, obser3, obser4, obser5, obser6) { (amountType, amount, title, detail, date, person) -> RecordModel in
            
            let recordObj = RecordModel(amountType: amountType ?? .credited, amount: amount, title: title, date: date ?? Date(), detail: detail, person: person)
            return recordObj
        }
        return observableCombine
        
    }
}
