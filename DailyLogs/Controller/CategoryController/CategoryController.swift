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
    
    @IBOutlet private weak var categoryTableView    : UITableView!
    @IBOutlet private weak var newCategoryTextField : UITextField!
    @IBOutlet private weak var addNewCategoryButton : UIButton!
    
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
        bindView()
        setUpData()
    }
    
    private func setUpData() {
        FirebaseHelper.category.subscribe(onNext: { [weak self] category in
            guard let self = self else { return }
            var newArray = self.categorys.value
            newArray.append(category)
            self.categorys.accept(newArray)
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
        
    }
    
    private func bindView() {
        categorys
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
        
        addNewCategoryButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self,
                  let newCategory = self.newCategoryTextField.text,
                  !newCategory.isEmpty else { return }
            self.newCategoryTextField.text = ""
            self.newCategoryTextField.resignFirstResponder()
            FirebaseHelper.saveOrUpdateCategory(CategoryModel(name: newCategory).getDictionary())
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
