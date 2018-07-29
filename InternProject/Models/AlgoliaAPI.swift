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
    var postIndex: AlgoliaSearch.Index?
    
    // MARK: - initialization
    private override init() {
        super.init()
        client = Client(appID: AlgoliaPrivateConstants.APP_ID, apiKey: AlgoliaPrivateConstants.ADMIN_API_KEY)
        if let client = client {
            postIndex = client.index(withName: AlgoliaPublicConstants.postIndex)
        }
    }
    
    func searchPosts(for searchString: String, completion: @escaping ([Post]) -> Void) {
        postIndex?.search(Query(query: searchString), completionHandler: { (content, error) -> Void in
            if error == nil {
                if let contentDict = content as NSDictionary? {
                    if let postsArray = contentDict["hits"] as? [[String: AnyObject]] {
                        var posts = [Post]()
                        for postDict in postsArray {
                            let ownerName = postDict["ownerName"] as? String ?? ""
                            let ownerUID = postDict["ownerUID"] as? String ?? ""
                            let popularity = postDict["popularity"] as? Int ?? 0
                            let description = postDict["postDescription"] as? String ?? ""
                            let postTitle = postDict["postTitle"] as? String ?? ""
                            let postUID = postDict["postUID"] as? String ?? ""
                            var postDate = Date()
                            if let t = postDict["timestamp"] as? TimeInterval {
                                postDate = Date(timeIntervalSince1970: t/1000)
                            }
                            // Convert [String] to [Post]
                            let postTagsStrings = postDict["postTags"] as? [String] ?? []
                            var postTags = [Tag]()
                            for tag in postTagsStrings {
                                postTags.append(Tag(name: tag))
                            }
                            let post = Post(ownerUID: ownerUID, ownerName: ownerName, description: description, tags: postTags, title: postTitle, postUID: postUID, postDate: postDate, popularity: popularity)
                            
                            posts.insert(post, at: 0)
                        }
                        
                        completion(posts)
                    }
                    
                }
            } else {
                print("Algolia Error!: \(error.debugDescription)")
            }
            
        })
    }
}

