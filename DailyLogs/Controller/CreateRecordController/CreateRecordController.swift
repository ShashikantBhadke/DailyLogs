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
                self.view.endEditing(true)
                self.saveRecordModel()
            }).disposed(by: disposeBag)
        
//        recordViewModel.record
//            .map {[$0]}
//            .bind(to: recordsTableView.rx.items(cellIdentifier: String(describing: CreateRecordCell.self), cellType: CreateRecordCell.self)) { [weak self] (_, record, cell) in
//                guard let self = self else { return }
//                cell.recordObject.bind(to: self.recordViewModel.record)
//                    .disposed(by: self.disposeBag)
//                self.recordViewModel.record.bind(to: cell.recordObject)
//                    .disposed(by: cell.disposeBag)
//                cell.categoryObserver?
//                    .subscribe(onNext: { [weak self] _ in
//                        guard let self = self else { return }
//                        print("cell.categoryObserver.subscribe")
//                        self.pushCategoryController()
//                    }, onDisposed: {
//                        print("---disposed---")
//                    })
//                    .disposed(by: self.disposeBag)
//            }
//            .disposed(by: disposeBag)
    }
    
    func saveRecordModel() {
        let recordDict = recordViewModel.record.value.getDictionary()
        FirebaseHelper.saveRecord(recordDict)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushCategoryController() {
        guard let categoryController = UIStoryboard.records.instantiateViewController(withIdentifier: String(describing: CategoryController.self)) as? CategoryController else { return }
        categoryController.observable
            .subscribe(onNext: { [weak self] category in
                guard let self = self else { return }
                var record = self.recordViewModel.record.value
                record.category = category.name
                self.recordViewModel.record.accept(record)
                self.recordsTableView.reloadData()
            }, onDisposed: {
                debugPrint("dispose- pushCategoryController")
            })
            .disposed(by: categoryController.disposeBag)
        self.navigationController?.pushViewController(categoryController, animated: true)
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
        cell.setDisposeBag()
        cell.recordObject.accept(recordViewModel.record.value)
        cell.recordObject
            .bind(to: recordViewModel.record)
            .disposed(by: cell.disposeBag)
        cell.categoryObserver
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushCategoryController()
            })
            .disposed(by: cell.disposeBag)
        return cell
    }
}
