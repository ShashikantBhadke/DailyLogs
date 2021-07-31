//
//  FilterController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import UIKit
import RxSwift
import RxCocoa

final class FilterController: UIViewController {
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    let startDate = BehaviorRelay<Date>(value: Date().startOfMonth())
    let endDate = BehaviorRelay<Date>(value: Date().endOfMonth())
    
    var onApplyFilter: ((Int64, Int64) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        self.title = "Apply Filter"
        
        startTextField.inputView = startDatePicker
        endTextField.inputView = endDatePicker
        
        bindView()
    }
    
    private func bindView() {
        startDatePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.startDate.accept(self.startDatePicker.date)
            })
            .disposed(by: disposeBag)
        
        endDatePicker.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.endDate.accept(self.endDatePicker.date)
            })
            .disposed(by: disposeBag)
        
        startDate
            .map {$0.getString() ?? ""}
            .bind(to: startTextField.rx.text)
            .disposed(by: disposeBag)
        
        endDate
            .map {$0.getString() ?? ""}
            .bind(to: endTextField.rx.text)
            .disposed(by: disposeBag)
        
        applyFilterButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.onApplyFilter?(self.startDate.value.removeTimeStamp.timestamp, self.endDate.value.removeTimeStamp.timestamp)
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}
