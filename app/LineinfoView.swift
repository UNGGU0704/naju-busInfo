//
//  LineinfoView.swift
//  app
//
//  Created by 김규형 on 2023/07/19.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

struct LineApiResponse: Codable {
    let LineList: [Line]
    let rowCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case LineList = "BUSSTOP_LIST"
        case rowCount = "ROW_COUNT"
    }
}

struct LocationApiResponse: Codable {
    let LocationList: [Location]
    let rowCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case LocationList = "BUSLOCATION_LIST"
        case rowCount = "ROW_COUNT"
    }
}

struct Line: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let busStopID: Int
    let busStopName: String
    
    private enum CodingKeys: String, CodingKey {
        case busStopName = "BUSSTOP_NAME"
        case busStopID = "BUSSTOP_ID"
        
    }
}

struct Location: Codable{
    let id = UUID()
    let busStopID: Int
    let busNo: String
    
    private enum CodingKeys: String, CodingKey {
        case busNo = "BUS_NO"
        case busStopID = "BUSSTOP_ID"
        
    }
}

struct LineinfoView: View {
    public var LineID : Int //버스 ID 받아옴
    public var Linename: String
    public var nowbusStopID: Int
    @State private var selectedLine: [Line] = []
    @State private var selectedLocation: [Location] = []
    @State private var isRotating = false
    @State private var scrollToIndex: Int = 0
    var body: some View {
        ScrollViewReader { proxy in
            
            VStack {
                if selectedLine.isEmpty {
                    Text("정보가 없습니다.")
                } else {
                    ScrollView {
                        VStack{
                            ForEach(selectedLine.indices, id: \.self) { index in
                                
                                HStack(alignment: .center, spacing: 8) {
                                    if let location = findBusLocation(for: selectedLine[index].busStopID) {
                                        if Linename.contains("셔틀")||Linename.contains("우정") || Linename.contains("그린") {
                                            Image(systemName: "bus")
                                                .font(.title)
                                                .foregroundColor(.green)
                                                .frame(width: 30) // 버스 그림의 너비를 지정해줍니다.
                                        } else if Linename.contains("99") || Linename.contains("좌석") ||
                                                    Linename.contains("161") || Linename.contains("160"){
                                            Image(systemName: "bus")
                                                .font(.title)
                                                .foregroundColor(.purple)
                                                .frame(width: 30) // 버스 그림의 너비를 지정해줍니다.
                                        } else {
                                            Image(systemName: "bus")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                                .frame(width: 30) // 버스 그림의 너비를 지정해줍니다.
                                        }
                                        
                                    }
                                    else if(nowbusStopID == selectedLine[index].busStopID){
                                        Circle()
                                            .offset(x: -2)
                                            .frame(width: 30, height: 15)
                                            .foregroundColor(.red)
                                    }
                                    else{
                                        Circle()
                                            .frame(width: 25, height: 10)
                                            .foregroundColor(.blue)
                                    }
                                    
                                    
                                    if(nowbusStopID == selectedLine[index].busStopID){
                                        Text("\(selectedLine[index].busStopName)")
                                            .font(.headline)
                                            .foregroundStyle(.black)
                                            .id(-1) // 최초 스크롤 위치를 이동시키기 위한 ID
                                            .padding()
                                    }
                                    else{
                                        Text("\(selectedLine[index].busStopName)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                    
                                    if let location = findBusLocation(for: selectedLine[index].busStopID){
                                        Text("\(location.busNo)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer() // 버스 정류장 점과 버스 정류장 이름을 수평으로 맞추기 위해 Spacer 추가
                                    if(nowbusStopID == selectedLine[index].busStopID){
                                        Text("내 위치 ")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }.padding(.vertical, -10)
                                Divider()
                                
                            }// foreeach 대괄호
                            .foregroundColor(.gray)
                        }.navigationBarTitle("\(Linename) 번 버스 전체 정보 ")
                            .onAppear {
                                proxy.scrollTo(-1, anchor: .center)
                            }
                    } .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // Perform action
                                isRotating.toggle()
                                fetchLineData(for: LineID)
                                fetchLocationData(for: LineID)
                                print("버튼 실행 ")
                                
                            }) {
                                Image(systemName: "arrow.clockwise.circle")
                                    .rotationEffect(.degrees(isRotating ? 360 : 0))
                                    .animation(.easeInOut(duration: 0.5), value: isRotating)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .listStyle(PlainListStyle())
                    .overlay(
                        // Draw the connecting line with a Path
                        Path { path in
                            if selectedLine.indices.contains(0), selectedLine.indices.contains(selectedLine.count - 1) {
                                let firstPoint = CGPoint(x: 29, y: 0) // 첫 번째 정류장 위치
                                let lastPoint = CGPoint(x: 29, y: UIScreen.main.bounds.height + 50) // 화면 아래쪽으로 경로를 연결
                                path.move(to: firstPoint)
                                path.addLine(to: lastPoint)
                            }
                        }
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    
                    .cornerRadius(10) // 모서리를 둥글게 만듭니다.
                } // else 종료
                
            } // VStack 대괄호
            .navigationBarTitle("\(Linename) 번 버스 위치 정보 ")
            .onAppear {
                fetchLineData(for: LineID)
                fetchLocationData(for: LineID)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .padding(.bottom, -30)
        
    } // 바디
    
    
    public func fetchLineData(for LineID: Int) { // 전체 노선 정보를 불러오는 데이터
        
        
        // Construct the URL for the API request
        guard var urlComponents = URLComponents(string: "http://121.147.206.212/json/lineStationInfo") else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "LINE_ID", value: "\(LineID)")
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
                let LineApiResponse = try JSONDecoder().decode(LineApiResponse.self, from: data)
                let decodedLine = LineApiResponse.LineList
                
                DispatchQueue.main.async {
                    if decodedLine.isEmpty {
                        print("No bus arrivals found for bus stop ID: \(LineID)")
                    } else {
                        self.selectedLine = decodedLine // 첫 번째 도착 정보를 선택
                    }
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
        
    }
    
    
    public func fetchLocationData(for LineID: Int) { // 노선의 현재 있는 위치만 불러오는 데이터
        
        
        // Construct the URL for the API request
        guard var urlComponents = URLComponents(string: "http://121.147.206.212/json/busLocationInfo") else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "LINE_ID", value: "\(LineID)")
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
                let LocationApiResponse = try JSONDecoder().decode(LocationApiResponse.self, from: data)
                let decodedLine1 = LocationApiResponse.LocationList
                
                DispatchQueue.main.async {
                    if decodedLine1.isEmpty {
                        print("No bus arrivals found for bus stop ID: \(LineID)")
                    } else {
                        self.selectedLocation = decodedLine1 // 첫 번째 도착 정보를 선택
                    }
                }
            } catch {
                print("Error decoding JSON data: \(error)")
            }
        }.resume()
        
    }
    
    private func findBusLocation(for busStopID: Int) -> Location? {
        return selectedLocation.first(where: { $0.busStopID == busStopID })
    }
}
