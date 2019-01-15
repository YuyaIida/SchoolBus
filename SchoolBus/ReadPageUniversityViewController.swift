//
//  ReadPageUniversityViewController.swift
//  UISample
//
//  Created by k16005kk on 2018/08/03.
//  Copyright © 2018年 AIT. All rights reserved.
//

import UIKit

class ReadPageUniversityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var readUniversityTableview: UITableView!
    var searchResults:[String] = []
    
    var readPageUniversityTimeData = Timedata()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readUniversityTableview.delegate = self
        readUniversityTableview.dataSource = self
        
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        searchResults = university
        
        let alert: UIAlertController = UIAlertController(title: "閲覧画面です", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        return;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "大学"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readPageUniversityTimeData.university = searchResults[indexPath.row]
        
        let storyboard: UIStoryboard = self.storyboard!
        let readStopoverVC = storyboard.instantiateViewController(withIdentifier: "ReadPageStopover") as! ReadPageStopoverViewController
        
        readStopoverVC.readPageStopoverTimedata = readPageUniversityTimeData
        
        self.navigationController?.pushViewController(readStopoverVC, animated: true)
        
        readUniversityTableview.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        searchResults.removeAll()
        
        if searchBar.text == "" {
            searchResults = university
            
        } else {
            for data in university {
                if data.contains(searchBar.text!) {
                    searchResults.append(data)
                }
            }
        }
        
        readUniversityTableview.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResults = university
        readUniversityTableview.reloadData()
    }
    
    
    
}
