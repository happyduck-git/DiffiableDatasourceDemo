//
//  SecondSection.swift
//  DiffiableDatasourceDemo
//
//  Created by HappyDuck on 2023/08/06.
//

import Foundation

final class SecondSection: Hashable, Equatable {
    
    let id: UUID = UUID()
    let sectionTitle: String
    var dataModel: [SectionItem]
    
    init(sectionTitle: String, dataModel: [SectionItem]) {
        self.sectionTitle = sectionTitle
        self.dataModel = dataModel
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SecondSection, rhs: SecondSection) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SecondSection {
    static var allSections: [SecondSection] = [
        SecondSection(
            sectionTitle: "First Section",
            dataModel: [
                SectionItem.model1(Model1(id: "model#1", title: "model#1 title#1")),
                SectionItem.model1(Model1(id: "model#1", title: "model#1 title#2")),
            ]
        ),
        SecondSection(
            sectionTitle: "Second Section",
            dataModel: [
                SectionItem.model2(Model2(id: "model#2", description: "model#2 description#1")),
                SectionItem.model2(Model2(id: "model#2", description: "model#2 description#2")),
            ]
        )
    ]
}

enum SectionItem: Hashable {
    case model1(Model1)
    case model2(Model2)
}

struct Model1: Hashable {
    let id: String
    let title: String
}

struct Model2: Hashable {
    let id: String
    let description: String
}
