//
//  ViewController.swift
//  8 Ball Magic
//
//  Created by Игорь Антонченко on 17.10.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var answerLable: UILabel!
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("answers.plist")
    var answersOffline = ["Yes", "No", "Try again"]
    let requestURL = "https://8ball.delegator.com/magic/JSON/myQuestion"
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    //MARK: - Handlers of motion
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == UIEvent.EventSubtype.motionShake {
            answerLable.text = ""
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == UIEvent.EventSubtype.motionShake {
            performRequest(URLString: requestURL)
        }
    }
    
    //MARK: - Perform request
    func performRequest(URLString: String) {
    
        if let url = URL(string: URLString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {[weak self] (data, response, error) in
                guard let self = self else { return }
                if error != nil {
                    DispatchQueue.main.async {
                        self.answerLable.text = self.answersOffline.randomElement()
                    }
                    return
                }
                if let safeData = data {
                    self.parseJSON(receivedData: safeData)
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Parse data from server
    func parseJSON(receivedData: Data) {
        let decoder = JSONDecoder()
   //     guard let decodedData = try? decoder.decode(ReceivedData.self, from: receivedData) else { return }
        do {
            let decodedData = try decoder.decode(ReceivedData.self, from: receivedData)
            let answer = decodedData.magic.answer
    
            DispatchQueue.main.async {
                self.answerLable.text = answer
            }
        } catch  {
          print(error)
        }
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let destinationVC = segue.destination as! AnswersTableViewController
            
            destinationVC.answers = answersOffline
            destinationVC.dataFilePath = dataFilePath
            
        }
    }
    
    //MARK: - Load data from memory
    func loadData() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            do {
                let decoder = PropertyListDecoder()
                answersOffline = try decoder.decode([String].self, from: data)
            }catch {
               print(error)
            }
        }
                
    }
    


}

