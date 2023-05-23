import Foundation
import CoreData
import UIKit
import SwiftUI

public struct SearchResultView: View {
    let arrivals: [Arrival]
    
    public var body: some View {
        List(arrivals, id: \.lineName) { arrival in
            VStack(alignment: .leading) {
                Text("Line Name: \(arrival.lineName)")
                Text("Remain Stop: \(arrival.remainStop)")
                Text("Remain Min: \(arrival.remainMin)")
                Text("Bus Stop Name: \(arrival.busStopName)")
            }
        }
    }
}


struct ApiResponse: Codable {
    let result: Result
    let arriveList: [Arrival]
    let rowCount: Int

    private enum CodingKeys: String, CodingKey {
        case result = "RESULT"
        case arriveList = "ARRIVE_LIST"
        case rowCount = "ROW_COUNT"
    }
}

struct Result: Codable {
    let resultMsg: String
    let resultCode: String

    private enum CodingKeys: String, CodingKey {
        case resultMsg = "RESULT_MSG"
        case resultCode = "RESULT_CODE"
    }
}

struct Arrival: Codable {
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

public func searchBus(by busName: String) -> SearchResultView {
    print("searchBus 탐색 시작")
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext

    // Retrieve the bus stop with the given name from CoreData
    let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "busStopName == %@", busName)

    do {
        let fetchedItems = try context.fetch(fetchRequest)
        guard let busStop = fetchedItems.first else {
            print("Bus stop not found")
            return SearchResultView(arrivals: [])
        }

        // Retrieve the busStopID from the CoreData object
        let busStopID = busStop.busStopID

        // Construct the URL for the API request
        guard var urlComponents = URLComponents(string: "http://121.147.206.212/json/arriveApi") else {
            print("Invalid URL")
            return SearchResultView(arrivals: [])
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "BUSSTOP_ID", value: "\(busStopID)")
        ]

        guard let url = urlComponents.url else {
            print("Invalid URL")
            return SearchResultView(arrivals: [])
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
                let arrivals = apiResponse.arriveList

                DispatchQueue.main.async {
                    let resultView = SearchResultView(arrivals: arrivals)
                    // Present the result view here or pass it to another view
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
        
        return SearchResultView(arrivals: [])
    } catch {
        print("Error fetching bus stop data: \(error)")
        return SearchResultView(arrivals: [])
    }
}
