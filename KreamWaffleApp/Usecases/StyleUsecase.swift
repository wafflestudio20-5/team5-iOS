//
//  StyleUsecase.swift
//  KreamWaffleApp
//
//  Created by 최성혁 on 2022/12/29.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

final class StyleUsecase {
    private let repository: StyleRepository
    private let disposeBag = DisposeBag()
    
    let stylePostRelay: BehaviorRelay<[StylePost]> = .init(value: [])
    
    var stylePostList = [StylePost]() {
        didSet {
            self.stylePostRelay.accept(self.stylePostList)
        }
    }
        
    init (repository: StyleRepository) {
        self.repository = repository
        requestStylePostData(page: 1)
    }
    
    func requestStylePostData(page: Int) {
        // ******* For Testing *********
        if (page == 1) {
            setTestData()
        } else {
            setTestData(page: page)
        }
        // ******* For Testing *********
    }
    
    // ******* For Testing *********
    // API 세팅 후에는 얘가 API call로 데이터 load 하는 함수가 될 것.
    func setTestData() {
        self.stylePostList = [
            StylePost(imageSources: ["https://kream-phinf.pstatic.net/MjAyMzAxMDNfMjY3/MDAxNjcyNzU0OTAwOTY3.toeDt1DlK3krk9xBjBzhVsx2GhQsYNx4sA4PQxWjwSYg.Cph6_U3j9iVvKvoUEbObe6Lu7q7kDcXjML2FYCfR3Wkg.JPEG/p_bdd6d1073d3d4b43b0eda8b2d996e972.jpeg?type=l"], id: "mangocheezz", numLikes: 1, content: "아더에러 ✨", thumbnailImageRatio: 4/3),
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDRfMjgz/MDAxNjcyNzk2NzYwNDQy.Wevy_PRf7WIRazGTBOSnrawYtkORHTpttq-TQeaSaycg.utFzIapF6u42cGPSiQKFuew38p8BMhljzanB_pOm0XUg.JPEG/p_98d5413c43764b37a96af46325deb243.jpeg?type=l"], id: "kko_gen", numLikes: 2, content: "게시물2.길어서 짤리는 경우", thumbnailImageRatio: 1),
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDRfMjk1/MDAxNjcyNzU4NzEwODM3.MF0WBuhvMiLUzLaXEcmiAF9j3tnLEkjEtlAjyH4Ew2Mg.jLUER_r3FUO8pJExwLxmEqRroX1dpynZ929Th2CuZAAg.JPEG/p_321f10f8c86a478e94b14a58832c2b4f.jpeg?type=l"], id: "dustn5101", numLikes: 3, content: "#결산템챌린지 #ootd #데일리룩 #아웃핏 #KREAM스타일 #겨울여자코디 #보헤미안서울 #노스페이스눕시 #패딩추천 #스트릿룩 #무채색룩", thumbnailImageRatio: 4/3),
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDJfMTc1/MDAxNjcyNjYzNTAxMzY0.AqlChMQVgHUMvdfgCYkaH3kFqjbqR1_GeM-Cy4ITTXEg.a-Az98SalFV4lyfo-q82hwgAhkeTjKaNQ7VXhR-aMyIg.JPEG/p_b6e2018049c44483be43ab6437f19d18.jpeg?type=l"], id: "j.hingg", numLikes: 4, content: "네번째 게시글", thumbnailImageRatio: 1),
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDJfMTc1/MDAxNjcyNjY2NjY3Mzgw.9WEQoAE-OzHg1Sp2EM1KyjiOgFo36WlEHe1yGnRCMpkg.lYpvKmgm86affUOWKDN1fA6ypT7M0d4Y_AGrh4Xa_z8g.JPEG/p_591cb1f4cf654239b548c86a9366b31c.jpg?type=l"], id: "ssssom", numLikes: 5, content: "다섯번째 게시글", thumbnailImageRatio: 4/3),
            StylePost(imageSources: ["https://kream-phinf.pstatic.net/MjAyMzAxMDNfMTYy/MDAxNjcyNzU2OTg2MDk5.EmFv8HUZNOpwJh6yGELuPX3v6Pmv19WbOPnxvX6a0ugg.ppNvmi85ExMikuGEc5mpjnjOre0uCIpp62usWWERUHQg.JPEG/p_b1f52152926c4d189018324b8808bc43.jpeg?type=l"], id: "iieioaa", numLikes: 6, content: "#데일리룩 #고프코어 #아식스 #코디 #데일리룩 #좋아요 #데일리 #미니멀룩 #가을코디 #남친룩 #남자데일리룩 #남자패션 #갬성", thumbnailImageRatio: 4/3),
        ]
    }
    
    func setTestData(page: Int) {
        let newData = [
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDJfMTc1/MDAxNjcyNjYzNTAxMzY0.AqlChMQVgHUMvdfgCYkaH3kFqjbqR1_GeM-Cy4ITTXEg.a-Az98SalFV4lyfo-q82hwgAhkeTjKaNQ7VXhR-aMyIg.JPEG/p_b6e2018049c44483be43ab6437f19d18.jpeg?type=l"], id: "j.hingg", numLikes: 4, content: "네번째 게시글", thumbnailImageRatio: 1),
            StylePost(imageSources:["https://kream-phinf.pstatic.net/MjAyMzAxMDJfMTc1/MDAxNjcyNjY2NjY3Mzgw.9WEQoAE-OzHg1Sp2EM1KyjiOgFo36WlEHe1yGnRCMpkg.lYpvKmgm86affUOWKDN1fA6ypT7M0d4Y_AGrh4Xa_z8g.JPEG/p_591cb1f4cf654239b548c86a9366b31c.jpg?type=l"], id: "ssssom", numLikes: 5, content: "다섯번째 게시글", thumbnailImageRatio: 4/3),
            StylePost(imageSources: ["https://kream-phinf.pstatic.net/MjAyMzAxMDNfMTYy/MDAxNjcyNzU2OTg2MDk5.EmFv8HUZNOpwJh6yGELuPX3v6Pmv19WbOPnxvX6a0ugg.ppNvmi85ExMikuGEc5mpjnjOre0uCIpp62usWWERUHQg.JPEG/p_b1f52152926c4d189018324b8808bc43.jpeg?type=l"], id: "iieioaa", numLikes: 6, content: "#데일리룩 #고프코어 #아식스 #코디 #데일리룩 #좋아요 #데일리 #미니멀룩 #가을코디 #남친룩 #남자데일리룩 #남자패션 #갬성", thumbnailImageRatio: 4/3),
        ]
        
        self.stylePostList.append(contentsOf: newData)
    }
    // ******* For Testing *********

}

