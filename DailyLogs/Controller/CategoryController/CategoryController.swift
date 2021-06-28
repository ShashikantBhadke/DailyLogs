//
//  CategoryController.swift
//  DailyLogs
//
//  Created by Shashikant Bhadke on 27/06/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryController: UIViewController {
    
    @IBOutlet private weak var categorySearchBar: UISearchBar!
    @IBOutlet private weak var categoryTableView: UITableView!
    
    let disposeBag = DisposeBag()
    var observable: Observable<CategoryModel> {
        return selectedCategory.asObservable()
    }
    let selectedCategory = PublishSubject<CategoryModel>()
    let categorys = BehaviorRelay<[CategoryModel]>(value: [])
    
    override func viewDidLoad() {
        setUpView()
    }
    
    private func setUpView() {
        self.title = "Select Category"
        setUpData()
    }
    
    private func setUpData() {
        FirebaseHelper.categoryListing.subscribe(onNext: { [weak self] array in
            guard let self = self else { return }
            self.removeRepeatedRecord(array)
        })
        .disposed(by: disposeBag)
        FirebaseHelper.observeNewCategory()
    }
    
    func removeRepeatedRecord(_ arrCategory: [CategoryModel]) {
        var arrString = [String]()
        var newArray = [CategoryModel]()
        arrCategory.forEach { category in
            if !arrString.contains(category.name) {
                newArray.append(category)
                arrString.append(category.name)
            }
        }
        newArray = newArray.sorted { $0.name < $1.name }
        categorys.accept(newArray)
        bindView()
    }
    
    private func bindView() {
        categoryTableView.delegate = nil
        categoryTableView.dataSource = nil
        categorySearchBar.rx.text
            .orEmpty
            .throttle(.microseconds(300), latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { [weak self] search in
                (self?.categorys.value ?? []).filter { category in
                    search.isEmpty || category.name.hasPrefix(search)
                }
            }
            .bind(to: categoryTableView.rx.items(cellIdentifier: String(describing: CategoryCell.self), cellType: CategoryCell.self)) { (_, model, cell) in
                cell.categoryLabel.text = model.name
            }
            .disposed(by: disposeBag)
        
        categoryTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.selectedCategory.onNext(self.categorys.value[index.row])
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
