//
//  HomeViewController.swift
//  ImageTracker
//
//  Created by Adilet on 3/9/22.
//

import UIKit
import SnapKit
import AVFoundation

class HomeViewController: UIViewController {
    var counter = 0
//    private lazy var flash : UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
//        btn.tintColor = .systemOrange
//        btn.layer.borderWidth = 3
//        btn.layer.borderColor = UIColor.systemOrange.cgColor
//        btn.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
//        btn.layer.cornerRadius = 30
//        return btn
//    }()
    private lazy var trackButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemOrange
        btn.setTitle("Start Tracking", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 25)
        btn.addTarget(self, action: #selector(tappedTrack), for: .touchUpInside)
        return btn
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setUpConstraints()
    }
    
    func addSubviews(){
//        view.addSubview(flash)
        view.addSubview(trackButton)
    }
    
    
    @objc func tappedTrack(){
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
//    @objc func tappedFlash(){
//        if (counter % 2 == 0){
//            toggleTorch(on: true)
//        }
//        else{
//            toggleTorch(on: false)
//        }
//        counter += 1
//    }
    
//    func toggleTorch(on: Bool) {
//        guard
//            let device = AVCaptureDevice.default(for: AVMediaType.video),
//            device.hasTorch
//        else { return }
//
//        do {
//            try device.lockForConfiguration()
//            device.torchMode = on ? .on : .off
//            device.unlockForConfiguration()
//        } catch {
//            print("Torch could not be used")
//        }
//    }
    func setUpConstraints(){
//        flash.snp.makeConstraints{make in
//            make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().inset(100)
//            make.width.height.equalTo(60)
//        }
        trackButton.snp.makeConstraints{make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
    }
}
