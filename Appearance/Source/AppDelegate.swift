import Cocoa

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"
private let kAppleInterfaceStyle = "AppleInterfaceStyle"
private let kAppleInterfaceStyleSwitchesAutomatically = "AppleInterfaceStyleSwitchesAutomatically"

enum OSAppearance: Int {
    case light
    case dark
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var textfield: NSTextField!
    @IBOutlet weak var textview: NSTextView!
    var osAppearance: OSAppearance = .light

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        textview.font = NSFont(name: "Menlo", size: 14)
        /**
         **  KVO Notification
         **/

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(self.appleInterfaceThemeChangedNotification(notification:)),
            name: NSNotification.Name(rawValue: kAppleInterfaceThemeChangedNotification),
            object: nil
        )

        /**
         * UPDATE APPEARANCE
         **/

        getAppearance()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @objc func appleInterfaceThemeChangedNotification(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            // Slow down to let system change taking effect.
            self.getAppearance()
        }
    }

    func getAppearance() {
        self.osAppearance = .light
        if #available(OSX 10.15, *) {
            let appearanceDescription = NSApplication.shared.effectiveAppearance.debugDescription.lowercased()
            self.textview.textStorage?.append(NSAttributedString(string: "appearanceDescription: \(appearanceDescription)\n"))
            if appearanceDescription.contains("dark") {
                self.osAppearance = .dark
            }
        } else if #available(OSX 10.14, *) {
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
                self.textview.textStorage?.append(NSAttributedString(string: "appleInterfaceStyle: \(appleInterfaceStyle)\n"))
                if appleInterfaceStyle.lowercased().contains("dark") {
                    self.osAppearance = .dark
                }
            }
        }
        updateAppearance()
    }

    func updateAppearance() {
        DispatchQueue.main.async {
            switch self.osAppearance {
            case .light:
                self.textfield.stringValue = "Light"
                self.textview.textColor = .black
            case .dark:
                self.textfield.stringValue = "Dark"
                self.textview.textColor = .white
            }
        }
    }
}
