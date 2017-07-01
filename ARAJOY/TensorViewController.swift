//
//  ViewController.swift
//  ARAJOY
//
//  Created by Morten Just Petersen on 1/9/17.
//  Copyright © 2017 Daniel Nfodjo. All rights reserved.
//

import UIKit
import AVFoundation

class TensorViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, TensorDelegate {
    
    @IBOutlet weak var previewView: UIView!
    var bridge:TensorBridge = TensorBridge()
    var square = UIImage(named: "second")
    var synth = AVSpeechSynthesizer()
    var labelLayers = [CATextLayer]()
    var oldPredictionValues = [AnyHashable: Any]()
    var predictionTextLayer: CATextLayer = CATextLayer()

     private var videoCapture: VideoCapture!
        private var ciContext : CIContext!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let videoCapture = videoCapture else {return}
        videoCapture.startCapture()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bridge.loadModel()
        bridge.delegate = self
        
        let spec = VideoSpec(fps: 3, size: CGSize(width: 640, height: 480))
        videoCapture = VideoCapture(cameraType: .back,
                                    preferredSpec: spec,
                                    previewContainer: previewView.layer)
     
        videoCapture.imageBufferHandler = {[unowned self] (imageBuffer, timestamp, outputBuffer) in
            self.bridge.runCNN(onFrame: imageBuffer)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        // Test individual labels here
        AppUtility.lockOrientation(.portrait)

        
//        presentSeenObject(label: "peanut")
    }
    

    // seen objects enter here
    
    func tensorLabelListUpdated(_ recognizedObjects:[AnyHashable : Any]){
        
            let leftMargin: Float = 10.0
            let topMargin: Float = Float((self.navigationController?.navigationBar.frame.size.height)! + 20.0)
            let valueWidth: Float = 48.0
            let valueHeight: Float = 26.0
            let labelWidth: Float = 246.0
            let labelHeight: Float = 26.0
            let labelMarginX: Float = 5.0
            let labelMarginY: Float = 5.0
            removeAllLabelLayers()
            var labelCount: Float = 0.0
            let sortedObjects = recognizedObjects.sorted(by: { ($0.value as! Double) > ($1.value as! Double) })
            for entry in sortedObjects {
                let label = String(describing: entry.key)
                let valueObject = entry.value as! Double
                let conPct = (valueObject * 100).rounded()
                if valueObject > 0.20 {
                    print("\(conPct)% sure that's a \(label)")
                }
                
                let value = CFloat(valueObject)
                let originY: Float = (topMargin + ((labelHeight + labelMarginY) * labelCount))
                let valuePercentage = Int(roundf(value * 100.0))
                let valueOriginX: Float = leftMargin
                let valueText: String = "\(valuePercentage)%%"
                addLabelLayer(withText: valueText, originX: valueOriginX, originY: originY, width: valueWidth, height: valueHeight, alignment: kCAAlignmentRight)
                let labelOriginX: Float = (leftMargin + valueWidth + labelMarginX)
                addLabelLayer(withText: (label.capitalized), originX: labelOriginX, originY: originY, width: labelWidth, height: labelHeight, alignment: kCAAlignmentLeft)
                if (labelCount == 0) && (value > 0.5) {
                    speak((label.capitalized))
                }
                labelCount += 1
                if labelCount > 4 {
                    break
                }
            }

        
    }
    
    func removeAllLabelLayers() {
        for layer: CATextLayer in labelLayers {
            layer.removeFromSuperlayer()
        }
        labelLayers.removeAll()
    }
    
    
    func addLabelLayer(withText text: String, originX: Float, originY: Float, width: Float, height: Float, alignment: String) {
        let font = "Menlo-Regular"
        let fontSize: Float = 20.0
        let marginSizeX: Float = 5.0
        let marginSizeY: Float = 2.0
        let backgroundBounds = CGRect(x: CGFloat(originX), y: CGFloat(originY), width: CGFloat(width), height: CGFloat(height))
        let textBounds = CGRect(x: CGFloat((originX + marginSizeX)), y: CGFloat((originY + marginSizeY)), width: CGFloat((width - (marginSizeX * 2))), height: CGFloat((height - (marginSizeY * 2))))
        let background = CATextLayer()
        background.backgroundColor = UIColor.black.cgColor
        background.opacity = 0.5
        background.frame = backgroundBounds
        background.cornerRadius = 5.0
        view.layer.addSublayer(background)
        labelLayers.append(background)
        let layer = CATextLayer()
        layer.foregroundColor = UIColor.white.cgColor
        layer.frame = textBounds
        layer.alignmentMode = alignment
        layer.isWrapped = true
        layer.font = font as CFTypeRef
        layer.fontSize = CGFloat(fontSize)
        layer.contentsScale = UIScreen.main.scale
        layer.string = text
        view.layer.addSublayer(layer)
        labelLayers.append(layer)
    }
    
    func setPredictionText(_ text: String, withDuration duration: Float) {
        if duration > 0.0 {
            let colorAnimation = CABasicAnimation(keyPath: "foregroundColor")
            colorAnimation.duration = CFTimeInterval(duration)
            colorAnimation.fillMode = kCAFillModeForwards
            colorAnimation.isRemovedOnCompletion = false
            colorAnimation.fromValue = UIColor.darkGray.cgColor
            colorAnimation.toValue = UIColor.white.cgColor
            colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            predictionTextLayer.add(colorAnimation, forKey: "colorAnimation")
        }
        else {
            predictionTextLayer.foregroundColor = UIColor.white.cgColor
        }
        predictionTextLayer.removeFromSuperlayer()
        view.layer.addSublayer(predictionTextLayer)
        predictionTextLayer.string = text
    }
    
    func speak(_ words: String) {
        if synth.isSpeaking {
            return
        }
        let utterance = AVSpeechUtterance(string: words)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.75 * AVSpeechUtteranceDefaultSpeechRate
        synth.speak(utterance)
    }
    
    func presentSeenObject(label:String){
        
        
        // Create a ViewController that shows a web page
        // You can do your own thing here, like your own view controller, or 
        // just show something in this viewcontroller
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webView") as! SeenObjectViewController
        
        // is this label defined?
        if let url = Config.seeThisOpenThat[label] {
            vc.urlToLoad = url
            
        } else {
            // not defined explicitly, see if there is a catch-all
            
            if let catchAll = Config.seeThisOpenThat["catch-all"] {
                
                // change - with spaces in label. You can remove this
                var l = label.replacingOccurrences(of: "-", with: " ")
                
                // make the label URL friendly
                l = l.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
                
                // Replace %s with the label 
                let u = catchAll.replacingOccurrences(of: "%s", with: l)
                
                vc.urlToLoad = u
            } else {
            // not even the catch-all is in config. 
                //          Let's just improvise. Maybe a custom thing.
                
                vc.urlToLoad = "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=\(label)"
            }
        }
        
        
        
        self.present(vc, animated: false, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

