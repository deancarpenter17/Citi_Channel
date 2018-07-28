//
//  AlgoliaAPI.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/28/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import AlgoliaSearch

class AlgoliaAPI: NSObject {
    
    static let shared = AlgoliaAPI()
    
    var client: AlgoliaSearch.Client?
    var index: AlgoliaSearch.Index?
    
    // MARK: - initialization
    private override init() {
        super.init()
        client = Client(appID: AlgoliaPrivateConstants.APP_ID, apiKey: AlgoliaPrivateConstants.ADMIN_API_KEY)
        if let client = client {
            index = client.index(withName: AlgoliaPublicConstants.postIndex)
        }
    }
}
