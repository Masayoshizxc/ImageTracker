//
//  ViewController.swift
//  ImageTracker
//
//  Created by Adilet on 2/9/22.
//

import UIKit
import SceneKit
import ARKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate {

//    @IBOutlet var sceneView: ARSCNView!
    var sceneView: ARSCNView!
    var counter = 0
    private lazy var exitButton : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "xmark"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return btn
    }()
    private lazy var flash : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
        btn.tintColor = .white
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.white.cgColor
        btn.addTarget(self, action: #selector(tappedFlash), for: .touchUpInside)
        btn.layer.cornerRadius = 30
        return btn
    }()
    private lazy var playAV : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "play"), for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 30
        btn.layer.borderWidth = 3
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }()
    //load your scene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView()
        
        //add it to parents subview
        view.addSubview(sceneView)
        sceneView.addSubview(exitButton)
        sceneView.addSubview(flash)
        sceneView.addSubview(playAV)
        //add autolayout contstraints
//        view.addSubview(sceneView)
        setUpConstraints()
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.videoPlayer.currentItem, queue: .main) { [weak self] (notification) in
         
            self?.videoPlayer.seek(to: CMTime.zero)
        }
        sceneView.showsStatistics = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
     
        // Define reference images
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else {
            fatalError("Failed to load the reference images")
        }
     
        // Specify the images to track
        configuration.trackingImages = referenceImages
     
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
     
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
     
        // Detected plane
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = self.videoPlayer
     
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
     
        node.addChildNode(planeNode)
        
        self.videoPlayer.play()
        
        if let pointOfView = sceneView.pointOfView {
                let isVisible = sceneView.isNode(node, insideFrustumOf: pointOfView)
         
                if isVisible {
                    if videoPlayer.rate == 0.0 {
                        videoPlayer.play()
                    }
                }
            }
    }
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    let videoPlayer: AVPlayer = {
        // Load the video
        guard let url = Bundle.main.url(forResource: "kg", withExtension: "mp4") else {
            return AVPlayer()
        }
     
        return AVPlayer(url: url)
    }()
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func tappedFlash(){
        if (counter % 2 == 0){
            toggleTorch(on: true)
        }
        else{
            toggleTorch(on: false)
        }
        counter += 1
    }
    func toggleTorch(on: Bool) {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } 
    func setUpConstraints(){
        sceneView.snp.makeConstraints{make in
            make.top.left.right.bottom.equalToSuperview()
        }
        exitButton.snp.makeConstraints{make in
            make.top.equalToSuperview().inset(60)
            make.left.equalToSuperview().inset(50)
        }
        flash.snp.makeConstraints{make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.width.height.equalTo(60)
        }
        playAV.snp.makeConstraints{make in
            make.width.height.equalTo(60)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(150)
        }
    }
    
    
}
