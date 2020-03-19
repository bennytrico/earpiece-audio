import Flutter
import UIKit
import AVFoundation

public class SwiftEarpieceAudioPlugin: NSObject, FlutterPlugin {
    static var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "earpiece_audio", binaryMessenger: registrar.messenger())
    let instance = SwiftEarpieceAudioPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)
        break
    case "setSpeakerEarpiece":
        do {
            
        } catch {
            result("error \(error)")
        }
                
        result("BERHASIL")
        break
    
    case "play":
        let arguments: [String: Any] = call.arguments as? [String: Any] ?? [:]
        let filename: String = arguments["filename"] as? String ?? ""
            print("url from flutter \(arguments)")
            print("url path from flutter \(filename)")

            let finalUrl = try! FileManager.default
                .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent(filename)
        
            print("final url path \(finalUrl)")
            do {

                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                try AVAudioSession.sharedInstance().setActive(true)

                SwiftEarpieceAudioPlugin.audioPlayer = try AVAudioPlayer(contentsOf: finalUrl)
                SwiftEarpieceAudioPlugin.audioPlayer.prepareToPlay()
                SwiftEarpieceAudioPlugin.audioPlayer.play()

                result("Berhasil play")
            } catch {
                result("Error play sound")
            }

        result(filename)
    default:
        break
    }
  }
}
