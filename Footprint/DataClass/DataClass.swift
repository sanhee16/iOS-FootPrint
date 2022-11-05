//
//  DataClass.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//


import Foundation
import Photos
import RealmSwift
import Realm

public typealias GalleryItem = (image: UIImage, asset: PHAsset)

class FootPrint: Object {
    //TODO: location 추가해야함
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var images: List<String>
    @Persisted var createdAt: Int

    convenience init(title: String, content: String, images: List<String>) {
        self.init()
        self.title = title
        self.content = content
        self.images = images
        self.createdAt = Int(Date().timeIntervalSince1970)
    }
}
