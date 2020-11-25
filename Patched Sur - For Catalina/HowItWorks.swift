//
//  HowItWorks.swift
//  Patched Sur - For Catalina
//
//  Created by Benjamin Sova on 9/30/20.
//

import SwiftUI

struct HowItWorks: View {
    @Binding var p: Int
    @State var buttonBG = Color.accentColor
    var body: some View {
        VStack {
            Text("How it Works").bold()
            ScrollView {
                Text(howItWorks)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            Button {
                p = 9
            } label: {
                ZStack {
                    buttonBG
                        .cornerRadius(10)
                        .onHover(perform: { hovering in
                            buttonBG = hovering ? Color.accentColor.opacity(0.7) : Color.accentColor
                        })
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(5)
                        .padding(.horizontal, 50)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
        }.padding()
    }
}

struct HowItWorks_Previews: PreviewProvider {
    static var previews: some View {
        HowItWorks(p: .constant(3))
    }
}

let howItWorks = """
Patched Sur is a simple Application for running macOS on unsupported Macs. It used all official software from Apple, but optimizes it for your Mac.

PLEASE REMEMBER: Patched Sur should work perfectly fine on most Macs, but a lot can go wrong with the process, especially if you don't read the instructions. I don't suggest using Patched Sur with Mac Pros as there is a much better patcher that is designed for those Macs, StarPlayrX's Big Mac patcher. Even if you don't have a Mac Pro, a lot still can go wrong that might result in data loss, a slow software (while in Big Sur), kernel panics, no entry signs, and more. Please always make a Time Machine Backup before using Patched Sur in case anything goes wrong and you need to reset your Mac.

Also note: If you have FireVault on, turn it off. Patched Big Sur has several problems with it, and it will not work with FireVault on.

Just note though, this isn't all by me. I only made the app and made the changes to make it easy for anyone to go through this process. Here's where everyone else came to help:

- ASentientBot: Made the Hax patches for the installer and brought GeForce Tesla (9400M/320M) framebuffer to Big Sur
- jackluke: Figured out how to bypass compatibility checks on the installer USB.
- highvoltage12v: Made the first WiFi kexts used with Big Sur
- ParrotGeek: developed the LegacyUSBInjector kext to get USB ports working on some older Macs and figuring out a way to skip the terminal commands when opening the installer app on the USB.
- testheit: Helped with the kmutil command in the micropatcher (that is used in Patched Sur too)
- barrykn: Made the micropatcher that introduced me to the patching process and restored my faith in my really old computer. My hat is down to barrykn, and yours should be too.
- and several others who helped with making Big Sur run as great as it does on unsupported Macs.

Yeah, I didn't even do a third of the work, but just so you know your Mac is safe, here's everything Patched Sur does.

It creates the usb installer used to install macOS Big Sur onto your Mac. To do that it needs a couple of things: an official copy of the Install macOS Big Sur.app, downloaded straight from Apple or you can choose your own, and a copy of barrykn's micropatcher used for patching a couple of things on the usb and later for replacing your kexts (similar to drivers which make stuff like WiFi and USB ports work).

The installer is used to flash a copy of something similar to Recovery Mode onto the USB so you can boot into that. However, before that you need to patch it so that you can reinstall macOS like you normally would if something went wrong with your Mac (which in this case is Apple dropping support for it).

Booting into the installer is relatively simple, but you have to do one thing first. Part of the usb patches is that it adds a second drive you need to boot into first. AND!!! I'll finish this later! On to v0.0.4.
"""
