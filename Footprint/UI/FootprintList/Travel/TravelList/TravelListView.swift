//
//  TravelListView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/12/27.
//

import SwiftUI

struct TravelListView: View {
    typealias VM = TravelListViewModel
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
                Topbar("", type: .back) {
                    vm.onClose()
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach($vm.travels.wrappedValue.indices, id: \.self) { idx in
                            let item = $vm.travels.wrappedValue[idx]
                            drawTravelItem(geometry, item: item)
                        }
                        drawAddNewItem(geometry)
                    }
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 30, trailing: 12))
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .leading)
        }
        .onAppear {
            vm.onAppear()
        }
    }
    
    private func drawTravelItem(_ geometry: GeometryProxy, item: Travel) -> some View {
        return VStack(alignment: .leading, spacing: 6) {
            Text(item.title)
                .font(.kr12b)
                .foregroundColor(.gray90)
            
            Text("일정 : \(item.footprints.count)개")
                .font(.kr10r)
                .foregroundColor(.gray90)
            
            Text(item.intro)
                .font(.kr10r)
                .foregroundColor(.gray90)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .padding(.top, 2)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(
            minWidth:  geometry.size.width - 24, idealWidth:  geometry.size.width - 24, maxWidth: geometry.size.width - 24,
            minHeight: 100, idealHeight: nil, maxHeight: nil, alignment: .leading
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color(hex: item.color, opacity: 0.5))
        )
        .onTapGesture {
            vm.onClickShowTravel(item)
        }
    }
    
    private func drawAddNewItem(_ geometry: GeometryProxy) -> some View {
        return VStack(alignment: .center, spacing: 6) {
            Text("+")
                .font(.kr30b)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
        .contentShape(Rectangle())
        .frame(width: geometry.size.width - 24, height: 100, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray60)
        )
        .onTapGesture {
            vm.onClickCreateTravel()
        }
    }
}