//
//  AppCoordinator.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/10/05.
//


import SwiftUI

class AppCoordinator: Coordinator, Terminatable {
    // UIWindow = 화면에 나타나는 View를 묶고, UI의 배경을 제공하고, 이벤트 처리행동을 제공하는 객체 = View들을 담는 컨테이너
    let window: UIWindow
    
    /*
     SceneDelegate에서 window rootViewController 설정해줘야 하는데 window 여기로 가지고와서 여기서 설정해줌
     */
    init(window: UIWindow) { // SceneDelegate에서 호출
        self.window = window
        super.init() // Coordinator init
        let navigationController = UINavigationController()
        self.navigationController = navigationController // Coordinator의 navigationController
        
        // rootViewController 지정 + makeKeyAndVisible 호출 = 지정한 rootViewController가 상호작용을 받는 현재 화면으로 세팅 완료
        self.window.rootViewController = navigationController // window의 rootViewController
        window.makeKeyAndVisible()
    }
    
    // Terminatable
    func appTerminate() {
        print("app Terminate")
        for vc in self.childViewControllers {
            print("terminate : \(type(of: vc))")
            (vc as? Terminatable)?.appTerminate()
        }
        if let navigation = self.navigationController as? UINavigationController {
            for vc in navigation.viewControllers {
                (vc as? Terminatable)?.appTerminate()
            }
        } else {
            
        }
        print("terminate : \(type(of: self.navigationController))")
        (self.navigationController as? Terminatable)?.appTerminate()
    }
    
    //MARK: Start
    func startSplash() {
        let vc = SplashView.vc(self)
        self.present(vc, animated: true)
    }
    
    //MARK: Present
    func presentMain() {
        let vc = MainView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentAddFootprintView(location: Location, type: EditFootprintType, onDismiss: @escaping ()->()) {
        let vc = EditFootprintView.vc(self, location: location, type: type)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentGalleryView(type: GalleryType, onClickItem: (([GalleryItem]) -> ())?) {
        let vc = GalleryView.vc(self, type: type, onClickItem: onClickItem)
        self.present(vc, animated: true)
    }
    
    func presentAlertView(_ type: AlertType, title: String?, description: String?, callback: ((Bool) -> ())?) {
        let vc = AlertView.vc(self, type: type, title: title, description: description, callback: callback)
        self.present(vc, animated: false)
    }
    
    func presentShowFootPrintView(_ location: Location, onDismiss: @escaping ()->()) {
        let vc = ShowFootPrintView.vc(self, location: location)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentAddCategoryView(type: AddCategoryType, onEraseCategory: (()->())? = nil, onDismiss: @escaping ()->()) {
        let vc = AddCategoryView.vc(self, type: type, onEraseCategory: onEraseCategory, completion: nil)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentShowImageView(_ imageIdx: Int, images: [UIImage]) {
        let vc = ShowImageView.vc(self, imageIdx: imageIdx, images: images)
        self.present(vc, animated: true)
    }
    
    func presentSettingView() {
        let vc = SettingView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentCheckPermission() {
        let vc = CheckPermissionView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentDevInfoView() {
        let vc = DevInfoView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentFootprintListView() {
        let vc = FootprintListView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentPeopleWithSelectorView(type: PeopleWithEditType) {
        let vc = PeopleWithSelectorView.vc(self, type: type)
        self.present(vc, animated: true)
    }
    
    func presentPeopleEditView(_ peopleEditStruct: PeopleEditStruct, callback: @escaping ((Int?) -> ())) {
        let vc = PeopleEditView.vc(self, peopleEditStruct: peopleEditStruct, callback: callback)
        self.present(vc, animated: true)
    }
    
    func presentFootprintListFilterView(onDismiss: @escaping ()->()) {
        let vc = FootprintListFilterView.vc(self)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentTravelListView() {
        let vc = TravelListView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentEditTravelView(_ type: EditTravelType, onDismiss: (()->())? = nil) {
        let vc = EditTravelView.vc(self, type: type)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentSelectFootprintsView(selectedList: [FootPrint], callback: @escaping ([FootPrint])->()) {
        let vc = SelectFootprintsView.vc(self, selectedList: selectedList, callback: callback)
        self.present(vc, animated: true)
    }
    
    func presentPeopleWithListView() {
        let vc = PeopleWithListView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentCategorySelectorView(type: CategorySelectorType) {
        let vc = CategorySelectorView.vc(self, type: type)
        self.present(vc, animated: true)
    }
    
    func presentShowTravelView(travel: Travel, onDismiss: @escaping ()->()) {
        let vc = ShowTravelView.vc(self, travel: travel)
        self.present(vc, animated: true, onDismiss: onDismiss)
    }
    
    func presentTrashView() {
        let vc = TrashView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentPremiumCodeView() {
        let vc = PremiumCodeView.vc(self)
        self.present(vc, animated: true)
    }
    
    func presentReviewView(_ star: Int) {
        let vc = ReviewView.vc(self, star: star)
        self.present(vc, animated: true)
    }
    
    //MARK: Change
    func changeAddFootprintView(location: Location, type: EditFootprintType, onDismiss: @escaping ()->()) {
        let vc = EditFootprintView.vc(self, location: location, type: type)
        self.change(vc, animated: true, onDismiss: onDismiss)
    }
    
    func changeFootprintListView() {
        let vc = FootprintListView.vc(self)
        self.change(vc, animated: true)
    }
    
    func changeTravelListView() {
        let vc = TravelListView.vc(self)
        self.change(vc, animated: true)
    }
    
    func changeSettingView() {
        let vc = SettingView.vc(self)
        self.change(vc, animated: true)
    }
}
