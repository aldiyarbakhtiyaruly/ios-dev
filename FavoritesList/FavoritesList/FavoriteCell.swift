
import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    func configure(with item: FavoriteItem) {

    
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        posterImageView.image = UIImage(named: item.imageName)

    
        let stars = [star1, star2, star3, star4, star5]
        let rating = max(0, min(item.rating, 5))

        for (index, star) in stars.enumerated() {
            let symbol = index < rating ? "star.fill" : "star"
            star?.image = UIImage(systemName: symbol)
            star?.tintColor = .systemYellow
        }
    }
}
