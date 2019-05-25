//
//  CoursesController.swift
//  CurrencyCoures
//
//  Created by Paul Frol on 19/05/2019.
//  Copyright © 2019 Paul Frol. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController {

    @IBAction func refreshButton(_ sender: Any) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "startLoadingXML"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                activityIndicator.startAnimating()
                activityIndicator.color = UIColor.blue
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "dataRefreshed"), object: nil, queue: nil) { (notification) in
            
            DispatchQueue.main.async {
                self.navigationItem.title = Model.shared.currentDate
                self.tableView.reloadData()
                let pushBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
                self.navigationItem.rightBarButtonItem = pushBarButton
                print("notification catch.")
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("errorWhenXMLLoading"), object: nil, queue: nil) { (notification) in
            let errorName = notification.userInfo?["ErrorName"]
            print(errorName ?? "erorr!")
            
            let alertController = UIAlertController(title: "Alert", message: errorName as? String, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                let pushBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
                self.navigationItem.rightBarButtonItem = pushBarButton
            }
        }
        navigationItem.title = Model.shared.currentDate
        Model.shared.loadXMLFile(date: nil)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        Model.shared.loadXMLFile(date: nil)
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CourseCell
        
        let courseForCell = Model.shared.currencies[indexPath.row]
        
        cell.initCell(currency: courseForCell)
        
//        cell.textLabel?.text = courseForCell.Name
//        cell.detailTextLabel?.text = courseForCell.Value
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
