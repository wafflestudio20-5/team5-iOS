import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
  private lazy var underlineView: UIView = {
      let width = self.bounds.size.width / CGFloat(self.numberOfSegments) - 20.0
    let height = 10.0
    let xPosition = CGFloat(self.selectedSegmentIndex * Int(width))
    let yPosition = self.bounds.size.height - 1.0
    let frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
    let view = UIView(frame: frame)
    view.backgroundColor = .black
    self.addSubview(view)
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.removeBackgroundAndDivider()
  }
  override init(items: [Any]?) {
    super.init(items: items)
    self.removeBackgroundAndDivider()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func removeBackgroundAndDivider() {
    let image = UIImage()
    self.setBackgroundImage(image, for: .normal, barMetrics: .default)
    self.setBackgroundImage(image, for: .selected, barMetrics: .default)
    self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
    
    self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
    UIView.animate(
      withDuration: 0.1,
      animations: {
        self.underlineView.frame.origin.x = underlineFinalXPosition
      }
    )
  }
}


//사용예시: At VC

//        let segmentedControl: UISegmentedControl = UnderlineSegmentedControl(items: ["내 쇼핑", "내 프로필"])
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//
//        segmentedControl.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: UIColor.lightGray,
//                .font: UIFont.systemFont(ofSize: 18, weight: .bold)
//            ],
//            for: .normal
//        )
//
//        segmentedControl.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: UIColor.black,
//                .font: UIFont.systemFont(ofSize: 18, weight: .bold)
//            ],
//            for: .selected
//        )
//
//        segmentedControl.addTarget(self,
//                                   action: #selector(navigationSegmentedControlValueChanged),
//                                   for: .valueChanged)
//        segmentedControl.selectedSegmentIndex = 0
//
//        segmentedControl.sizeToFit()
//        navigationItem.titleView = segmentedControl
