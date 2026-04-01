
import UIKit

  

class GuessHistoryTableViewCell: UITableViewCell {

     

    // MARK: - IBOutlets for Guess Pegs

    @IBOutlet weak var guessPeg1: UIImageView!

    @IBOutlet weak var guessPeg2: UIImageView!

    @IBOutlet weak var guessPeg3: UIImageView!

    @IBOutlet weak var guessPeg4: UIImageView!

     

    // MARK: - IBOutlets for Feedback Pegs

    @IBOutlet weak var feedbackPeg1: UIImageView!
 
    @IBOutlet weak var feedbackPeg2: UIImageView!

    @IBOutlet weak var feedbackPeg3: UIImageView!

    @IBOutlet weak var feedbackPeg4: UIImageView!

     

    // MARK: - Properties

    var guessPegs: [UIImageView] = []

    var feedbackPegs: [UIImageView] = []

     

    // MARK: - Lifecycle

    override func awakeFromNib() {

        super.awakeFromNib()

        setupPegs()

    }

     

    override func layoutSubviews() {

        super.layoutSubviews()

        makePegsCircular()

    }

     

    // MARK: - Setup

    private func setupPegs() {

        guessPegs = [guessPeg1, guessPeg2, guessPeg3, guessPeg4]

        feedbackPegs = [feedbackPeg1, feedbackPeg2, feedbackPeg3, feedbackPeg4]

        makePegsCircular()

    }

     

    private func makePegsCircular() {

        for peg in guessPegs {

            peg.layer.cornerRadius = peg.frame.width / 2

            peg.layer.masksToBounds = true

            peg.layer.borderWidth = 1

            peg.layer.borderColor = UIColor.darkGray.cgColor

        }

         

        for peg in feedbackPegs {

            peg.layer.cornerRadius = peg.frame.width / 2

            peg.layer.masksToBounds = true

            peg.layer.borderWidth = 1

            peg.layer.borderColor = UIColor.darkGray.cgColor

        }

    }

     

    // MARK: - Configuration

    func configureWith(guess: Guess) {

        // Set images for all 4 guess pegs

        for i in 0..<4 {

            if i < guess.pegs.count {

                let colour = guess.pegs[i]

                let imageName = colour.imageName

                guessPegs[i].image = UIImage(named: imageName)

                guessPegs[i].backgroundColor = .clear

                guessPegs[i].isHidden = false

            }
 
        }

         

        // Set feedback pegs

        setFeedbackPegs(exact: guess.feedback.exact, colourOnly: guess.feedback.colourOnly)

    }

     

    private func setFeedbackPegs(exact: Int, colourOnly: Int) {

        // Reset all feedback pegs

        for peg in feedbackPegs {

            peg.image = nil

            peg.backgroundColor = .lightGray

            peg.isHidden = false

        }

         

        // Set exact matches (black blob)

        for i in 0..<exact {

            if i < feedbackPegs.count {

                feedbackPegs[i].image = UIImage(named: "black blob")

                feedbackPegs[i].backgroundColor = .clear

            }

        }

         

        // Set colour-only matches (white blob)

        for i in 0..<colourOnly {

            let index = exact + i

            if index < feedbackPegs.count {

                feedbackPegs[index].image = UIImage(named: "white blob")

                feedbackPegs[index].backgroundColor = .clear

            }

        }

         

        // Hide unused feedback pegs

        let totalFeedback = exact + colourOnly

        for i in totalFeedback..<feedbackPegs.count {

            feedbackPegs[i].isHidden = true

        }

    }

}
