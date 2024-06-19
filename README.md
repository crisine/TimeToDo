<h1>Time To Do - 뽀모도로 타이머를 곁들인 투두 앱<br>(AppStore 출시)
<a href="https://apps.apple.com/kr/app/time-to-do-이제는-집중할-때/id6479474029">[앱스토어 링크]</a>
</h1>

![Apple iPhone 11 Pro Max Presentation (1)](https://github.com/crisine/crisine/assets/16317758/f8268005-5f93-497d-a4af-4f728d1345ce)

<h3>
  <blockquote>투두 리스트와 뽀모도로 타이머를 함께 사용하여<br>할 일에 대해 집중한 시간을 추적하고 관리할 수 있는 앱</blockquote>
</h3>

<ul>
  <li>팀원 : iOS 1인 개발</li>
  <li>개발 기간 : 2024.03.07 ~ 2024.03.25 (3주)</li>  
</ul>

<h1>🛠️개발 언어와 도구 및 활용한 기술</h1>
<ul>
  <li>개발 언어: Swift</li>
  <li>개발 환경: Swift 5, iOS 16.0, iPhone 8(SE) ~ iPhone 15 대응</li>
  <li>활용한 도구와 기술</li>
  <ul>
    <li>IDE: Xcode</li>
    <li>라이브러리 및 오픈소스: UIKit, SnapKit, DGCharts</li>
    <li>데이터베이스: Realm</li>
  </ul>
</ul>

<h1>📱주요 기능 및 스크린샷</h1>

<table>
  <tr>
    <th>
    To-Do 리스트와 집중 그래프 화면
    </th>
    <th>
      상세 To-Do 리스트 내용 확인 화면
    </th>
    <th>
      뽀모도로 타이머 화면
    </th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/7dab5e0b-73a5-4e58-8b6a-bc948b002a9c">      
    </td>
    <td>
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/42f50eeb-31a9-43d2-9fcb-98eb02edcc12">
    </td>
    <td>
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/7454162f-f455-4831-a6cd-7c16a2324d5b">
    </td>
  </tr>
</table>




# ⚠️ 트러블 슈팅

## 1. DiffableDataSource에서 Realm 데이터를 다루던 과정에서 발생한 이슈

<table>
  <tr>
    <td>
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/12d28f51-6450-42c2-a06a-63efe099b960">
    </td>
    <td>
      현재 존재하는 할 일을 삭제하고 메인 화면으로 넘어오니 에러 발생
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/56c4e58f-08c2-4b8d-93e2-b19daf12915a">
      <br>
     Todo Model이 Realm Object로 설계되어 있고,  그것을 다음과 같이 감싸서 억지로 사용하던 상황 
      <img src="https://github.com/crisine/TimeToDo/assets/16317758/f753e052-14d0-4d57-8711-4978fec0465f">
    </td>
  </tr>
</table>

### 1) 타입 확인과 가설 세우기
- 일단 에러는 안 났지만 속의 타입은 [LazyFilterSequence<Results<RealmPerson>>.Element] 였던 상태
- LazyFilterSequence는 Struct 타입이므로  DiffableDataSource에 무사히 전달이 가능했다 ￼
- 와중에 snapshot끼리의 비교를 하는 과정에서, 이전 스냅샷에 접근할 때 하필 삭제된 Realm Object를 건드려 뻗어버린 것
- 그렇다면, Realm Object를 값 타입으로 담을 수 있게 한번 거치면 되지 않을까?

### 2) 가설 검증과 후속 조치
- 값 타입을 따로 구현하고, Object -> Struct 로 전환하기 위한 함수 구현
<img width="847" alt="image" src="https://github.com/crisine/TimeToDo/assets/16317758/a0e6edd4-5573-48aa-8273-c097d20b8085">

- DiffableDataSource 에 사용되는 값 타입과 snapshot 데이터 로드 부분 변경
<img width="647" alt="image" src="https://github.com/crisine/TimeToDo/assets/16317758/351d11ea-2397-458e-8a2e-d378d299af02">

*\*코드는 예시입니다!*

## 2. 앱의 최소 버전 (iOS16) 에서 발생했던 CollectionView 스크롤 이슈
<img width="648" alt="image" src="https://github.com/crisine/TimeToDo/assets/16317758/b1931c14-14c0-4122-9b02-f76360461141">

- 출시 직전 테스트를 해보는 과정에서 앱 최소 버전 타깃인 iOS 16에서 컬렉션 뷰 셀의 이동에 관해서 문제가 발생하는 것을 확인
- 화면을 이동하는 경우 ➡️ 이전에 스크롤한 위치 기억 X
- 다른 셀을 누르는 경우 ➡️ 누른 위치 기억 X  
- iOS 16에서만 발생하는 버그인가? 하고 열심히 조사..

### 1) Calendar Cell 선택/스크롤 Flow 조사

셀을 누르는 경우 뷰모델로 이벤트 방출 
➡️ 뷰모델에서 눌린 셀 번호 확인 
➡️ 셀 내의 문자열 날짜를 추출 
➡️ 해당 날짜와 현재 시스템 시간을 조합 
➡️ Date 타입으로 변환 후 저장 프로퍼티에 저장 
➡️ 그래프 영역에 표시할 뽀모도로 fetch 
➡️ 이 달의 첫날~마지막날 요일/숫자 날짜 계산 
➡️ output을 통해 이벤트 방출 
➡️ dataSource 와 snapshot 업데이트

결론은 버전 문제가 아니었다는 판단에 이르게 되었음.

### 2) dataSource의 역할과 코드에서 발생했던 문제점

- dataSource는 컬렉션 뷰에서 데이터와 셀 UI를 어떻게 다룰 것인지 정의하는 참조 타입이다
- 애플 공식 문서 曰: 한 번 정의했으면 바꾸지 마세요
<img src="https://github.com/crisine/TimeToDo/assets/16317758/fedb727e-f020-4f8d-9089-0dbcc1a428c4">

- 방금 전 셀 선택/화면 리로드 시에 부르는 configureDataSource( ) 함수는 이렇게 되어 있었다
<img width="806" alt="image" src="https://github.com/crisine/TimeToDo/assets/16317758/45d53888-5a75-4fb1-8624-b3f26d682740">

즉, 매번 다루는 방법을 새로이 정의한 것이나 다름없었던 셈.

### 3) 검증과 간단한 처리
- output 이벤트가 방출되어 바인딩되는 부분에서  configureDataSource( ) 를 호출하지 않도록 변경
<img width="957" alt="image" src="https://github.com/crisine/TimeToDo/assets/16317758/2da603d1-03cf-4886-ae7e-4a051cf95c52">

- 기존에 버전 관계 없이 발생하던 셀 애니메이션 문제 해결
- 덩달아 그래프 섹션에서의 애니메이션 문제도 해결




