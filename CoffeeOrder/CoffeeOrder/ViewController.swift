import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var quantityStepper: UIStepper!

    @IBOutlet weak var smallButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var largeButton: UIButton!

    var selectedSize = "S"
    var quantity = 1

    let prices: [String: Double] = [
        "S": 5.99,
        "M": 6.99,
        "L": 7.99
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        quantityStepper.minimumValue = 1
        quantityStepper.maximumValue = 10
        quantityStepper.stepValue = 1
        quantityStepper.value = 1

        updateUI()
    }

    func updateUI() {
        let price = prices[selectedSize] ?? 5.99
        let total = price * Double(quantity)

        priceLabel.text = String(format: "$%.2f", price)
        quantityLabel.text = "\(quantity)"
        orderButton.setTitle(
            String(format: "Order Now - $%.2f", total),
            for: .normal
        )

        let buttons = [smallButton, mediumButton, largeButton]

        for button in buttons {
            button?.alpha = 0.6
        }

        switch selectedSize {
        case "S":
            smallButton.alpha = 1
        case "M":
            mediumButton.alpha = 1
        case "L":
            largeButton.alpha = 1
        default:
            break
        }
    }

    @IBAction func smallTapped(_ sender: UIButton) {
        selectedSize = "S"
        updateUI()
    }

    @IBAction func mediumTapped(_ sender: UIButton) {
        selectedSize = "M"
        updateUI()
    }

    @IBAction func largeTapped(_ sender: UIButton) {
        selectedSize = "L"
        updateUI()
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        quantity = Int(sender.value)
        updateUI()
    }

    @IBAction func orderTapped(_ sender: UIButton) {
        let total = (prices[selectedSize] ?? 5.99) * Double(quantity)

        let alert = UIAlertController(
            title: "Order Confirmed ☕️",
            message: """
            Coffee: Iced Caramel Oat Milk Latte
            Size: \(selectedSize)
            Quantity: \(quantity)
            Total: \(String(format: "$%.2f", total))
            """,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}
