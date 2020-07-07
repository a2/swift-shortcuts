import SwiftShortcuts
import UIKit

class ShortcutPreviewViewController<S: Shortcut>: UIViewController, UIDragInteractionDelegate {
    let shortcut: S

    var name: String {
        return "\(S.self)"
    }

    init(shortcut: S) {
        self.shortcut = shortcut
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(origin: .zero, size: CGSize(width: 3.0, height: 3.0))
        let render = UIGraphicsImageRenderer(size: rect.size)
        let backgroundImage = render.image { context in
            UIColor(red: 0.11, green: 0.12, blue: 0.34, alpha: 1.0).setFill()
            UIRectFill(rect)
        }
        .resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))

        let titleLabel = UILabel()
        titleLabel.text = "Share \(name)"
        titleLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.addInteraction(UIDragInteraction(delegate: self))

        button.addSubview(titleLabel)
        view.addSubview(button)
        view.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -6)
        ])
    }

    @objc func share(_ sender: UIButton) {
        do {
            let fileManager = FileManager.default
            let applicationSupport = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            let directoryURL = applicationSupport.appendingPathComponent("io.a2.swift-shortcuts", isDirectory: true)

            // Remove the output directory if it already existed (clean up any old shortcuts)
            if fileManager.fileExists(atPath: directoryURL.path) {
                try fileManager.removeItem(at: directoryURL)
            }

            // Create the directory again
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Build the shortcut and write it to disk
            let shortcutURL = directoryURL.appendingPathComponent("\(name).shortcut", isDirectory: false)
            let sortcutData = try shortcut.build()
            try sortcutData.write(to: shortcutURL)

            // Create an activity view controller pointing to the shortcut
            let viewController = UIActivityViewController(
                activityItems: [shortcutURL],
                applicationActivities: nil
            )

            // Additionally configure iPad popover presentation if it's ever required
            let controller = viewController.popoverPresentationController
            controller?.sourceRect = sender.bounds
            controller?.sourceView = sender

            // Present the share sheet
            present(viewController, animated: true, completion: nil)
        } catch {
            // Construct an error alert
            let viewController = UIAlertController(
                title: "Error Exporing",
                message: error.localizedDescription,
                preferredStyle: .alert
            )

            // Provide a dismiss action
            viewController.addAction(
                UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            )

            // Present the alert controller
            present(viewController, animated: true, completion: nil)
        }
    }

    func dragInteraction(
        _ interaction: UIDragInteraction,
        itemsForBeginning session: UIDragSession
    ) -> [UIDragItem] {
        return [
            UIDragItem(
                itemProvider: NSItemProvider(
                    object: ShortcutWrapper(shortcut)
                )
            )
        ]
    }
}
