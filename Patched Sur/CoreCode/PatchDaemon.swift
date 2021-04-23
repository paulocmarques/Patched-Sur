//
//  PatchDaemon.swift
//  Patched Sur
//
//  Created by Ben Sova on 2/20/21.
//

import Foundation
import UserNotifications

func patchDaemon() {
    print("Patched Sur Update Daemon Started.")
    print("Just so we don't mess with after boot preformance,")
    print("we'll sleep for a few minutes then check.")
    sleep(600)
    while true {
        if UserDefaults.standard.string(forKey: "Notifications") == "BOTH" || UserDefaults.standard.string(forKey: "Notifications") == "PATCHER" {
            print("Checking for Patched Sur updates first...")
            if let patcherVersions = try? PatchedVersions(fromURL: "https://api.github.com/repos/BenSova/Patched-Sur/releases").filter({ !$0.prerelease }) {
                print("Checking if we already checked for this...")
                if UserDefaults.standard.string(forKey: "LastCheckedPSVersion") != patcherVersions[0].tagName {
                    print("Checking if we have a different version...")
                    print([patcherVersions[0].tagName].description + " C: " + ["v\(AppInfo.version)"].description)
                    if patcherVersions[0].tagName != "v\(AppInfo.version)" {
                        print("There is a new update!")
                        print("Sending update notification!")
                        var tagName = patcherVersions[0].tagName
                        tagName.removeFirst()
                        scheduleNotification(title: "Patched Sur \(patcherVersions[0].tagName)", body: "Patched Sur can now be updated to Version \(tagName). Open Patched Sur then click Update macOS to learn more.")
                        print("Now making sure we don't sent this again...")
                        UserDefaults.standard.setValue(patcherVersions[0].tagName, forKey: "LastCheckedPSVersion")
                    } else { print("Nope, we're up-to-date.") }
                } else { print("We already have sent this notification.") }
            } else {
                print("Failed to fetch them. oh well...")
            }
        }
        
        if UserDefaults.standard.string(forKey: "Notifications") == "BOTH" || UserDefaults.standard.string(forKey: "Notifications") == "MACOS" {
            print("Getting ready to check for macOS updates")
            print("Figuring out what update track to use...")
            let track = ReleaseTrack(rawValue: UserDefaults.standard.string(forKey: "UpdateTrack") ?? "Release") ?? .release
            print("Using update track \(track).")
            print("Checking for macOS updates...")
            if var macOSversions = try? InstallAssistants(fromURL: URL(string: "https://bensova.github.io/patched-sur/installers/\(track == .developer ? "Developer" : "Release").json")!) {
                print("Sorting the macOS versions...")
                macOSversions = macOSversions.sorted { (first, second) -> Bool in
                    first.orderNumber > second.orderNumber
                }
                if UserDefaults.standard.string(forKey: "LastCheckedOSVersion") != macOSversions[0].buildNumber {
                    print("Checking our build number to compare...")
                    if var buildNumber = (try? call("sw_vers | grep BuildVersion:", at: ".")) {
                        print("Checking if we have a different build number...")
                        buildNumber.removeFirst("BuildVersion: ".count)
                        print([macOSversions[0].buildNumber].description + " C: " + [buildNumber].description)
                        if buildNumber != macOSversions[0].buildNumber {
                            print("Sending update notification!")
                            scheduleNotification(title: "Software Update", body: "macOS Big Sur \(macOSversions[0].version) (\(macOSversions[0].buildNumber)) can now be installed on your device. Open Patched Sur then click Update macOS to learn more.")
                            print("Now making sure we don't sent this again...")
                            UserDefaults.standard.setValue(macOSversions[0].buildNumber, forKey: "LastCheckedOSVersion")
                        } else {
                            print("We're already on the latest version.")
                        }
                    } else {
                        print("We somehow failed to get the build number")
                    }
                } else {
                    print("We've already sent this notification")
                }
            } else {
                print("Failed to fetch them. oh well...")
            }
        }
        print("Waiting for a really long time again...")
        sleep(10800)
    }
    
}

func scheduleNotification(title: String, body: String, inSeconds: TimeInterval = 1, completion: @escaping (Bool) -> () = {_ in}) {

    // Create Notification content
    let notificationContent = UNMutableNotificationContent()

//    notificationContent.title = "Software Update"
//    notificationContent.body = "macOS Big Sur 11.2.1 is available for your Mac. Open Patched Sur then click Update macOS to learn more."
    
    notificationContent.title = title
    notificationContent.body = body

    // Create Notification trigger
    // Note that 60 seconds is the smallest repeating interval.
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)

    // Create a notification request with the above components
    let request = UNNotificationRequest(identifier: "patchedSurUpdateNotification", content: notificationContent, trigger: trigger)

    // Add this notification to the UserNotificationCenter
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        if let error = error {
            print("\(error)")
            completion(false)
        } else {
            completion(true)
        }
    })
}
