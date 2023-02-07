# team5-iOS
## ✋ 프로젝트 소개    
서울대학교 컴퓨터공학부 웹/앱 개발 동아리 와플스튜디오(20-5기) 5팀(iOS) 토이프로젝트 결과물입니다.    
한정판 거래 플랫폼 KREAM의 iOS 앱을 클론코딩 하였습니다.  
## 🏃 Contributors   
|이름|Contribution|  
|------|---|  
|[김은혜](https://github.com/gracekim027)| Authentication & My Tab |  
|[이선재](https://github.com/snjlee58)| Shop Tab |  
|[최성혁](https://github.com/qqq1130)| Style Tab |  
## 🛠 Open Source Libraries  
[RxSwift & RxCocoa](https://github.com/ReactiveX/RxSwift)  
[Alamofire](https://github.com/Alamofire/Alamofire)  
[Kingfisher](https://github.com/onevcat/Kingfisher)  
[CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)  
[BetterSegmentedControl](https://github.com/gmarm/BetterSegmentedControl)  
[ImageSlideshow](https://github.com/zvonicek/ImageSlideshow)  
## 🔗 Related Projects    
[Backend](https://github.com/wafflestudio20-5/team5-server)    
[Web Frontend](https://github.com/wafflestudio20-5/team5-web)   
## 🌄 Views
### MY Tab

#### 로그인 및 회원가입   
<center><img src="/Assets/Login-Signup.png" width="70%" height="70%"></center>  

* 로그인 탭에서는 커스텀 로그인 혹은 **네이버**나 **구글**을 이용한 로그인을 할 수 있습니다.   
> 참고: 네이버는 개발 중 상태에서 이용 불가능하여 현재 연결 해제된 상태입니다.
* 커스텀 로그인 시 회원 정보가 일치하지 않거나 회원가입되지 않은 정보라면 에러 노티피케이션이 뜹니다.
* 커스텀 회원가입을 위해서 **이메일 주소, 비밀번호, 신발 사이즈** 정보가 필요합니다.
> 참고: 커스텀 회원가입에 사용한 이메일과 동일한 이메일로 소셜 로그인을 한다면, 같은 유저로 등록됩니다.

#### 마이 쇼핑 및 마이 프로필 탭
<center><img src="/Assets/MyTab.png" width="60%" height="60%"></center> 

* 마이탭은 상단의 segmented control 을 이용하여 마이 쇼핑 및 마이 프로필 탭으로 전환할 수 있습니다.
* 상단에서는 **사진, 유저 이름, 프로필 이름과 소개글**로 구성된 프로필을 볼 수 있습니다. 
> 참고: 신규가입 회원은 랜덤한 프로필 이름을 배정 받고, 유저 이름은 이메일 앞부분으로 배정 받습니다.

* 마이쇼핑 탭에서는 현재 **구매내역, 판매내역**을 알 수 있습니다. 
> 참고: 구매 내역과 판매 내역은 현재  구현 중 입니다. 

* 마이탭에서는 현재 올린 사진과, 내 팔로워 및 팔로잉 리스트를 볼 수 있습니다. 

### 내 팔로워 및 내 팔로잉 리스트  
<center><img src="/Assets/followingList.png" width="60%" height="60%"></center>  
프로필 수정 및 앱 설정
<center><img src="/Assets/Settings.png" width="60%" height="60%"></center>      
  
### SHOP Tab
상품 리스트  
<center><img src="/Assets/SHOP-1-Products.PNG" width="30%" height="30%"></center>   
상품 빠른 필터링  
<center><img src="/Assets/SHOP-2-Filter1.PNG" width="30%" height="30%"></center>  
<center><img src="/Assets/SHOP-3-Filter2.PNG" width="30%" height="30%"></center>  
상품 상세 필터링
<center><img src="/Assets/SHOP-4-Filter3.PNG" width="30%" height="30%"></center>  
상품 디테일
<center><img src="/Assets/SHOP-5-Detail.PNG" width="30%" height="30%"></center>  
  
### STYLE Tab
최신순 피드  
<center><img src="/Assets/STYLE-1-LatestFeed.PNG" width="30%" height="30%"></center>  
팔로잉 피드
<center><img src="/Assets/STYLE-2-FollowingFeed.PNG" width="30%" height="30%"></center>  
새 글 작성  
<center><img src="/Assets/STYLE-3-NewPost.PNG" width="30%" height="30%"></center>  
포스팅 상세페이지
<center><img src="/Assets/STYLE-4-StylePost.PNG" width="30%" height="30%"></center>  
댓글  
<center><img src="/Assets/STYLE-5-Comments.PNG" width="30%" height="30%"></center>  
