//
//  DogsTVC.swift
//  LoadDogImagesUsingSkeletonView
//
//  Created by Vikram Kunwar on 20/02/23.
//

import UIKit

class DogsTVC: UITableViewCell {

    @IBOutlet weak var dogImages: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        dogImages.image = nil
    }

}
