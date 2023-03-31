//
//  GameViewController.swift
//  Memorama
//
//  Created by MacBookMBA5 on 17/01/23.
//

import UIKit
import Lottie

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
   // func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
   // }
    
    //func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    //}
    
    //MARK: -Outlets
    @IBOutlet weak var memoramaCollection: UICollectionView!
    @IBOutlet weak var tiempolbl: UILabel!
    @IBOutlet weak var pareslbl: UILabel!
    
    let uconfig : UserDefaults = UserDefaults.standard
    
    var lapsoTiempo : Int = 0
    var maxTiempo : Int = 3
    var reloj : Timer?
    var abierto : Int = -1
    
    var npares : Int = 0
    var ntiempo : Int = 0
    
    var resuelto : Int = 0
    
    var imagen : [UIImage] = [UIImage]()
    var matches : [Int:Int] = [Int:Int]()

    //MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        npares = uconfig.integer(forKey: "pares")
        ntiempo = uconfig.integer(forKey: "tiempo")
        
        npares = npares < 1 ? CONS.NPares : npares
        ntiempo = ntiempo < 1 ? CONS.NTiempo : ntiempo
        
        maxTiempo = ntiempo
        memoramaCollection.dataSource = self
        memoramaCollection.delegate = self
        
       // let layout = UICollectionViewFlowLayout()
        //layout.minimumLineSpacing = 20
        //layout.minimumInteritemSpacing = 20
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        countStart()
    }
    
    func countStart(){
        loadImages()
        
        let modal = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let animacion : LottieAnimationView = .init(name: "count2")
        
        animacion.loopMode = .playOnce
        animacion.contentMode = .scaleAspectFit
        animacion.animationSpeed = 0.7
        
        let swidth = view.bounds.width * 0.7
        animacion.frame=CGRect(x: 0, y: 0,width: swidth,height: swidth)
        animacion.backgroundColor = UIColor(red: 0.20392, green: 0.56471, blue: 0.86275, alpha: 1.0)
        
        let hc = NSLayoutConstraint(item: modal.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: swidth)
        let vc = NSLayoutConstraint(item: modal.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: swidth)
        
        modal.view.addConstraint(hc)
        modal.view.addConstraint(vc)
        modal.view.addSubview(animacion)
        
        present(modal, animated: true,completion: nil)
        animacion.play(completion: {(completed) in
            if !completed{
                return
            }
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
                (tt : Timer) in
                if self.imagen.count == self.npares{
                    tt.invalidate()
                    modal.dismiss(animated: true,completion: nil)
                    self.comenzarJuego()
                }
            })
        })
    }
    
    func comenzarJuego(){
        resuelto = 0
        lapsoTiempo = 0

        tiempolbl.text = String(maxTiempo)
        pareslbl.text = String(0)
        
        //Generar las parejas
        getMatches()
        //Recargar datos en la vista
        self.memoramaCollection.reloadData()
        
        memoramaCollection.isUserInteractionEnabled = true
        
        reloj = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: {(timer :Timer) in
            self.timeStep()
        })
    }
    
    func getMatches (){
        var src : [Int] = Array<Int>(0..<npares*2)
        matches.removeAll()
        
        while src.count > 1{
            src.shuffle()
            let e1 = src.popLast()!
            let e2 = src.popLast()!
            
            matches[e1] = e2
            matches[e2] = e1
        }
    }
    
    func timeStep(){
        lapsoTiempo += 1
        tiempolbl.text = String(maxTiempo-lapsoTiempo)
        if (lapsoTiempo == maxTiempo) {
            stopGame()
            showFinished(title: "¡Lo sentimos!", msg: "Se agotó el tiempo, pero conseguiste encontrar \(resuelto) de \(npares) parejas")
        }
    }
    
    func stopGame(){
        reloj?.invalidate()
        
        memoramaCollection.isUserInteractionEnabled = false
    }
    
    func showFinished(title:String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction.init(title: "Jugar de Nuevo", style: .default, handler: {_ in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.comenzarJuego()
            
        }))
        alert.addAction(UIAlertAction.init(title: "Pantalla Principal", style: .cancel, handler: {_ in
            
            alert.dismiss(animated: true, completion: nil)
            
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func loadImages(){
        for _ in 0..<npares{
            let rand = Int.random(in: 1...999)
            let url = "https://source.unsplash.com/random?\(rand)"
            
            loadImageFromUrl(surl: url)
        }
    }
    func loadImageFromUrl(surl: String){
        guard let url = URL(string: surl) else{
            print("Error con la URL: \(surl)")
            return
        }
        let task = URLSession.shared.dataTask(with: url){
            (data,resp,error) in
            
            if let error = error{
                print("Error [\(error.localizedDescription)] obteniendo \(surl)")
                return
            }
            
            guard let data = data else{
                print("No obtuvimos datos de la red")
                return
            }
            self.imagen.append(UIImage(data: data)!)
        }
        task.resume()
    }
    
    func finishGame(){
        stopGame()
        showFinished(title: "¡Lo lograste!", msg: "Conseguiste encontrar las \(npares) parejas en \(lapsoTiempo) segundos")
    }
    // MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
        UIView.transition(with: cell.contentView, duration: 0.3, options: .transitionFlipFromLeft, animations: {() in
            cell.backView.isHidden = !cell.backView.isHidden
            cell.frontView.isHidden = !cell.frontView.isHidden
        }, completion: nil)
        
        if abierto == indexPath.item{
            abierto = -1
            
            return
        }
        
        if abierto < 0{
            abierto = indexPath.item
            
            return
        }
        let cell2 = collectionView.cellForItem(at: IndexPath.init(item: abierto, section: 0)) as! ItemCollectionViewCell
        
        if abierto == cell.match {
            cell.resuelto = true
            cell2.resuelto = true
            
            resuelto += 1
            
            pareslbl.text = String(resuelto)
            
            if resuelto == (npares) {
                finishGame()
            }
            abierto = -1
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {_ in
            UIView.transition(with: cell.contentView, duration: 0.4, options: .transitionFlipFromLeft,animations: {()in
                cell.backView.isHidden = false
                cell2.backView.isHidden = false
                
                cell.frontView.isHidden = true
                cell2.frontView.isHidden = true
            }, completion: nil)
        })
        abierto = -1
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath) as! ItemCollectionViewCell
        
        return !cell.resuelto
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ItemCollectionViewCell
        
        cell.match = matches[indexPath.item]!
        cell.resuelto = false
        
        cell.backView.isHidden = false
        cell.frontView.isHidden = true
        
        let idx = indexPath.item < cell.match ? indexPath.item : cell.match
        
        cell.frontView.image = self.imagen[idx%npares]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hvsize = UICollectionViewFlowLayout()
        //if npares == 2{
           // hvsize.itemSize = CGSize(width: (view.frame.size.width/2)-150, height: (view.frame.size.width/2)-150)
       // }
        //if npares == 3{
           // hvsize.itemSize = CGSize(width: (view.frame.size.width/3)-100, height: (view.frame.size.width/3)-100)
       // }

        hvsize.itemSize = CGSize(width: (view.frame.size.width/3)-2, height: (view.frame.size.width/3)-2)
        return hvsize.itemSize
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
