//
//  TrashView.swift
//  Footprint
//
//  Created by Studio-SJ on 2023/01/17.
//


import SwiftUI

struct TrashView: View {
    typealias VM = TrashViewModel
    public static func vc(_ coordinator: AppCoordinator, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                drawHeader(geometry)
                Text("휴지통에 있는 항목들은 \(Defaults.deleteDays)일이 지나면 완전 삭제됩니다.")
                    .font(.kr11r)
                    .foregroundColor(.textColor1)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 20))
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 4) {
                        drawTitle("Footprints")
                        ForEach($vm.footprintItems.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.footprintItems.wrappedValue[idx]
                            drawTrashFootprint(geometry, item: item)
                        }
                        Divider()
                            .padding([.top, .bottom], 12)
                        drawTitle("Travels")
                        ForEach($vm.travelItems.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.travelItems.wrappedValue[idx]
                            drawTrashTravel(geometry, item: item)
                        }
                    }
                    .frame(width: geometry.size.width - 40, alignment: .leading)
                    .padding([.leading, .trailing], 20)
                }
                .frame(width: geometry.size.width, alignment: .leading)
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawTitle(_ title: String) -> some View {
        return Text(title)
            .font(.kr14b)
            .foregroundColor(.textColor1)
            .padding(EdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 0))
    }
    
    private func drawHeader(_ geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .center) {
            Topbar("휴지통", type: .back) {
                vm.onClose()
            }
            if !$vm.footprintItems.wrappedValue.isEmpty || !$vm.travelItems.wrappedValue.isEmpty {
                HStack(alignment: .center, spacing: 16) {
                    Spacer()
                    switch $vm.trashStatus.wrappedValue {
                    case .none:
                        Text("복원")
                            .menuText()
                            .onTapGesture {
                                $vm.trashStatus.wrappedValue = .recovering
                            }
                        Text("비우기")
                            .menuText()
                            .onTapGesture {
                                vm.deleteAll()
                            }
                    case .recovering:
                        Text("취소")
                            .menuText()
                            .onTapGesture {
                                vm.cancel()
                            }
                        Text("복원")
                            .menuText()
                            .onTapGesture {
                                vm.recoveryItems()
                            }
                    }
                }
                .menuView()
            }
        }
    }
    
    private func drawTrashFootprint(_ geometry: GeometryProxy, item: TrashFootprint) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .center, spacing: 4) {
                    Text("\(item.leftDays)일 남음")
                        .font(.kr9r)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray90)
                        )
                    Text(item.item.title)
                        .font(.kr12b)
                        .foregroundColor(.textColor1)
                }
                .padding(.bottom, 2)
                Text(item.item.createdAt.getDate())
                    .font(.kr10r)
                    .foregroundColor(.gray90)
//                if let category = item.item.tag.getCategory() {
//                    HStack(alignment: .center, spacing: 6) {
//                        Image(category.pinType.pinType().pinWhite)
//                            .resizable()
//                            .frame(both: 18.0, aligment: .center)
//                            .colorMultiply(Color(hex: category.pinColor.pinColor().pinColorHex))
//                        Text(category.name)
//                            .font(.kr12r)
//                            .foregroundColor(Color(hex: category.pinColor.pinColor().pinColorHex))
//                    }
//                }
            }
            Spacer()
            if $vm.trashStatus.wrappedValue == .recovering {
                CheckBox(item.isSelected)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickSelectFootprint(item)
        }
    }
    
    private func drawTrashTravel(_ geometry: GeometryProxy, item: TrashTravel) -> some View {
        return HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(alignment: .center, spacing: 4) {
                    Text("\(item.leftDays)일 남음")
                        .font(.kr9r)
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 3, leading: 5, bottom: 3, trailing: 5))
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(.gray90)
                        )
                    Text(item.item.title)
                        .font(.kr12b)
                        .foregroundColor(.textColor1)
                }
                .padding(.bottom, 2)
                Text(item.item.createdAt.getDate())
                    .font(.kr10r)
                    .foregroundColor(.gray90)
            }
            Spacer()
            if $vm.trashStatus.wrappedValue == .recovering {
                CheckBox(item.isSelected)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.onClickSelectTravel(item)
        }
    }
    
    private func CheckBox(_ isSelected: Bool) -> some View {
        return Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(both: 16.0, aligment: .center)
            .foregroundColor(isSelected ? .fColor3 : .gray60)
            .padding(.trailing, 10)
    }
}
