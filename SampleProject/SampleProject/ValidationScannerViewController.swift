//
//  ValidationScannerViewController.swift
//  SampleProject
//
//  Created by Kacy Weakley on 9/13/19.
//  Copyright © 2019 ashby thornwell. All rights reserved.
//
import UIKit
import AVFoundation

class ValidationScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession = AVCaptureSession()

    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get device camera for video capture
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            presentAlert(title: "Camera not found", message: "Cannot access camera to scan barcode.")
            return
        }
        
        do {
            // Add camera device as input to capture session
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)

            // Set output for intercepting metadata for the capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            // Set delegate and define types of metadata to be accepted
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } catch {
            presentAlert(title: "Scanning not supported", message: "Your device does not support QR code scanning.")
            return
        }

        // Display preview of video on screen
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)

        // Start video capture
        captureSession.startRunning()

        // Create frame to highlight captured barcode
        qrCodeFrameView = UIView()

        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.tabItemBlue().cgColor
            qrCodeFrameView.layer.borderWidth = 5
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Stop video capture
        captureSession.stopRunning()
        
        // Check if barcode with metadata captured
        if let metadataObject = metadataObjects.first {
            // Display frame highlighting captured barcode
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: readableObject)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            // Decode QR code and display human readable information
            guard let barcodeString = readableObject.stringValue else { return }
            presentAlert(title: "QR code detected", message: barcodeString)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
