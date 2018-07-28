//
//  AlgoliaAPI.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/28/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import AlgoliaSearch

class AlgoliaAPI {
    
    static let shared = FirebaseAPI()
    
    let client = Client(appID: PrivateConstants.Algolia.APP_ID, apiKey: PrivateConstants.Algolia.ADMIN_API_KEY)
    let index = client.index(withName: Constants.Algolia.postIndex)
    
    // MARK: - initialization
    private override init() {
        super.init()
    }
}
