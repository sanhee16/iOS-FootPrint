//
//  CreateTravelViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import Foundation
import Combine
import UIKit
import RealmSwift
import SwiftUI

enum EditTravelType {
    case create
    case edit(item: Travel)
}

class CreateTravelViewModel: BaseViewModel {
    private let realm: Realm
    @Published var title: String = ""
    @Published var intro: String = ""
    @Published var footprints: [FootPrint] = []
    @Published var allFootprints: [FootPrint] = []
    @Published var color: Color = Color.white
    @Published var draggedItem: FootPrint? = nil
    
    
    override init(_ coordinator: AppCoordinator) {
        self.realm = try! Realm()
        super.init(coordinator)
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func loadAllFootprints() {
        self.allFootprints = Array(self.realm.objects(FootPrint.self))
    }
    
    func onClickAdd() {
        self.startProgress()
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            let list = RealmSwift.List<FootPrint>()
            list.append(objectsIn: self.footprints)
            let item = Travel(footprints: list, title: self.title, intro: self.intro, color: color.toHex() ?? "#FFFFFF")
            self.realm.add(item)
            self.stopProgress()
            self.onClose()
        }
    }
    
    func onClickDeleteFootprint(_ item: FootPrint) {
        guard let idx = self.footprints.firstIndex(where: { listItem in
            listItem.id == item.id
        }) else { return }
        _ = withAnimation {[weak self] in
            self?.footprints.remove(at: idx)
        }
    }
    
    func onClickSave() {
        try! self.realm.write {[weak self] in
            guard let self = self else { return }
            self.startProgress()
            let saveFootprints: RealmSwift.List<FootPrint> = RealmSwift.List<FootPrint>()
            for item in self.footprints {
                saveFootprints.append(item)
            }

            let item: Travel = Travel(footprints: saveFootprints, title: self.title, intro: self.intro, color: color.toHex() ?? "#FFFFFF")
            self.realm.add(item)
            self.stopProgress()
            self.onClose()
        }
    }
    
    func onClickAddFootprints() {
        self.coordinator?.presentSelectFootprintsView(selectedList: self.footprints, callback: { res in
            print(res)
            self.footprints = res
        })
    }
}