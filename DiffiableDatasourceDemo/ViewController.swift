//
//  ViewController.swift
//  DiffiableDatasourceDemo
//
//  Created by HappyDuck on 2023/08/06.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    private var sections = SecondSection.allSections
    typealias DataSource = UITableViewDiffableDataSource<SecondSection, SectionItem>
    private lazy var dataSource = self.makeDataSource()
    
    typealias Snapshot = NSDiffableDataSourceSnapshot<SecondSection, SectionItem>
    
    var generatedNumberSet = Set<Int>()
    
    //MARK: - UI Elements
    private let table: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.table)
        table.frame = self.view.bounds
        self.applySnapshot(animatingDifferences: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(didTap)
        )
    }
                                                            
    @objc func didTap() {
        let section = SecondSection.allSections
        
        let range = Range(3...5)
        if generatedNumberSet.count != range.count {
            var rdm = Int.random(in: range)
            while generatedNumberSet.contains(rdm) {
                rdm = Int.random(in: range)
            }
            generatedNumberSet.insert(rdm)

            section[0].dataModel.append(
                SectionItem.model1(Model1(id: "model#1", title: "model#1 title#\(rdm)")))
            
            self.applySnapshot()
            
        } else {
            return
        }
    }

}

extension ViewController {
    // 이 메소드가 traditional dataSource의 numberOfItemsInSection & cellForItemAt를 대체해준다.
    func makeDataSource() -> DataSource {
        let ds = DataSource(tableView: self.table) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var text: String = ""
            
            switch itemIdentifier {
            case .model1(let m1):
                text = m1.title
            case .model2(let m2):
                text = m2.description
            }
            if #available(iOS 14.0, *) {
                var config = cell.defaultContentConfiguration()
                config.text = text
                cell.contentConfiguration = config
            } else {
                cell.textLabel?.text = text
            }
            return cell
        }
      return ds
    }
    
    // DataSource에 변경사항이 있는 경우 사용.
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems(section.dataModel, toSection: section)
            
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

