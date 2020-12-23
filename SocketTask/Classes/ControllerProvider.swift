//
//  ControllerProvider.swift
//  SocketTask
//
//  Created by Ismael AlShabrawy on 21/12/2020.
//

import UIKit

class ControllerProvider {
    class func viewController<vc: UIViewController>(className: vc.Type,storyBoard: StoryboardType, presentationStyle: UIModalPresentationStyle? = .fullScreen) -> vc {
        let mainStoryBoard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let vcIdentifier = String(describing: className.self)
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: vcIdentifier) as! vc
        vc.modalPresentationStyle = presentationStyle ?? .fullScreen
        return vc
    }
    
    class func setMainWindow<vc: UIViewController>(className: vc.Type,storyBoard: StoryboardType) -> UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryBoard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        let vcIdentifier = String(describing: className.self)
        let controller = mainStoryBoard.instantiateViewController(withIdentifier: vcIdentifier) as? vc
        window.rootViewController = controller
        return window
    }
}
