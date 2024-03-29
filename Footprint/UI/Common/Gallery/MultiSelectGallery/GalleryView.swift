//
//  GalleryView.swift
//  Footprint
//
//  Created by Studio-SJ on 2022/11/04.
//


import SwiftUI
import SwiftUIPullToRefresh
import Kingfisher

struct GalleryView: View {
    typealias VM = GalleryViewModel
    public static func vc(_ coordinator: AppCoordinator, type: GalleryType, onClickItem: (([GalleryItem])->())?, completion: (()-> Void)? = nil) -> UIViewController {
        let vm = VM.init(coordinator, type: type, onClickItem: onClickItem)
        let view = Self.init(vm: vm)
        let vc = BaseViewController.init(view, completion: completion)
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    @ObservedObject var vm: VM
    
    private var safeTop: CGFloat { get { Util.safeTop() }}
    private var safeBottom: CGFloat { get { Util.safeBottom() }}
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Topbar("gallery", type: .close) {
                    vm.onClose()
                }
                RefreshableScrollView(onRefresh: { done in
                    vm.loadAllImages(done)
                }) {
                    ZStack(alignment: .bottom) {
                        VStack(alignment: .center, spacing: 0) {
                            if $vm.items.wrappedValue.isEmpty {
                                Spacer()
                                Text("empty_album".localized())
                                    .font(.kr14b)
                                    .foregroundColor(.textColor1)
                                Spacer()
                            } else {
                                let cellSize = geometry.size.width / 3 - 2
                                RefreshableScrollView { done in
                                    vm.loadAllImages(done)
                                } content: {
                                    LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 1), count: 3), spacing: 1) {
                                        ForEach($vm.items.wrappedValue.indices, id: \.self) { idx in
                                            let item = vm.items[idx]
                                            ZStack(alignment: .topLeading) {
                                                ZStack(alignment: .center) {
                                                    if item.isSelected {
                                                        Rectangle()
                                                            .frame(both: cellSize - 4, aligment: .center)
                                                            .foregroundColor(.clear)
                                                            .border(.fColor2, lineWidth: 4, cornerRadius: 0.0)
                                                            .zIndex(1)
                                                    }
                                                    Image(uiImage: item.image)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: cellSize, height: cellSize)
                                                        .clipped()
                                                        .contentShape(Rectangle())
                                                }
                                                .onTapGesture {
                                                    vm.onClickItem(item)
                                                }
                                            }
                                        }
                                        if $vm.hasNextPage.wrappedValue {
                                            VStack(alignment: .center, spacing: 0) {
                                                ProgressView()
                                            }
                                            .frame(width: geometry.size.width, height: 100, alignment: .center)
                                            .onAppear {
                                                vm.loadNextImage()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .center)
                        
                        Text("select".localized())
                            .font(.kr16b)
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width - 40, height: 50, alignment: .center)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor($vm.isAvailableSelect.wrappedValue ? .fColor2 : .gray30)
                            )
                            .onTapGesture {
                                vm.onSelectImage()
                            }
                            .padding(.bottom, 20)
                            .zIndex(1)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height - 50, alignment: .center)
                }
            }
            .padding(EdgeInsets(top: safeTop, leading: 0, bottom: safeBottom, trailing: 0))
            .edgesIgnoringSafeArea(.all)
            .frame(width: geometry.size.width, alignment: .center)
        }
        .onAppear {
            vm.onAppear()
        }
    }
}
