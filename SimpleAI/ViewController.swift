//
//  ViewController.swift
//  SimpleAI
//
//  Created by Johnny Perdomo on 10/2/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit
import AI

class ViewController: UIViewController {

    
    let messagesTableView: UITableView = {
        let messagesTableView = UITableView()
        messagesTableView.register(MessagesViewCell.self, forCellReuseIdentifier: "cellId")
        messagesTableView.translatesAutoresizingMaskIntoConstraints = false
        messagesTableView.isScrollEnabled = true
        
        
        return messagesTableView
    }()
    
    private let pageTitle: UILabel = {
        let pageTitle = UILabel()
        pageTitle.translatesAutoresizingMaskIntoConstraints = false
        pageTitle.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        
        let attributedText = NSMutableAttributedString(string: "Smart A.I. Chat", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
        
        pageTitle.attributedText = attributedText
        return pageTitle
    }()
    
    var messagesArray = [
        MessageModel(content: "Hey What's Up, Ask me Something. I'm Super Smart", id: "agent")
    ]
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageField: UITextField!
    
    @IBAction func sendBtnClicked(_ sender: Any) {
        if messageField.text != nil && messageField.text != "" {
            queryResponse(query: messageField.text!)
            messagesArray.append(MessageModel(content: messageField.text!, id: "user"))
            messagesTableView.reloadData()
            messageField.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        messagesTableView.separatorStyle = .none
        messagesTableView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        messagesTableView.rowHeight = UITableView.automaticDimension
        messagesTableView.estimatedRowHeight = 200
        
        view.addSubview(messagesTableView)
        view.addSubview(pageTitle)
        
        messagesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        messagesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messagesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        messagesTableView.bottomAnchor.constraint(equalTo: messageField.topAnchor, constant: -20).isActive = true
        
        pageTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        pageTitle.bottomAnchor.constraint(equalTo: messagesTableView.topAnchor, constant: -18).isActive = true

    }
    
    func queryResponse(query: String) {
        AI.sharedService.textRequest(query).success { (response) in
            
            if let speech = response.result.fulfillment?.speech {
                self.messagesArray.append(MessageModel(content: speech, id: "agent"))
                self.messagesTableView.reloadData()
                print(response)
                
            }
            }.failure { (error) in
                print(error)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 40
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MessagesViewCell
        
        let message = messagesArray[indexPath.row]
        cell.message = message
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 10
        return cell
    }
    

}
