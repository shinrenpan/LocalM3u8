//
//  Copyright (c) 2023 shinren.pan@gmail.com All rights reserved.
//

import UIKit
import AVKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = makeButton()
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

private extension ViewController {
    func makeButton() -> UIButton {
        let action = UIAction { [weak self] _ in
            self?.presentPlayerVC()
        }
        
        let result = UIButton(type: .system, primaryAction: action)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.setTitle("Play", for: .normal)
        return result
    }
    
    func presentPlayerVC() {
        guard let m3u8Path = Bundle.main.path(forResource: "video", ofType: "m3u8") else {
            return
        }
        
        let player = LocalPlayer(m3u8Path: m3u8Path)
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            player.play()
        }
    }
}
