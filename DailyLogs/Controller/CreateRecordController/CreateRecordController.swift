//
//  CreateRecordController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 24/06/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CreateRecordController: UIViewController {
    
    @IBOutlet weak var recordsTableView             : UITableView!
    @IBOutlet weak var saveRecordButton             : UIButton!
    @IBOutlet weak var backgroundSaveButtoneView    : UIView!
    
    let disposeBag = DisposeBag()
    var recordViewModel = CreateRecordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUpView() {
        bindView()
        setUpNavigation()
        recordsTableView.dataSource = self
    }
    
    private func setUpNavigation() {
        self.title = "Create/Update Record"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.sizeToFit()
    }
    
    private func bindView() {
        recordViewModel.isValid()
            .bind(to: saveRecordButton.rx.isEnabled)
            .disposed(by: disposeBag)
        recordViewModel.isValid().map {$0 ? 1 : 0.2}
            .bind(to: backgroundSaveButtoneView.rx.alpha)
            .disposed(by: disposeBag)
        
        saveRecordButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self]_ in
                guard let self = self else { return }
                self.saveRecordModel()
            }).disposed(by: disposeBag)
    }
    
    func saveRecordModel() {
        let recordDict = recordViewModel.record.value.getDictionary()
        FirebaseHelper.saveRecord(recordDict)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        debugPrint("Receive Memory Warning For", #file)
    }
    
    deinit {
        debugPrint("File Deinit", #file)
    }
    
}

extension CreateRecordController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CreateRecordCell.self), for: indexPath) as? CreateRecordCell else { return CreateRecordCell() }
        
        cell.bindableView()
            .bind(to: recordViewModel.record)
            .disposed(by: disposeBag)
        
        return cell
    }
}
