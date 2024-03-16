
//  File.swift
//  app
//
//  Created by 김규형 on 3/16/24.
//

import Foundation


import UIKit

class WebRedirectHelper {
    static func redirectWeb(to url: URL) {
        UIApplication.shared.open(url)
    }
}
