import UIKit
import SygicMaps

#error("Register for API Key/secret and insert here. Then delete this line.")
let appKey = ""
let appSecret = ""

//Put your own from/to routing coordinates here
let routeFrom = SYGeoCoordinate.init(latitude:48.145891, longitude: 17.129352)!
let routeTo = SYGeoCoordinate.init(latitude:48.149401, longitude: 17.131147)!

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "startNavigationSegue" {
            return
        }
        
        let onlineNaviViewController = segue.destination as! OnlineNaviSampleViewController
        
        onlineNaviViewController.appKey = appKey
        onlineNaviViewController.appSecret = appSecret
        onlineNaviViewController.from = routeFrom
        onlineNaviViewController.to = routeTo
    }
}
