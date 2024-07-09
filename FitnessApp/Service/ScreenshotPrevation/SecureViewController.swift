import UIKit

class SecureViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = view.window {
            window.isSecure = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let window = view.window {
            window.isSecure = true
        }
    }
}
