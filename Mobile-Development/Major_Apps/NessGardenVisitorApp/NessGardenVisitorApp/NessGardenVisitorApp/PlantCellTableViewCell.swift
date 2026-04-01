//
//  PlantCellTableViewCell.swift
//  NessGardenVisitorApp
//
//  Created by Kian Palas on 09/12/2025.
//

import UIKit

class PlantCellTableViewCell: UITableViewCell {
        
        // create these in Storyboard and connect them!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var subtitleLabel: UILabel!
        @IBOutlet weak var plantImageView: UIImageView!
        @IBOutlet weak var favButton: UIButton!
        
        var plantId: String?
        
        //  tells the ViewController to reload the table or handle the tap
        var onToggleFavorite: (() -> Void)?

        @IBAction func favButtonTapped(_ sender: Any) {
            guard let id = plantId else { return }
            
            FavoritesManager.shared.toggleFavorite(id: id)
            
            // updates icon
            updateFavoriteIcon()
            
            // triggers call back
            onToggleFavorite?()
        }
        // adds values to cell
        func configure( plant: Plant, image: UIImage?) {
            self.plantId = plant.recnum
            
            titleLabel.text = "\(plant.genus ?? "") \(plant.species ?? "")"
            subtitleLabel.text = plant.vernacular_name ?? ""
            plantImageView.image = image ?? UIImage(systemName: "leaf")
            
            updateFavoriteIcon()
        }
        
    //updates heart
        func updateFavoriteIcon() {
            guard let id = plantId else { return }
            let isFav = FavoritesManager.shared.isFavorite(id: id)
            let iconName = isFav ? "heart.fill" : "heart"
            favButton.setImage(UIImage(systemName: iconName), for: .normal)
            favButton.tintColor = isFav ? .red : .gray
        }
    }
