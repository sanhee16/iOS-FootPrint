//
//  AddFootprintViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import Foundation
import Combine
import UIKit
import RealmSwift

class AddFootprintViewModel: BaseViewModel {
    
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var images: [UIImage] = []
    @Published var pinType: PinType = .pin0
    @Published var category: Category? = nil
    @Published var isKeyboardVisible = false

    var pinList: [PinType] = [.pin0,.pin1,.pin2,.pin3,.pin4,.pin5,.pin6,.pin7,.pin8,.pin9]
    var categories: [Category] = []
    private let location: Location
    private let realm: Realm
    
    init(_ coordinator: AppCoordinator, location: Location) {
        self.realm = try! Realm()
        self.location = location
        super.init(coordinator)
        
        
    }
    
    
    private func getCategories() {
        // 모든 객체 얻기
        let categories = realm.objects(Category.self)
        self.categories.removeAll()
        for i in categories {
            self.categories.append(i)
        }
    }
    
    
    func onAppear() {
        self.getCategories()
    }
    
    func onClose() {
        self.isKeyboardVisible = false
        self.alert(.yesOrNo, title: nil, description: "저장하지 않고 나가시겠습니까?") {[weak self] isClose in
            guard let self = self else { return }
            if isClose {
                self.dismiss()
            }
        }
    }
    
    func onClickGallery() {
        self.isKeyboardVisible = false
        self.coordinator?.presentGalleryView(onClickItem: { [weak self] (item: GalleryItem) in
            guard let self = self else { return }
            if !self.images.contains(item.image) {
                self.images.append(item.image)
            }
        })
    }
    
    func removeImage(_ item: UIImage) {
        self.isKeyboardVisible = false
        self.alert(.yesOrNo, title: nil, description: "삭제하시겠습니까?") {[weak self] allowRemove in
            guard let self = self else { return }
            if allowRemove {
                for idx in self.images.indices {
                    if self.images[idx] == item {
                        self.images.remove(at: idx)
                        break
                    }
                }
            }
        }
    }
    
    func onClickSave() {
        self.isKeyboardVisible = false
        if self.title.isEmpty {
            self.alert(.ok, description: "title을 적어주세요")
            return
        } else if self.content.isEmpty {
            self.alert(.ok, description: "내용을 적어주세요")
            return
        }
        // image save
        self.startProgress()
        let imageUrls: List<String> = List<String>()
        let currentTimeStamp = Int(Date().timeIntervalSince1970)
        for idx in self.images.indices {
            let imageName = "\(currentTimeStamp)_\(idx)"
            let url = ImageManager.shared.saveImage(image: self.images[idx], imageName: imageName)
            print("savedUrl : \(url)")
//            if let url = url {
//                print("savedUrl : \(url)")
//                imageUrls.append(url)
//            }
            imageUrls.append(imageName)
        }
        
        try! realm.write {
            realm.add(FootPrint(title: self.title, content: self.content, images: imageUrls, latitude: self.location.latitude, longitude: self.location.longitude, pinType: self.pinType))
            self.stopProgress()
            self.dismiss(animated: true)
        }
    }

    func onSelectPin(_ item: PinType) {
        self.isKeyboardVisible = false
        self.pinType = item
    }
}
