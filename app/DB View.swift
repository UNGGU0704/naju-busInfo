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
                Button("데이터 갱신 ") {
                    // Button 1의 동작
                    print("Button 1 tapped")
                    fetchBusStopData()
                }
                .padding()
                
                Button("데이터 제거") {
                    // Button 2의 동작
                    print("Button 2 tapped")
                    deleteExistingData()
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
