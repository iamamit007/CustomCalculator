//
//  ViewController.swift
//  CustomCalculator
//
//  Created by Amit on 08/08/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController ,UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var uppviewTopMargin: NSLayoutConstraint!
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 2,
        minimumLineSpacing: 2,
        sectionInset: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2),
        hei : 120
        
    )
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var upperview: UIView!
    let inset: CGFloat = 2
    let minimumLineSpacing: CGFloat = 2
    let minimumInteritemSpacing: CGFloat = 0
    let cellsPerRow = 3
   
    var valueA: Double = 0
    var valueB: Double = 0
    var currentOperator: String = ""
    var refreshTextField: Bool = true
    
    var player = AVAudioPlayer()
    
    @IBOutlet weak var digitCell: UICollectionView!
    
    @IBOutlet weak var solutionviewparentheight: NSLayoutConstraint!
    
    var digit_array = ["7","8","9","CE","CL","4","5","6","%","/","1","2","3","^","*","0",".","-","+","="]
    let charset: Set<Character> = ["%", "/","^",".","-","+"]
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        digitCell.dataSource = self
        digitCell.delegate  = self
        displayLabel.text = "0"
        print(UIDevice.current.orientation.isPortrait)
        print(self.solutionviewparentheight.constant)
        print(upperview.frame.height)
     
     
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return digit_array.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DigitsViewCell
        print(digit_array[indexPath.row])
        if UIDevice.current.orientation.isLandscape {
            cell.topdistance.constant = 10
        }
        else{
            cell.topdistance.constant = 20
        }
        cell.label.text = digit_array[indexPath.row]
        if(indexPath.row == 3 || indexPath.row == 4){
             cell.contentView.backgroundColor = hexStringToUIColor(hex:"F09737" )
        }else if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 13 || indexPath.row == 14 || indexPath.row == 16 || indexPath.row == 17 || indexPath.row == 18){
            
             cell.contentView.backgroundColor = hexStringToUIColor(hex:"D7D7D7" )//D7D7D7
        }else
        {
            cell.contentView.backgroundColor = hexStringToUIColor(hex:"E7E7E7")
        }
        return cell
        

    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("pppppp--->",indexPath.row)
        playSound()
        var value = digit_array[indexPath.row]
        // get current text
        var currentText = ""
        
        // value shourld be refreshed?
        if displayLabel.text != "0" && (!refreshTextField ) {
            currentText = displayLabel.text!
        }
        
        // zero
        if currentText == "0" && value == "0" {
            value = ""
        }
        
        // period
        if value == "." {
            if currentText == "" {
                value = "0."
            } else if currentText.range(of: ".") != nil {
                value = ""
            }
        }
       
        
        if (Double(digit_array[indexPath.row]) != nil){
        
            // update text field
            refreshTextField = false
            displayLabel.text = "\(currentText)\(value)"
            
        }
        
        if(Double(digit_array[indexPath.row]) == nil){
            
            if(digit_array[indexPath.row] == "CE"){
               let texttoshow =  displayLabel.text
                if(texttoshow!.count > 1){
                    displayLabel.text = String(texttoshow!.dropLast())
                }else{
                    displayLabel.text = "0"
                }
                
                return
            }
            
            if(digit_array[indexPath.row] == "CL"){
               
                displayLabel.text = "0"
                return
            }
            if(digit_array[indexPath.row] == "."){
                
                
                  let texttoshow =  displayLabel.text
                if(texttoshow == "0"){
                   // displayLabel.text = "0."
                }else{
                    if texttoshow!.contains(".") {
                        displayLabel.text = "0"
                    }else{
                        displayLabel.text = "\(texttoshow!)."
                    }
                }
                
                
                return
            }
            if(digit_array[indexPath.row] == "%"){
                let texttoshow = displayLabel.text!
                let pertange = (Double(texttoshow) ?? 0) / 100
                 displayLabel.text = "\(pertange)"
                return
            }
            
            let newOperator = digit_array[indexPath.row]
            // refresh text field
            refreshTextField = true
            
            // ignore if text field is empty
            if displayLabel.text != "" {
                // get new operator
                let newOperator = digit_array[indexPath.row]
                // refresh text field
                refreshTextField = true
                print("999999999======>",displayLabel.text)
                if currentOperator == "" && newOperator != "="{
                    // copy current value
                    valueA = Double(displayLabel.text!)!
                    
                    // update operator
                    currentOperator = newOperator
                } else {
                    // copy current value
                    valueB = Double(displayLabel.text!)!
                    
                    // perform operation
                    var result: Double = 0
                    switch currentOperator {
                    case "+":
                        result = (valueA + valueB)
                    case "-":
                        result = (valueA - valueB)
                    case "*":
                        result = (valueA * valueB)
                    case "/":
                        result = (valueA / valueB)
                    case "^":
                        result = (pow(Double(valueA),Double(valueB))).rounded(.down)
                    default:
                        result = valueB
                    }
                    
                    if currentOperator != "" {
                        // construct history entry
                        let historyEntry: String = "\(valueA) \(currentOperator) \(valueB) = \(result)\n"
                        // update history
                        displayLabel.text! += historyEntry
                    }
                    
                    // update operator & values
                    currentOperator = ""
                    valueA = 0
                    valueB = 0
                    
                    if newOperator != "=" {
                        valueA = result
                        currentOperator = newOperator
                    }
                    
                    // update text field
                    displayLabel.text = String(result)
                }
            }
        }
            
    }
    
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.digitCell.collectionViewLayout.invalidateLayout()
        }, completion: nil)
        
        if UIDevice.current.orientation.isLandscape {
            print("landscape")
            
             self.solutionviewparentheight.constant = 100
            digitCell.reloadData()
        } else {
            digitCell.reloadData()
            self.solutionviewparentheight.constant = 150
            print("portrait")
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isPortrait{

            let width = (self.digitCell.frame.size.width - 20) / 4.5 //some width
            let height = width * 1.00 //ratio
            let w = self.digitCell.frame.size.width/5.5
            if(digit_array[indexPath.row] == "="){
                return CGSize(width: self.digitCell.frame.width - 15, height: w * 1.2)
            }
            if(digit_array[indexPath.row] == "0"){
                return CGSize(width: (w - 0) * 2.05 , height: w * 1.45)
            }
            //return CGSize(width: width, height: height)
            return CGSize(width: self.digitCell.frame.size.width/5.5, height: w * 1.45)

        }else{
            let width = (self.digitCell.frame.size.width - 30) / 4.0 //some width
            let height = width / 3.8 //ratio
             let w = self.view.frame.size.width/5.5
            if(digit_array[indexPath.row] == "="){
                return CGSize(width: self.digitCell.frame.width - 15, height: height)
            }
            if(digit_array[indexPath.row] == "0"){
                return CGSize(width: (w - 0) * 2.09 , height: height)
            }
            return CGSize(width: w, height: height)

        }

    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Tick", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
  

}

