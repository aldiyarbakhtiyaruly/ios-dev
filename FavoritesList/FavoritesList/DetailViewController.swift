
import UIKit

class DetailViewController: UIViewController {

    var movie: FavoriteItem?

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movie = movie else { return }

        titleLabel.text = movie.title
        subtitleLabel.text = movie.subtitle
        posterImageView.image = UIImage(named: movie.imageName)

        navigationItem.title = movie.title
    }
}
