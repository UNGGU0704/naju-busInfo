import SwiftUI
import CoreData
import Foundation

@main
struct appApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
            
                .environment(\.managedObjectContext,  persistenceController.container.viewContext)
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: WishList.entity(), sortDescriptors: []) var wishList: FetchedResults<WishList>
    @State private var busstopName = "" // 사용자로부터 입력 받을 버스 이름을 저장하는 상태 변수
    //  @State private var showAlert = false // Alert 표시 여부를 저장하는 상태 변수
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("버스 정류장을 입력하세요", text: $busstopName)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    )
                    .accentColor(.black)
                    .padding(.horizontal, 10)
                
                NavigationLink(destination: SearchResultView(busstopName: $busstopName)) {
                    Text("검색")
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Spacer()
                        
                        Menu {
                            Button(action: {
                                deleteAllWishListItems()
                            }) {
                                Label("즐겨찾기 전체 삭제", systemImage: "function1")
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
                
                .navigationBarItems(trailing:
                                        HStack {
                    Spacer()
                    NavigationLink(destination: DBView()) {
                        Text("DB")
                    }
                }
                )
                .navigationTitle("버스 정보입력")
                .padding()
                
                List {
                    Section(header: Text("즐겨찾기")) {
                        if wishList.isEmpty {
                            Text("즐겨찾기를 등록해주세요")
                                .foregroundColor(.gray)
                                .italic()
                        } else {
                            ForEach(wishList.indices, id: \.self) { index in
                                let wishItem = wishList[index]
                                if let name = wishItem.busStopName {
                                    if let nextName = wishItem.nextBusStop {
                                        NavigationLink(destination: busInfoResult(busStopName: name, busStopID: Int(wishItem.busStopID), nextBusStop: nextName)) {
                                            Text(name)
                                        }
                                    } else {
                                        Text("Unknown")
                                    }
                                } else {
                                    Text("Unknown")
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    func deleteAllWishListItems() {
        for item in wishList {
            viewContext.delete(item)
        }
        
        do {
            try viewContext.save()
        } catch {
            // 예외 처리
            print("Failed to delete WishList items: \(error)")
        }
    }
    
}

