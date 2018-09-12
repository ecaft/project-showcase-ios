//
//  TeamDetailViewController.swift
//  project-showcase-ios
//
//  Created by Sungmin Kim on 5/5/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit

class TeamDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    let screenSize : CGRect = UIScreen.main.bounds
    var tableView = UITableView()
    var headerView = UIView()
    var team: Team!
    var contact: Contact!
    var teamViewModel: TeamViewModel!
    
    //Table view properties
    var name = UILabel() //team name
    var isFavorite : Bool = false
    //var department = UILabel() //team's department >>IS THIS NEEDED??
    //var websiteButton = UIButton() //DO WE GET WEBSITE ADDRESSES PROVIDED?
    var teamInfo = UITextView()
    
    //Sections in tableview
    let sectionTitles : [String] = ["Contact"]
    var numOfSections = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAndStatusBarHeight = (self.navigationController?.navigationBar.frame.size.height)!+UIApplication.shared.statusBarFrame.height
        
        //set up tableview
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - navBarAndStatusBarHeight), style: UITableViewStyle.plain) //sets tableview to size of view below status bar and nav bar
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none //removes cell lines
        
        //Regsiter custom cells and xib files
        tableView.register(UINib(nibName: "ContactInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ContactInfoTableViewCell")
        
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createHeaderView() //put method in viewWillAppear so information updated depending on what company is tapped
    }
    
    func createHeaderView(){
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 200))
        tableView.tableHeaderView = headerView
        
        //Create name label
        name = UILabel(frame: CGRect(x: 0, y: 0, width: 116, height: 50)) //same x value as department so name & department label are aligned
        name.textAlignment = NSTextAlignment.left
        name.text = team.teamName
        name.font = UIFont(name: "Avenir-Roman", size: 36)
        
        //Make name into go into another line if necessary
        name.numberOfLines = 0 //set num of lines to infinity
        name.lineBreakMode = .byWordWrapping
        name.sizeToFit()
        self.tableView.tableHeaderView?.addSubview(name)
        
        //Create Favorites Button
        
        
        /* IS THIS NEEDED?
        //Create department label
        department = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 21))
        department.sizeToFit()
        department.textAlignment = NSTextAlignment.left
        department.font = UIFont(name: "Avenir-Light", size: 14)
        department.textColor = UIColor.ecaftDarkGray
         department.text = "Department: " + team.department
        self.tableView.tableHeaderView?.addSubview(department)
        */
        
        //Create Team Information textview
        teamInfo = UITextView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        teamInfo.textAlignment = NSTextAlignment.left
        teamInfo.text = team.descrip
        teamInfo.font = UIFont(name: "Avenir-Roman", size: 36)
        self.tableView.tableHeaderView?.addSubview(teamInfo)
        
        
    }
    
    
    /*****------------------------------TABLE VIEW METHODS------------------------------*****/
    //Section: Set number of sections and section headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //Section: Change font color and background color for section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.backgroundGray
        
        let label = UILabel(frame: CGRect(x: 0.05*screenSize.width, y: 0, width: screenSize.width, height: 25))
        label.center.y = 0.5*label.frame.height
        label.text = sectionTitles[section]
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        //label.textColor = .ecaftDarkGray
        
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    //Rows: Set num of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return team.contacts.count
    }
    
    //Rows: Set height for each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    //Table: Load in custom cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell", for: indexPath) as! ContactInfoTableViewCell
        
        /*
        //Remove left indent for text in cell
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        */
        
        //Removes grey highlight over cells
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //set up cell
        contact = team.contacts[indexPath.row]
        cell.contactName.text = contact.name
        cell.contactMajorYear.text = "\(contact.major) \(contact.gradYear)"
        cell.contactEmail.text = contact.email
        //cell.emailImage.image = UIImage(named: "starFilled")
        //cell.emailIcon.image = UIImage("emailIcon") //UPLOAD EMAIL IMAGE IN ASSETS
        
        return cell
    }
    
    
    //Table: Stop table cell turning grey when click on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
