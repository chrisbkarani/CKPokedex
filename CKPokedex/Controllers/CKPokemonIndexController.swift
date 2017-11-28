//
//  CKPokemonIndexController.swift
//  CKPokedex
//
//  Created by Christopher Brandon Karani on 24/11/2017.
//  Copyright © 2017 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher


class CKPokemonIndexController : ListSectionController {
    
    var pokemon : Pokemon?
    let cache : ImageCache = ImageCache(name: "kfCache")
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let collectionView = collectionContext else {
            fatalError("CKPokemonIndecController doesnt have a cell")
        }
        return CGSize(width: collectionView.containerSize.width , height: 200)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CKPokeCell.self, for: self, at: index) as? CKPokeCell else {
            fatalError()
        }
        
        guard let pokemon = pokemon else { return UICollectionViewCell()}
        if let poke = pokemon.infomation {
            if let url = URL(string: poke.spriteUrlString) {
                setImage(with: url, and: cell)
            }
            
            cell.idLabel.setup(poke.id)
            cell.nameLabel.setup(poke.name)
        }

        return cell
    }
    
    private func setImage(with url: URL, and cell: CKPokeCell) {
        KingfisherManager.shared.cache.retrieveImage(forKey: url.absoluteString, options: nil) { (image, cache) in
            if let image = image {
                cell.pokemonImage.image = image
                return
            } else {
                KingfisherManager.shared.downloader.downloadImage(with: url, completionHandler: { (image, error, url, data) in
                    if let image = image {
                        cell.pokemonImage.image = image
                        if let url = url {
                            KingfisherManager.shared.cache.store(image, forKey: url.absoluteString)
                        }
                    }
                })
            }
        }
    }
    
    
    override func didUpdate(to object: Any) {
        pokemon = object as? Pokemon
    }
}





