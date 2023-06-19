import Foundation
import CoreData
import UIKit
import SwiftUI

struct ApiResponse: Codable {
    let arriveList: [Arrival]
    let rowCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case arriveList = "ARRIVE_LIST"
        case rowCount = "ROW_COUNT"
    }
}

struct Arrival: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let lineName: String
    let remainStop: Int
    let remainMin: Int
    let busStopName: String
    
    private enum CodingKeys: String, CodingKey {
        case lineName = "LINE_NAME"
        case remainStop = "REMAIN_STOP"
        case remainMin = "REMAIN_MIN"
        case busStopName = "BUSSTOP_NAME"
        
    }
}

public struct SearchResultView: View {
    @Binding var busstopName: String    // 버스 이름 변수
    @State private var selectedArrival: [Arrival] = []
    @State private var isDataLoaded = false
    @State private var busStopNames: [String] = []  // 정류장 이름 배열 추가
    @State private var nextBusStops: [String] = []  // 정류장 이름 배열 추가
    @State private var busStopIDs: [Int] = []  // 정류장 이름 배열 추가
    @State private var isBool:Bool = false
    @State private var isPresented = false
    public var body: some View {
        VStack {
            if isDataLoaded {
                if busStopNames.isEmpty {
                    Text("No bus stops found")
                } else {
                    
                    NavigationStack {
                        ScrollView{
                            ForEach(busStopNames.indices, id: \.self) { index in
                                NavigationLink("정류장 이름: \(busStopNames[index])\n \(nextBusStops[index]) 방향", value: index)
                                    .simultaneousGesture(TapGesture().onEnded{
                                        selectedArrival.removeAll()
                                        fetchData(for: busStopIDs[index])
                                    }).padding()
                            }.navigationDestination(for: Int.self){ i in
                                busInfoResult(infoList: $selectedArrival,busStopName: $busStopNames[i])
                            }.navigationTitle("검색 결과")
                            
                            
                        }
                    }
                    
                    
                }
            } else {
                Text("Loading...")
            }
        } .onAppear {
            searchBusStopNames(by: busstopName)
        }
            
        
    
    }
    
    public func searchBusStopNames(by busName: String) {
        print("Searching bus stop names")
        
        let persistenceController = PersistenceController.shared
        let context = persistenceController.container.viewContext
        
        // Retrieve all bus stops with the given name from CoreData
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "busStopName CONTAINS[c] %@", busName)
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            guard !fetchedItems.isEmpty else {
                print("Bus stops not found")
                busStopNames = []
                isDataLoaded = true
                return
            }
            
            busStopNames = fetchedItems.compactMap { $0.busStopName }
            nextBusStops = fetchedItems.compactMap { $0.nextBusStop }
            busStopIDs = fetchedItems.compactMap {Int($0.busStopID) }
            isDataLoaded = true
        } catch {
            print("Error fetching bus stop data: \(error)")
            busStopNames = []
            nextBusStops = []
            isDataLoaded = true 
        }
    }
    
    
    public func fetchData(for busStopID: Int) {
        

        // Construct the URL for the API request
        guard var urlComponents = URLComponents(string: "http://121.147.206.212/json/arriveApi") else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "BUSSTOP_ID", value: "\(busStopID)")
        ]
        print("API 요청 사이트: " + "\(urlComponents)")
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                let decodedArrivals = apiResponse.arriveList
                
                DispatchQueue.main.async {
                    if decodedArrivals.isEmpty {
                        print("No bus arrivals found for bus stop ID: \(busStopID)")
                    } else {
                        self.selectedArrival = decodedArrivals  // 첫 번째 도착 정보를 선택
                    }
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
        
    }
}



