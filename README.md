<p align="center">
   <img width="200" src="app/Assets.xcassets/AppIcon.appiconset/1024.png" alt="APP Logo"></p>
   
 # <p align="center">나주시 버스 </p>
<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.8-orange.svg?style=flat" alt="Swift 5.8">
   </a>
   <img src="https://img.shields.io/badge/iOS-16%2B-brightgreen.svg?style=flat" alt="iOS 16+ Compatible">

<br>
<a href="https://apps.apple.com/kr/app/나주시-버스/id6459411077">
   <img src="https://www.iphones.ru/wp-content/uploads/2010/08/App_Store_Badge_EN1-560x189.png" alt="나주시 버스" width="200"/>
</a>
</p>


# 나주시 버스(Naju Bus)
나주시 시민들을 위한 버스 도착 정보를 제공하는 어플로써 버스 정류장을 검색하고 버스 도착까지 남은 시간을 알려주는 기능을 제공합니다.

## App Store

https://apps.apple.com/kr/app/나주시-버스/id6459411077

## 기능(Features)

- [x] ℹ️ 정류장 데이터 부착
- [x] ℹ️ 정류장 검색
- [x] ℹ️ 도착 시간 제공
- [x] ℹ️ 즐겨 찾기 기능
- [x] ℹ️ 디자인 개선
- [x] ℹ️ 노선 정보 제공
- [x] ℹ️ 노선별 버스 시간표 제공
- [ ] ℹ️ 노선 검색 제공

## 사용(Usage)
| 정류장 검색 | 도착 정보 표시 |
| :---: | :---: |
| <img src = "https://github.com/unggu0704/naju-busInfo/assets/130115689/e10a534a-be2a-426f-b29c-1cfd3e270c4a" width="200" align="center"> | <img src="https://github.com/unggu0704/naju-busInfo/assets/130115689/572b68cc-d38b-4c8b-b377-9bede7218ede" width="200" align="center"> |
| **즐겨찾기 관리** | **노선 정보, 시간표 표시** |
| <img src="https://github.com/unggu0704/naju-busInfo/assets/130115689/714fcf1e-faab-4046-bceb-f3baca8752c4" width="200" align="center"> | <img src="https://github.com/unggu0704/naju-busInfo/assets/130115689/4dd74a65-5607-4634-9aaf-1db58f5a5ad8" width="200" align="center"> |

<img width="69" alt="스크린샷 2023-06-20 오후 11 36 52" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/16bc9a8a-7a9a-465f-929f-0b5c934b83f2">

**일반버스 아이콘입니다.**

 <img width="72" alt="스크린샷 2023-06-20 오후 11 36 55" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/1c51798c-ba76-44d8-81cf-dbb040da5be0"> 

 **광역버스 아이콘입니다.**

<img width="71" alt="스크린샷 2023-06-20 오후 11 36 48" src="https://github.com/UNGGU0704/Naju_busInfo/assets/130115689/caca8c69-22c0-4fef-88a7-dc99568603d7">

**마을버스 아이콘입니다.**

## 업데이트 기록

### 1.3
- 즐겨찾기 Button 클릭시 alert창이 안보이는 버그를 해결 #issue #23
- 노선 정보 제공에서 버스 시간표 보기 기능 추가 #issue #22
  - _제공되는 노선 (99x, 16x, 1xx, 2xx, 4xx, 5xx, 70xx)_
- 종점 같은 다음 정류장이 없을때 표시 형식 변경 #issue #25
- API 정보가 없을 경우의 UI 변경
  
### 1.2
- 다크모드에서 특정 UI가 안보이는 버그 해결 *Issue(#13,#19)* 
- 노선 정보 새로고침시 화면이 고정되지 않음 *Issue(#10)* 
- 즐겨찾기 항목에서 정류장의 방향 정보가 추가 *Issue(#12)* 

### 1.1
- 231002 나주시 버스 노선 전면 개편 대응
  - *광역버스 추가(161번...)*
  - *999번 노선 분리(997번 ,998번...)*
  - *그외 등등...*
    
### 1.0.1
- 어플 정보 수정 

### 1.0
- 최초 배포 

## 파일(File)

#### `Main View.swift`
- 앱 실행시 보이는 메인 화면입니다. 
  버스 정류장을 검색하는 기능을 가지고 있습니다.
#### `searchBus.swift`
- 정류장 정보를 검색하는 기능을 가지고 있습니다.
#### `searchResultView.swift`
- 버스 정류장 이름을 기반으로 CoreData에서 정류장 정보를 검색하고 
  해당 정류장의 도착 정보를 표시하는 기능을 가지고 있습니다.
#### `LineinfoView.swift`
- 해당 노선이 지나가는 모든 버스 정류장을 보여줍니다. 
  추가적으로 해당 노선이 현재 어디 있는지 또한 보여줍니다.
#### `PDFViewer.swift`
- 검색된 노선의 버스 시간표를 web에서 찾아와 PDF로 저장 후 사용자에게 표시합니다.
#### `DB.swift`
- CoreData의 저장, 삭제 기능을 가지고 있습니다.
#### `DB view.swift`
- CoreData에서 가져온 정류소 정보를 표시합니다.
  DB.swift의 생성 삭제 기능을 제어합니다.
#### `PersistenceController.swift`
- CoreData를 설정하고 영구 저장소를 로드합니다.
#### `app.xcdatamodeld`
- CoreData의 저장소입니다.

## 기여(Contributing)
Contributions are very welcome 🙌 

기여는 누구나 환영입니다. 🙌


## License
- MIT License
