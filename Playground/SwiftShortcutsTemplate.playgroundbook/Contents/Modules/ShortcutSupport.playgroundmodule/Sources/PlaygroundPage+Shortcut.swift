import PlaygroundSupport
import SwiftShortcuts
import UIKit

public extension PlaygroundPage {
    func show<S: Shortcut>(_ shortcut: S) {
        // Construct the view controller
        let viewController = ShortcutPreviewViewController(
            shortcut: shortcut
        )

        // Wrap the preview within a navigation controller
        let navigationController = UINavigationController(
            rootViewController: viewController
        )

        // Create a new trait collection that secifies `.compact` horizontal size class
        let traitCollection = UITraitCollection(traitsFrom: [
            .current,
            UITraitCollection(horizontalSizeClass: .compact)
        ])

        // Hide the nav bar, force a compact horizontal environment
        navigationController.isNavigationBarHidden = true
        navigationController.setOverrideTraitCollection(
            traitCollection,
            forChild: viewController
        )

        // Set the live view
        liveView = navigationController
    }
}
