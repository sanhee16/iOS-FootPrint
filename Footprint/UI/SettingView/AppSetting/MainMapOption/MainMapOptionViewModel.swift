//
//  MainMapOptionViewModel.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/05.
//

import Foundation
import Combine
import UIKit

class MainMapOptionViewModel: BaseViewModel {
    @Published var isOnFilter: Bool = true
    @Published var isOnCategory: Bool = true
    
    override init(_ coordinator: AppCoordinator) {
        super.init(coordinator)
        
    }
    
    func onAppear() {
        
    }
    
    func onClose() {
        self.dismiss()
    }
    
    func onTapToggle() {
        
    }
}
