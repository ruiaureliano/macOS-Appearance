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
    var osAppearance: OSAppearance = .light

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        /**
         * Make app always light
         **/

        NSApp.appearance = NSAppearance(named: .aqua)

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
        getAppearance()
    }

    func getAppearance() {
        self.osAppearance = .light
        if #available(OSX 10.15, *) {
            var appearance: OSAppearance = .light
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
                if appleInterfaceStyle.lowercased().contains("dark") {
                    appearance = .dark
                }
            }
            var switchesAutomatically: Bool = false
            if let appleInterfaceStyleSwitchesAutomatically = UserDefaults.standard.object(forKey: kAppleInterfaceStyleSwitchesAutomatically) as? Bool {
                switchesAutomatically = appleInterfaceStyleSwitchesAutomatically
            }
            if switchesAutomatically {
                switch appearance {
                case .light:
                    self.osAppearance = .dark
                case .dark:
                    self.osAppearance = .light
                }
            } else {
                self.osAppearance = appearance
            }

        } else if #available(OSX 10.14, *) {
            if let appleInterfaceStyle = UserDefaults.standard.object(forKey: kAppleInterfaceStyle) as? String {
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
            case .dark:
                self.textfield.stringValue = "Dark"
            }
        }
    }
}
