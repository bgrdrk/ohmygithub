import UIKit

class CustomButton: UIControl {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? AppUI.appColor(.lightGrey) : AppUI.appColor(.customWhite)
        }
    }
}
