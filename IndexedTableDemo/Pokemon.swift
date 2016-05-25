//
//  Pokemon.swift
//  IndexedTableDemo
//
//  Created by Robert Wilkinson on 5/19/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class Pokemon {
    var isExpanded = false
    var name, resource_uri: String
    var spritesArray = [NSURL]()
    var imageArray = [NSURL]()
    init(name: String, resource_uri: String) {
        self.name = name
        self.resource_uri = "https://pokeapi.co/" + resource_uri
    }
    func get_sprites() {
        let url = NSURL(string: self.resource_uri)
        let request1: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(dataVal, options: [])
                if let spritesJSON = json["sprites"] as? [[String: String]] {
                    for sprite in spritesJSON {
                        if let url = sprite["resource_uri"] {
                            let fullURL = "https://pokeapi.co/" + url
                            spritesArray.append(NSURL(string: fullURL)!)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        } catch let error {
            print(error)

        }
    }
    func get_images() {
        for url in self.spritesArray {
            let request1: NSURLRequest = NSURLRequest(URL: url)
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            do {
                let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(dataVal, options: [])
                    if let image_url = json["image"] as? String {
                        let fullURL = "https://pokeapi.co/" + image_url
                        imageArray.append(NSURL(string: fullURL)!)
                    }

                } catch let error {
                    print(error)
                }
            } catch let error {
                print(error)
                
            }

        }
    }
    
}