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
    var team: Team!
    var teamViewModel: TeamViewModel!
    
    //Header View
    var headerView = UIView()
    var headerViewHeight : CGFloat = 400
    var nameTopOffset : CGFloat = 20
    var teamInfoTopOffset : CGFloat = 10
    var teamInfoBottomOffset : CGFloat = 15
    var headerViewPadding :CGFloat = 30
    
    //Table view properties
    var name = UILabel() //team name
    var isFavorite : Bool = false
    var favoritesButton = UIButton()
    //var department = UILabel() //team's department >>IS THIS NEEDED??
    //var websiteButton = UIButton() //DO WE GET WEBSITE ADDRESSES PROVIDED?
    var teamInfo = UITextView()
    
    //Sections in tableview
    let sectionTitles : [String] = ["Contacts"]
    var numOfSections = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBarAndStatusBarHeight = (self.navigationController?.navigationBar.frame.size.height)!+UIApplication.shared.statusBarFrame.height
        
        isFavorite = team.isFavorited
        
        //set up tableview
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - navBarAndStatusBarHeight), style: UITableViewStyle.plain) //sets tableview to size of view below status bar and nav bar
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none //removes cell lines
        tableView.backgroundColor = UIColor.backgroundGray
        
        //Regsiter custom cells and xib files
        tableView.register(UINib(nibName: "ContactInfoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ContactInfoTableViewCell")
        
        self.view.addSubview(self.tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createHeaderView() //put method in viewWillAppear so information updated depending on what company is tapped

        makeConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        teamInfo.setContentOffset(CGPoint.zero, animated: false)
        guard let headerView = tableView.tableHeaderView else {
            return
        }
        headerView.frame.size.height = headerViewHeight
        
        tableView.tableHeaderView = headerView
        tableView.layoutIfNeeded()
    }
    
    
    func createHeaderView(){
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 400))
        tableView.tableHeaderView = headerView
        
        //Create name label
        name = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80)) //same x value as department so name & department label are aligned
        name.textAlignment = NSTextAlignment.left
        name.text = team.teamName
        name.font = UIFont(name: "Avenir-Heavy", size: 50)
        name.textColor = UIColor.ecaftRed
        
        
        //Make name go into another line if necessary
        //name.numberOfLines = 0 //set num of lines to infinity
        //name.lineBreakMode = .byWordWrapping
        //name.sizeToFit()
        name.numberOfLines = 3
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.5
        
       
        name.translatesAutoresizingMaskIntoConstraints = true
        name.sizeToFit()
        
        self.tableView.tableHeaderView?.addSubview(name)
        
        //Create Favorites Button
        favoritesButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        favoritesButton.imageView?.contentMode = .scaleAspectFit
        favoritesButton.setImage(#imageLiteral(resourceName: "starUnfilled").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        favoritesButton.addTarget(self, action: #selector(TeamDetailViewController.favoritesButtonPressed(button:)), for: .touchUpInside)
        if isFavorite == true {
            favoritesButton.setImage(#imageLiteral(resourceName: "starFilled").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        }
        
        favoritesButton.tintColor = UIColor.ecaftGold
        
        
        self.tableView.tableHeaderView?.addSubview(favoritesButton)
        
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
        teamInfo = UITextView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 200))
        teamInfo.textAlignment = NSTextAlignment.left
        teamInfo.text = team.descrip
        teamInfo.font = UIFont(name: "Avenir-Light", size: 17)
        teamInfo.backgroundColor = UIColor.backgroundGray
        
        //make sure textview is not editable
        teamInfo.isEditable = false
        teamInfo.isSelectable = false
        teamInfo.isScrollEnabled = false
        
        adjustUITextViewHeight(arg: teamInfo)
        self.tableView.tableHeaderView?.addSubview(teamInfo)
        
        headerViewHeight = name.frame.size.height + teamInfo.frame.size.height + nameTopOffset + teamInfoTopOffset + teamInfoBottomOffset + headerViewPadding
        
        print("name height = \(name.frame.size.height); teamInfo height = \(teamInfo.frame.size.height); headerViewHeight = \(headerViewHeight)")
        
    }
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    
    
    private func makeConstraints() {
        /*
        companyIcon.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView).offset(47)
            make.left.equalTo(headerView).offset(20)
            make.right.lessThanOrEqualTo(location.snp.left).offset(-20)
            make.right.greaterThanOrEqualTo(location.snp.left).offset(-15).priority(.high)
            make.width.equalTo(90).priority(.medium)
            make.height.equalTo(90).priority(.medium)
        }*/
        name.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(headerView).offset(nameTopOffset)
            make.right.equalTo(headerView).offset(-20).priority(.required)
            make.left.equalTo(headerView).offset(20)
            make.width.lessThanOrEqualTo(headerView.frame.width)
        }
        teamInfo.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(name.snp.bottom).offset(teamInfoTopOffset)
            make.right.equalTo(headerView).offset(-20).priority(.required)
            make.left.equalTo(headerView).offset(20)
            make.width.lessThanOrEqualTo(headerView.frame.width)
            //make.bottom.equalTo(headerView).offset(-15)
        }
        favoritesButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(name.snp.bottom).offset(0)
            make.right.equalTo(name.snp.right).offset(0)
        }/*
        headerView.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(teamInfo.snp.bottom).offset(15)
        }
        
        segControl.snp.makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(websiteButton.snp.bottom).offset(20).priority(.required)
            make.bottom.greaterThanOrEqualTo(headerView.snp.bottom).offset(-20).priority(.required)
            make.centerX.equalTo(headerView.snp.centerX)
        }
        cameraButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(segControl.snp.right).offset(15)
            make.centerY.equalTo(segControl.snp.centerY)
            make.width.equalTo(23)
            make.height.equalTo(18)
        }
        */
    }
    
    @IBAction func favoritesButtonPressed(button: UIButton!){
        if isFavorite == false{
            isFavorite = true
            team.isFavorited = true //save new status
            favoritesButton.setImage(#imageLiteral(resourceName: "starFilled").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        } else {
            isFavorite = false
            team.isFavorited = false //save new status
            favoritesButton.setImage(#imageLiteral(resourceName: "starUnfilled").withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        }
    }
    
    
    /*****------------------------------TABLE VIEW METHODS------------------------------*****/
    //Section: Set number of sections and section headers
    func numberOfSections(in tableView: UITableView) -> Int {
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //Section: Change font color and background color for section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        //returnedView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 0.05*screenSize.width, y: 0, width: screenSize.width, height: 30))
        label.center.y = 0.5*label.frame.height
        label.text = sectionTitles[section]
        label.font = UIFont(name: "Avenir-Medium", size: 25)
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
        return 120
    }
    
    //Table: Load in custom cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoTableViewCell", for: indexPath) as! ContactInfoTableViewCell
        
        cell.backgroundColor = UIColor.backgroundGray
        /*
        //Remove left indent for text in cell
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        */
        
        //Removes grey highlight over cells
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //set up cell
        let contact = team.contacts[indexPath.row]
        cell.contactName.text = contact.name
        cell.contactMajorYear.text = "\(contact.major) \(contact.gradYear)"
        cell.contactEmail.text = contact.email
        cell.contactTitle.text = contact.title
        //cell.emailImage.image = UIImage(named: "starFilled")
        //cell.emailIcon.image = UIImage("emailIcon") //UPLOAD EMAIL IMAGE IN ASSETS
        
        //customize font
        cell.contactName.font = UIFont(name: "Avenir-Roman", size: 18)
        cell.contactMajorYear.font = UIFont(name: "Avenir-Light", size: 15)
        cell.contactEmail.font = UIFont(name: "Avenir-Light", size: 15)
        cell.contactTitle.font = UIFont(name: "Avenir-Light", size: 15)
        
        //make constraints
        let padding = 40
        let btwnPadding = 5
        cell.contactName.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cell.snp.top).offset(btwnPadding)
            make.right.equalTo(cell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(cell.snp.left).offset(padding)
            make.width.lessThanOrEqualTo(cell.frame.width)
        }
        cell.contactMajorYear.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cell.contactName.snp.bottom).offset(btwnPadding)
            make.right.equalTo(cell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(cell.snp.left).offset(padding)
            make.width.lessThanOrEqualTo(cell.frame.width)
        }
        cell.contactTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cell.contactMajorYear.snp.bottom).offset(btwnPadding)
            make.right.equalTo(cell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(cell.snp.left).offset(padding)
            make.width.lessThanOrEqualTo(cell.frame.width)
        }
        cell.contactEmail.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(cell.contactTitle.snp.bottom).offset(btwnPadding)
            make.right.equalTo(cell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(cell.snp.left).offset(padding)
            make.width.lessThanOrEqualTo(cell.frame.width)
        }
        
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
