//
//  BannerAdView.swift
//  app
//
//  Created by 김규형 on 11/3/24.
//
import SwiftUI
import GoogleMobileAds

let adUnitID = Bundle.main.object(forInfoDictionaryKey: "AdMobUnitID") as? String ?? "광고 ID 가져오지 못함" //환경변수 관리

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        print(adUnitID)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}

