import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let movies = FavoriteLibrary.movies

    override func viewDidLoad() {
        super.viewDidLoad()
        

        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showMovieDetail",
              let detailVC = segue.destination as? DetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }

        let selectedMovie = movies[indexPath.row]
        detailVC.movie = selectedMovie
    }

}


extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return movies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoriteCell",
            for: indexPath
        ) as? FavoriteCell else {
            fatalError("FavoriteCell is not configured correctly")
        }

        let movie = movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
}
