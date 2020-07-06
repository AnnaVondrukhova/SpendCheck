//
//  ScanVC.swift
//  SpendCheck
//
//  Created by Anya on 14/03/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import UIKit
import AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    var captureDevice: AVCaptureDevice?
    let requestService = RequestService()
    
    var qrString = "t=20200518T155200&s=531.82&fn=9289000100346765&i=97660&fp=4179925410&n=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            sideMenuBtn.target = self.revealViewController()
            sideMenuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        RequestService.checkExist(receivedString: qrString)

//        //запускаем камеру
//        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
//        //var error: NSError?
//        do {
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            captureSession = AVCaptureSession()
//            captureSession?.addInput(input as AVCaptureInput)
//
//            let captureMetadataOutput = AVCaptureMetadataOutput()
//            captureSession?.addOutput(captureMetadataOutput)
//
//            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
//
//            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            videoPreviewLayer?.frame = view.layer.bounds
//            view.layer.addSublayer(videoPreviewLayer!)
//
//            captureSession?.startRunning()
//            print ("Capture session started running")
//        } catch let error {
//            print("\(error.localizedDescription)")
//        }
//
//        //вызываем зеленую рамку
//        qrCodeFrameView = UIView()
//        qrCodeFrameView?.layer.borderColor = UIColor(red:0.26, green:0.71, blue:0.56, alpha:1.0).cgColor
//        qrCodeFrameView?.layer.borderWidth = 2
//        qrCodeFrameView?.layer.cornerRadius = 15
//        qrCodeFrameView?.frame.size = CGSize(width: self.view.frame.width - 50, height: self.view.frame.width - 50)
//        qrCodeFrameView?.center = self.view.center
//        view.addSubview(qrCodeFrameView!)
//        view.bringSubviewToFront(qrCodeFrameView!)
//
//    }
//
//    //ручная фокусировка
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let screenSize = view.bounds.size
//        if let touchPoint = touches.first {
//            let x = touchPoint.location(in: view).y / screenSize.height
//            let y = 1.0 - touchPoint.location(in: view).x / screenSize.width
//            let focusPoint = CGPoint(x: x, y: y)
//
//            if let device = captureDevice {
//                do {
//                    try device.lockForConfiguration()
//
//                    device.focusPointOfInterest = focusPoint
//                    device.focusMode = .autoFocus
//                    device.exposurePointOfInterest = focusPoint
//                    device.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
//                    device.unlockForConfiguration()
//                }
//                catch let error {
//                    print ("LockForConfiguration error: " + error.localizedDescription)
//                }
//            }
//        }
//    }
//
//    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//
//            captureSession?.stopRunning()
//            qrCodeFrameView?.isHidden = true
//            print ("got metadataObjects: \(metadataObjects)")
//
//            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//
//            //если засекли qr-код, то пытаемся получить по нему данные
//            if metadataObj.type == AVMetadataObject.ObjectType.qr {
//        }
//    }
    }

}
