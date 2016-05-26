//
//  AnimalTableViewController.swift
//  IndexedTableDemo
//
//  Created by Simon Ng on 17/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.

import UIKit


class AnimalTableViewController: UITableViewController {
    var pokeDict = [String: [Pokemon]]()
    var pokemonTitles = [String]();
    var pokemonArray = [Pokemon]()
    var selectedCellIndexPath: NSIndexPath?
    let selectedCellHeight: CGFloat = 88.0
    let unselectedCellHeight: CGFloat = 44.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPokemon()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return pokemonTitles.count
    }
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return pokemonTitles
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let imageView = UIImageView(image: UIImage.init(named: "right_chevron"))
        cell.accessoryView = imageView
        
        let pokeKey = pokemonTitles[indexPath.section]
        if let pokeValues = pokeDict[pokeKey] {
            pokeValues[indexPath.row].get_sprites()
            pokeValues[indexPath.row].get_images()
            if pokeValues[indexPath.row].imageArray.count > 0 {
                let spriteURL = pokeValues[indexPath.row].imageArray[0]
//                cell.imageView!.sd_setImageWithURL(spriteURL)

                cell.imageView?.image = UIImage(data: (NSData(contentsOfURL: spriteURL))!)
            }
            cell.textLabel?.text = pokeValues[indexPath.row].name.capitalizedString
            
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath, "selected")
        if selectedCellIndexPath != nil && selectedCellIndexPath == indexPath {
            selectedCellIndexPath = nil
            
        } else {
            self.selectedCellIndexPath = indexPath
        }
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let imageView = UIImageView(image: UIImage.init(named: "down_chevron"))
        cell?.accessoryView = imageView
        self.tableView.beginUpdates()

        self.tableView.endUpdates()
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let imageView = UIImageView(image: UIImage.init(named: "right_chevron"))
        cell?.accessoryView = imageView
    }
    override func   tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pokemonTitles[section]
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let pokeKey = pokemonTitles[section]
        if  let pokeValues = pokeDict[pokeKey] {
            return pokeValues.count
        }
        return 0
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        print("getting cell height")
        if(selectedCellIndexPath == indexPath){

            return selectedCellHeight
        }
        return unselectedCellHeight
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getPokemon(){
        let url = NSURL(string:"https://pokeapi.co/api/v1/pokedex/1/")
        let request1: NSURLRequest = NSURLRequest(URL: url!)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        do {
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(dataVal, options: [])
                if let pokemonJSON = json["pokemon"] as? [[String: AnyObject]] {
                    for pokemon in pokemonJSON {
                        if let name = pokemon["name"] as? String,let resource_uri = pokemon["resource_uri"] as? String  {
                                self.pokemonArray.append(Pokemon(name: name, resource_uri: resource_uri))
                        }
                    }
                    self.createPokemonDictionary()
                }
            } catch let error {
                print(error)
            }
            } catch let error {
                print(error)
            }
        
    }
    
    func createPokemonDictionary() {
        for pokemon in self.pokemonArray {
            let pokeKey = pokemon.name.substringToIndex(pokemon.name.startIndex.advancedBy(1))
            if var pokeValues = pokeDict[pokeKey] {
                pokeValues.append(pokemon)
                pokeDict[pokeKey] = pokeValues
            } else {
                pokeDict[pokeKey] = [pokemon]
            }
            
        }
        pokemonTitles = [String](pokeDict.keys)
        pokemonTitles = pokemonTitles.sort()
    }
}
