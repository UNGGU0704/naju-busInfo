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




struct ListItem: View {
    var busStop: Item

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(busStop.busStopName ?? "Unknown")
                    .font(.headline)
                Text("ArsID: \(busStop.arsID)")
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("BusStopID: \(busStop.busStopID)")
                    .font(.subheadline)
                Text("Latitude: \(busStop.latitude), Longitude: \(busStop.longitude)")
                    .font(.footnote)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.busStopID, ascending: true)],
                  animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isListVisible = false // List의 가시성을 제어하기 위한 상태 변수
    @State private var busstopName = "" // 사용자로부터 입력 받을 버스 이름을 저장하는 상태 변수
    @State private var showSearchResult = false // view의 전환을 결정함

    
    var body: some View {
        NavigationLink(destination: SearchResultView(arrivals: []), isActive: $showSearchResult) {
            EmptyView()
        }
        .hidden() // view 의 전환 부분?

        NavigationView {
            VStack {
                if isListVisible {
                    List {
                        ForEach(items) { item in
                            ListItem(busStop: item)
                        }
                    }
                    .navigationBarTitle("Bus Stops")
                    
                    Button("Fetch Data") {
                        print("버튼 인식")
                        fetchBusStopData()
                    }
                    .padding()
                    
                    
                }
                Button("Delete Data") {
                    print("버튼 인식")
                    deleteExistingData()
                }
                .padding()
                
                Button("View Data") {
                    isListVisible = true // View Data 버튼을 클릭하면 List를 보이도록 설정
                    if (!isListVisible){ isListVisible = false }
                }
                .padding()
                TextField("Bus Name", text: $busstopName) // 사용자로부터 버스 이름을 입력받는 TextField

                Button("Search Bus") {
                    print("버튼 인식 정류소 이름: " + busstopName)
                    searchBus(by: busstopName)
                   
                }
                .padding()
                
                
            }
        }
    }

}

