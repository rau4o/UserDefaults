//
//  ViewController.swift
//  SaveDiplom
//
//  Created by rau4o on 4/10/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class Task: NSObject,NSCoding {
    let name: String
    let desc: String
    
    required init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(desc, forKey: "desc")
    }
    
    required init?(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as? String ?? ""
        self.desc = decoder.decodeObject(forKey: "desc") as? String ?? ""
    }
}

class ViewController: UIViewController {
    
    var tasks: [Task] = []
    
    let tableView = UITableView()
    
    let text1: UITextField = {
        let text = UITextField()
        text.backgroundColor = .gray
        text.textColor = .white
        return text
    }()
    
    let text2: UITextField = {
        let text = UITextField()
        text.backgroundColor = .gray
        text.textColor = .white
        return text
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Press to save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleButton(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layoutUI()
        configureTableView()
        if let data = UserDefaults.standard.data(forKey: "tasks") {
            tasks = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Task] ?? []
            tableView.reloadData()
        }
    }
    
    private func layoutUI() {
        view.addSubview(text1)
        view.addSubview(text2)
        view.addSubview(button)
        
        text1.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 100, paddingLeft: 50, paddingBottom: 0, paddingRight: 50, width: 0, height: 50)
        
        text2.anchor(top: text1.bottomAnchor, left: text1.leftAnchor, bottom: nil, right: text1.rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        button.anchor(top: text2.bottomAnchor, left: text2.leftAnchor, bottom: nil, right: text2.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func handleButton(_ sender: Any) {
        guard let name = text1.text, let desc = text2.text else {return}
        tasks.append(Task(name: name, desc: desc))
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: tasks), forKey: "tasks")
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let array = tasks[indexPath.row]
        cell.textLabel?.text = array.name
        cell.detailTextLabel?.text = array.desc
        
        return cell
    }
    
    
}

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimension(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
}


