//
//  SearchLineResultView.swift
//  app
//
//  Created by 김규형 on 6/17/24.
//

import SwiftUI
import CoreData

struct SearchLineResultView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var busRouteNumber: String
    @State private var matchedItems: [LineInfo] = []

    var body: some View {
        VStack {
            if matchedItems.isEmpty {
                Text("해당 노선의 버스를 찾을 수 없습니다.")
                    .padding()
            } else {
                List(matchedItems, id: \.self) { item in
                    let lineID = Int(item.lineID) //Int32 -> Int로 unwrapping
                    if let lineName = item.lineName{
                        NavigationLink(destination: LineinfoView(LineID: lineID, Linename: lineName, nowbusStopID: 99999)) {
                            Text("번호 : " + lineName)
                        }
                    } else {
                        Text("Unknown")
                    }
                }
            }
        }
        .onAppear {
            print("searchLine에 돌입!")
            fetchMatchingItems()
        }
        .navigationTitle("노선 검색 결과")
    }

    private func fetchMatchingItems() {
        let fetchRequest: NSFetchRequest<LineInfo> = LineInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "lineName == %@", busRouteNumber)

        do {
            matchedItems = try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }
}
