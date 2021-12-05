
## 🚌 캠퍼들의 출퇴근을 책임진다. BBus, BoostBus!
 실시간 버스 정보, 승하차 알람 기능을 제공하는 '카카오버스' 앱 클론 프로젝트입니다.
 
<img src="https://i.imgur.com/2yYkngd.png">

<div align="center">
    <img src="https://img.shields.io/badge/swift-5.5.1-F05138.svg?style=flat&logo=Swift">
    <img src="https://img.shields.io/badge/14.4-000000.svg?style=flat&logo=iOS">
    <img src="https://img.shields.io/badge/Xcode-13.1-white.svg?style=flat&logo=XCode">
    <img src="https://img.shields.io/badge/UIKit-white.svg?style=flat&logo=UIKit">
    <img src="https://img.shields.io/badge/Combine-777777.svg?style=flat">
    <img src="https://img.shields.io/badge/GithubActions-gray.svg?style=flat&logo=GithubActions">
</div>


<br>

## 🫂 팀 소개

> **Team.mOS**<br>**m**aking **O**pen **S**ource라는 의미로 외부 라이브러리를 사용하지 않겠다는 굳은 의지를 표현하였습니다. 

|[S002_강민상](https://github.com/FreeDeveloper97)|[S013_김태훈](https://github.com/Modyhoon)|[S045_이지수](https://github.com/tmfrlrkvlek)|[S057_최수정](https://github.com/sujeong000)|
|:--------:|:--------:|:--------:|:--------:|
|<img src="https://i.imgur.com/KPKqL47.jpg" width=500>|<img src="https://i.imgur.com/BHsdsnG.jpg" width=500>|<img src="https://i.imgur.com/uYtkoKm.jpg" width=500>|<img src="https://i.imgur.com/cd3093l.jpg" width=500>|

<br>

## ⚒️ 기능 소개
[![Video Label](https://i.imgur.com/9yugYSv.jpg)](https://youtu.be/L__65mr08WY)

<br>

> **BBus** 는 서울특별시에서 제공하는 **공공 API**를 사용하여
<br>**실시간 버스 및 정거장 정보**를 확인할 수 있습니다. 
<br>또한 GPS 위치 정보를 활용한 **승하차 알림 서비스**를 지원합니다.

|버스 및 정거장 검색|실시간 버스 도착 정보 제공|실시간 버스 노선 정보 제공|
|:-:|:-:|:-:|
|<img src="https://i.imgur.com/bhO8JEw.png">|<img src="https://i.imgur.com/9Dj7BTW.png">|<img src="https://i.imgur.com/cKMu0of.png">|
|특정 버스 또는 정거장을 <br>검색할 수 있습니다.|특정 정거장의 실시간 버스 도착 정보를<br> 확인할 수 있습니다.|특정 버스 노선의 실시간 정보를<br> 확인할 수 있습니다.|

|자주 타는 버스 즐겨찾기|버스 승차 알람|버스 하차 알람|
|:-:|:-:|:-:|
|<img src="https://i.imgur.com/NIWzB7c.png" width=400>|<img src="https://i.imgur.com/yO9D0OG.png" width=400>|<img src="https://i.imgur.com/w7xgCHo.png" width=400>|
|즐겨찾기된 버스들의 도착 정보를<br> 홈 화면에서 확인할 수 있습니다.|푸시 알림을 통해 승차 알람을<br> 받을 수 있습니다.|푸시 알림을 통해 하차 알람을<br> 받을 수 있습니다.|

<br>

## ⚙️ 기술 스택
<img src="https://i.imgur.com/eQSNHl3.png">

<br>
<br>

## 🏗 아키텍쳐
![](https://i.imgur.com/NyazoEt.png)

<br>

## 🗂 폴더 구조
> Global : 모든 화면에서 공통적으로 사용되는 변수, 이미지, 객체 등<br>
> Foreground : 각 화면별 View, ViewController, ViewModel, Model<br>
> Background : 화면과 상관 없이 동작되는 기능

```
BBus
├── Global
│   ├── Constant
│   ├── Coordinator
│   ├── DTO
│   ├── Extension
│   ├── Network
│   ├── Resource
│   └── View
├── Foreground 
│   ├── AlarmSetting
│   ├── BusRoute
│   ├── Home
│   ├── MovingStatus
│   ├── Search
│   └── Station
├── Background 
│   ├── GetOffAlarm
│   └── GetOnAlarm
├── AppDelegate
├── SceneDelegate
└── info.plist
```

<br>

## 🏃🏻 기술적 도전
> [Coordinator 를 사용한 MVVM-C 패턴 적용](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#coordinator-%EB%A5%BC-%EC%82%AC%EC%9A%A9%ED%95%9C-mvvm-c-%ED%8C%A8%ED%84%B4-%EC%A0%81%EC%9A%A9)<br>
> [공공 API 트래픽 제한 문제 해결](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EA%B3%B5%EA%B3%B5-api-%ED%8A%B8%EB%9E%98%ED%94%BD-%EC%A0%9C%ED%95%9C-%EB%AC%B8%EC%A0%9C-%ED%95%B4%EA%B2%B0)<br>
> [Combine을 통한 비동기 로직 처리](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#combine%EC%9D%84-%ED%86%B5%ED%95%9C-%EB%B9%84%EB%8F%99%EA%B8%B0-%EB%A1%9C%EC%A7%81-%EC%B2%98%EB%A6%AC)<br>
> [실시간 데이터를 위한 Timer](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%8B%A4%EC%8B%9C%EA%B0%84-%EB%8D%B0%EC%9D%B4%ED%84%B0%EB%A5%BC-%EC%9C%84%ED%95%9C-timer)<br>
> [CoreLocation 을 통한 GPS 정보를 활용한 승하차 추적 서비스](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#corelocation-%EC%9D%84-%ED%86%B5%ED%95%9C-gps-%EC%A0%95%EB%B3%B4%EB%A5%BC-%ED%99%9C%EC%9A%A9%ED%95%9C-%EC%8A%B9%ED%95%98%EC%B0%A8-%EC%B6%94%EC%A0%81-%EC%84%9C%EB%B9%84%EC%8A%A4)<br>
> [스토리보드 없이 Programmatically View 사용](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%8A%A4%ED%86%A0%EB%A6%AC%EB%B3%B4%EB%93%9C-%EC%97%86%EC%9D%B4-programmatically-view-%EC%82%AC%EC%9A%A9)<br>
> [외부 라이브러리 NO](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/%EA%B8%B0%EC%88%A0%EC%A0%81-%EB%8F%84%EC%A0%84#%EC%99%B8%EB%B6%80-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-no)<br>
> [Github Action을 활용한 CI 배포](https://github.com/boostcampwm-2021/iOS09-BBus/wiki/기술적-도전#github-action을-활용한-ci-배포)

<br>

## 저희가 협업했던 과정을 보시려면? 
[Github Wiki](https://github.com/boostcampwm-2021/iOS09-BBus/wiki)
