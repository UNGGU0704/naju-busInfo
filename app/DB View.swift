//
//  DB View.swift
//  app
//
//  Created by 김규형 on 2023/06/19.
//

import SwiftUI
import CoreData
struct DBView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.busStopID, ascending: true)])
    private var items: FetchedResults<Item>
    @State private var isShowingButtons = false
    
    var busStop: Item = Item()
    
    var body: some View {
        VStack {
            List(items) { busStop in
                HStack {
                    VStack(alignment: .leading) {
                        Text(busStop.busStopName ?? "알 수 없음")
                            .font(.headline)
                        Text("ArsID: \(busStop.arsID)")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("정류장ID: \(busStop.busStopID)")
                            .font(.subheadline)
                        Text("위도: \(busStop.latitude), 경도: \(busStop.longitude)")
                            .font(.footnote)
                    }
                }
            }
            .listStyle(.plain)
            
            if isShowingButtons {
                Button("정류장 데이터 가져오기") {
                    fetchBusStopData()
                }
                .padding()
                
                Button("노선 데이터 가져오기") {
                    fetchBusRouteData()
                }.padding()
                
                Button("정류장 데이터 제거") {
                    deleteExistingBusStops()
                }
                .padding()
                
                Button("노선 데이터 제거") {
                    deleteExistingBusRoutes()
                }
                .padding()
            }
        }
        .navigationTitle("버스 정류장 목록")
        .navigationBarItems(trailing:
                                Button(action: {
            isShowingButtons.toggle()
        }) {
            Image(systemName: "ellipsis")
        }
        )
    }
}
