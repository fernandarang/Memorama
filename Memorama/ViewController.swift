//
//  ViewController.swift
//  Memorama
//
//  Created by MacBookMBA5 on 13/01/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    @IBOutlet weak var Animacion: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        Animacion.loopMode = .loop
        Animacion.animationSpeed = 1.5
        Animacion.play()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

