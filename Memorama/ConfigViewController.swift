//
//  ConfigViewController.swift
//  Memorama
//
//  Created by MacBookMBA5 on 17/01/23.
//

import UIKit
import Toaster

class ConfigViewController: UIViewController {

    
    @IBOutlet weak var Pareslbl: UILabel!
    
    @IBOutlet weak var Tiempolbl: UILabel!
    
    @IBOutlet weak var TiempoSlider: UISlider!
    
    @IBOutlet weak var ParesStepper: UIStepper!
    
    
    
    let uconfig : UserDefaults = UserDefaults.standard
    var npares : Int = CONS.NPares
    var ntiempo : Int = CONS.NTiempo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        npares = uconfig.integer(forKey: "pares")
        ntiempo = uconfig.integer(forKey: "tiempo")
        
        npares = npares < 1 ? CONS.NPares : npares
        ntiempo = ntiempo < 1 ? CONS.NTiempo : ntiempo
        
        Tiempolbl.text = String(ntiempo)
        TiempoSlider.value = Float(ntiempo)
        
        Pareslbl.text = String(npares)
        ParesStepper.value = Double(npares)

        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func editarPares(_ sender: UIStepper) {
        Pareslbl.text = String(Int(sender.value))
    }
    
    @IBAction func editarTiempo(_ sender: UISlider) {
        Tiempolbl.text = String(Int(sender.value))
    }
    
    @IBAction func guardarConfig(_ sender: UIButton) {
        
        uconfig.setValue(Int(ParesStepper.value), forKey: "pares")
        uconfig.setValue(Int(TiempoSlider.value), forKey: "tiempo")
        
        Toast(text: "Configuración guardada").show()
        
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
