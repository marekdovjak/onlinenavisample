import UIKit

class RecenterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initDefaults()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initDefaults()
    }
    
    private func initDefaults() {
        self.setTitle("recenter".localized(), for: .normal)
        self.setTitleColor(self.tintColor, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);
        self.backgroundColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.layer.cornerRadius = 25
        
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 230))
        self.addConstraint(NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
    }
}
