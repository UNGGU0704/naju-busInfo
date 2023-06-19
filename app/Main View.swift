import SwiftUI
import CoreData
import UIKit
import Foundation

@main
struct appApp: App {
    let persistenceController = PersistenceController.shared
    let admin :Int = 5
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,  persistenceController.container.viewContext)
        }
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.busStopID, ascending: true)],
                  animation: .default)
    private var items: FetchedResults<Item>
    @State private var busstopName = "" // 사용자로부터 입력 받을 버스 이름을 저장하는 상태 변수
    
    var body: some View {
        
        
        NavigationView {
            VStack {
                TextField("버스 정류장을 입력하세요", text: $busstopName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                NavigationLink(destination: SearchResultView(busstopName: $busstopName)) {
                    Text("검색")
                }
                .padding()
            }
            .navigationBarItems(trailing:
                NavigationLink(destination: DBView()) {
                   Text("DB")
                }
            )
        }
    }
        
}

