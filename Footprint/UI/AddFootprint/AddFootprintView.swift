//
//  AddFootprintView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//

import SwiftUI

struct AddFootprintView: View, KeyboardReadable {
    typealias VM = AddFootprintViewModel
    public static func vc(_ coordinator: AppCoordinator, location: Location, type: AddFootprintType, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, location: location, type: type)
        let view = Self.init(vm: vm)
        let vc = BaseViewController(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    private let IMAGE_SIZE: CGFloat = 70.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("enter title", text: $vm.title)
                            .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .foregroundColor(.greenTint5)
                            )
                            .contentShape(Rectangle())
                            .padding([.leading, .trailing], 16)
//                        drawPinSelectArea(geometry)
                        drawCategorySelectArea(geometry)
                        drawPeopleWithArea(geometry)
                        drawImageArea(geometry)
                        
                        Divider()
                            .background(Color.greenTint5)
                            .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                        
                        MultilineTextField("enter content", text: $vm.content) {
                            
                        }
                        .frame(minHeight: 300.0, alignment: .topLeading)
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 10))
                        .contentShape(Rectangle())
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(.greenTint5)
                        )
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            $vm.isKeyboardVisible.wrappedValue = newIsKeyboardVisible
                        }
                        .onChange(of: $vm.content.wrappedValue) { value in
                            if value == " " {
                                $vm.content.wrappedValue = ""
                            }
                        }
                        .padding([.leading, .trailing], 16)
                    }
                    .padding([.top, .bottom], 14)
                }
                Spacer()
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: $vm.isKeyboardVisible.wrappedValue ? 0 : safeBottom, trailing: 0))
            .ignoresSafeArea(.container, edges: [.top, .bottom])
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .leading) {
            Topbar("", type: .back) {
                vm.onClose()
            }
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                Text("저장")
                    .font(.kr12r)
                    .foregroundColor(.gray100)
                    .onTapGesture {
                        vm.onClickSave()
                    }
            }
            .frame(width: geometry.size.width - 32, height: 50, alignment: .center)
        }
        .frame(width: geometry.size.width, height: 50, alignment: .center)
    }
    
    private func drawImageArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text("이미지 선택")
                .font(.kr13b)
                .foregroundColor(.gray90)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach($vm.images.wrappedValue.indices, id: \.self) { idx in
                        let image = $vm.images.wrappedValue[idx]
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(both: IMAGE_SIZE)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                vm.removeImage(image)
                            }
                            .shadow(color: Color.black.opacity(0.6), radius: 3, x: 0.5, y: 2)
                    }
                    Text("+")
                        .font(.kr16b)
                        .foregroundColor(.white)
                        .frame(both: IMAGE_SIZE, aligment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(.gray30)
                        )
                        .onTapGesture {
                            vm.onClickGallery()
                        }
                }
                .padding(EdgeInsets(top: 3, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }
    
    private func drawPeopleWithArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 10) {
                Text("함께한 사람")
                    .font(.kr13b)
                    .foregroundColor(.gray90)
                Spacer()
                Text("추가")
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickAddPeopleWith()
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach($vm.peopleWith.wrappedValue, id: \.self) { item in
                        Text(item.name)
                            .font(.kr11r)
                            .foregroundColor(.gray100)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
        }
    }
    
    private func drawCategorySelectArea(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 10) {
                Text("카테고리")
                    .font(.kr13b)
                    .foregroundColor(.gray90)
                Spacer()
                if $vm.isCategoryEditMode.wrappedValue {
                    Text("추가")
                        .font(.kr12r)
                        .foregroundColor(.gray60)
                        .onTapGesture {
                            vm.onClickAddCategory()
                        }
                }
                Text($vm.isCategoryEditMode.wrappedValue ? "편집 종료" : "편집")
                    .font(.kr12r)
                    .foregroundColor(.gray60)
                    .onTapGesture {
                        vm.onClickEditCategory()
                    }
            }
            .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 12))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 12) {
                    ForEach($vm.categories.wrappedValue, id: \.self) { item in
                        categoryItem(item, isSelected: $vm.category.wrappedValue?.tag == item.tag)
                    }
                }
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
            }
        }
    }
    
    private func categoryItem(_ item: Category, isSelected: Bool) -> some View {
        return HStack(alignment: .center, spacing: 2) {
            Image(item.pinType.pinType().pinWhite)
                .resizable()
                .frame(both: 14.0, aligment: .center)
                .colorMultiply(Color(hex: item.pinColor.pinColor().pinColorHex))
            Text(item.name)
                .font(isSelected ? .kr11b : .kr11r)
                .foregroundColor(isSelected ? Color.gray90 : Color.gray60)
        }
        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
        .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 6)
//        .border(isSelected || $vm.isCategoryEditMode.wrappedValue ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 6) // 좀 별로인거 같아서 뺌!
        .onTapGesture {
            if $vm.isCategoryEditMode.wrappedValue {
                vm.editCategory(item)
            } else {
                vm.onSelectCategory(item)
            }
        }
    }
//
//    private func pinItem(_ item: PinType, isSelected: Bool) -> some View {
//        return Image(item.pinName)
//            .resizable()
//            .scaledToFit()
//            .frame(both: 30)
//            .padding(10)
//            .border(isSelected ? .greenTint4 : .clear, lineWidth: 2, cornerRadius: 12)
//            .onTapGesture {
//                vm.onSelectPin(item)
//            }
//    }
}
