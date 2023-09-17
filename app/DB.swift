import UIKit
import Foundation
import CoreData

struct DBApiResponse: Codable {
    let bus_stops: [BusStop]
    let row_count: Int
    let admin :Int = 5
    private enum CodingKeys: String, CodingKey {
        case bus_stops = "STATION_LIST"
        case row_count = "ROW_COUNT"
    }
}

struct BusStop: Codable {
    let busStopName: String
    let arsID: Int
    let nextBusStop: String?
    let busStopID: Int
    let longitude: Double
    let nameE: String?
    let latitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case busStopName = "BUSSTOP_NAME"
        case arsID = "ARS_ID"
        case nextBusStop = "NEXT_BUSSTOP"
        case busStopID = "BUSSTOP_ID"
        case longitude = "LONGITUDE"
        case nameE = "NAME_E"
        case latitude = "LATITUDE"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        busStopName = try container.decode(String.self, forKey: .busStopName)
        arsID = try container.decode(Int.self, forKey: .arsID)
        nextBusStop = try container.decodeIfPresent(String.self, forKey: .nextBusStop)
        busStopID = try container.decode(Int.self, forKey: .busStopID)
        longitude = try container.decode(Double.self, forKey: .longitude)
        nameE = try container.decodeIfPresent(String.self, forKey: .nameE)
        latitude = try container.decode(Double.self, forKey: .latitude)
    }
}
public func deleteExistingData() {
    let context = PersistenceController.shared.container.viewContext
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    
    if let items = try? context.fetch(request) {
        for item in items {
            context.delete(item)
        }
        
        do {
            try context.save()
            context.processPendingChanges()
        } catch {
            print("Error deleting existing bus stop data: \(error)")
        }
    }
}


public func fetchBusStopData() {
    print("fetch 함수 작동!")
    deleteExistingData()
    let persistenceController = PersistenceController.shared
    let context = persistenceController.container.viewContext
    
    guard let url = URL(string: "http://121.147.206.212/json/stationInfo") else {
        print("Invalid URL")
        return
    }
    
    var coreDataCount: Int {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        return (try? context.count(for: request)) ?? 0
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
        
        context.performAndWait {
            do {
                let DBapiResponse = try JSONDecoder().decode(DBApiResponse.self, from: data)
                let busStopData = DBapiResponse.bus_stops
                
                for busStop in busStopData {
                    let newItem = Item(context: context)
                    newItem.busStopName = busStop.busStopName
                    newItem.arsID = Int32(busStop.arsID)
                    newItem.nextBusStop = busStop.nextBusStop ?? ""
                    newItem.busStopID = Int32(busStop.busStopID)
                    newItem.longitude = busStop.longitude
                    newItem.nameE = busStop.nameE ?? ""
                    newItem.latitude = busStop.latitude
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error saving bus stop data: \(error)")
                    }
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }
    }.resume()
}
