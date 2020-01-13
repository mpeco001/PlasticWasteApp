//
//  SecondViewViewController.swift
//  tt
//
//  Created by Mariano on 11/12/2019.
//  Copyright © 2019 Mariano. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

    

class SecondViewViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPrevLayer : AVCaptureVideoPreviewLayer?
    var cameraCaptOut : AVCapturePhotoOutput?
    
    @IBOutlet weak var lablePredict: UILabel!
    @IBOutlet weak var lableAccuracy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //start a session usign AV capture
        let sessionPreset = AVCaptureSession()
        //selecting a default video device e.a. the videocamera
        guard let capDevice =
        AVCaptureDevice.default(for: .video) else {return}
        //try if the camera is avaiable on the devce and set it as imput for the stream
        guard let input = try? AVCaptureDeviceInput(device: capDevice) else {return}
        //set the inpiut in the session and start the session
        sessionPreset.addInput(input)
        sessionPreset.startRunning()
        // create a layer as stream frame using the session just created
                   let prevLayer = AVCaptureVideoPreviewLayer(session: sessionPreset)
                   view.layer.addSublayer(prevLayer)
                   prevLayer.frame = view.frame
        
        // add the data for the output
        let dataOut = AVCaptureVideoDataOutput()
        dataOut.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoQueue"))
        sessionPreset.addOutput(dataOut)
        //add
        self.view.addSubview(self.lablePredict)
        self.view.addSubview(self.lableAccuracy)
    }
    
    //using the captureOutput method of AVFoundation that capture a video frame that will be anilized by the MLModel
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//       print("camera caputure a frame" , Date())
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        guard let model = try? VNCoreMLModel( for: Resnet50().model) else {return}

        
        
        let request = VNCoreMLRequest( model: model)
        { (finishedReq, err) in
            
//            print(finishedReq.results)
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
            
            print(firstObservation.identifier , firstObservation.confidence)
            
            var prediction : String = firstObservation.identifier
            var accuracy : Int = Int(firstObservation.confidence * 100)
        DispatchQueue.main.async {
             self.lablePredict.font = UIFont(name: "Times-New-Roman", size: 10)

            self.lablePredict.text = prediction
          self.lableAccuracy.text = "Accuracy \(accuracy)% "
            }


//            completionHandler: VNRequestCompletionHandler?)
        }
       try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
       
        
    }
    
    
        
    
    
    
    
        
        

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
