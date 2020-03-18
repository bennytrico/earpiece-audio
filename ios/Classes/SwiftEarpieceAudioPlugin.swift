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
//        if let args = call.arguments as? Dictionary<String, Any>,
//            let url = args["url"] as? String {
            let url = call.arguments as? Dictionary<String, Any>
            guard let path: String = Bundle.main.path(forResource: url?["url"] as! String, ofType: "mp4") else {
                return result("error");
            }
            
            let finalUrl: URL = URL(fileURLWithPath: path)
//
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
            
//        }
        
        
        
        result(url?["url"])
    default:
        break
    }
  }
}
