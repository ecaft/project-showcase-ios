//
//  BrowseViewController.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class BrowseViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,
    AddRemoveDelegate, FilterSelectionProtocol {
    
    //Database Variables
    var databaseRef: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    var databaseHandle_contacts: DatabaseHandle!
    
    func unstar(team: Team) {
        teamTableView.reloadData()
    }
    
    func star(team: Team) {
        teamTableView.reloadData()
    }

    let screenSize : CGRect = UIScreen.main.bounds
    var teamViewModel: TeamViewModel!
    var filterViewModel: FilterViewModel?
    var selectedFilterSects: [FilterSection]?
    var searchBar: UISearchBar!
    var teamTableView = UITableView()

    
    //Segmented Control
    let segmentTitles : [String] = ["All Teams", "M.Eng", "Undergrad"]
    var segControl = UISegmentedControl()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Showcase"
        self.view.backgroundColor = UIColor.backgroundGray
        
        // Do any additional setup after loading the view.
        makeFilterBtn()
        makeSearchBar()
        makeSegControl()
        makeTableView()
        
        // Load data from firebase
        databaseRef = Database.database().reference()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        toggleFilterBtnText()
        // Apply selected filters
        if let selectedFilterSects = selectedFilterSects {
            teamViewModel?.applyFilters(filterSections: selectedFilterSects)
            teamTableView.reloadData()
        }
        makeFilterBtn()
        teamTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disable top bounce on filterView
        scrollView.bounces = scrollView.contentOffset.y > 0
        scrollView.showsVerticalScrollIndicator = true
    }
    
    func loadData() {
        //Retrive posts and listen for changes
        databaseHandle = databaseRef?.child("teams").observe(.value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let team = Team()
                team.teamName = item.childSnapshot(forPath: StringDict.teamName.rawValue).value as! String
                team.descrip = item.childSnapshot(forPath: StringDict.descrip.rawValue).value as! String
                team.teamType = item.childSnapshot(forPath: StringDict.teamType.rawValue).value as! String
                team.table = item.childSnapshot(forPath: StringDict.table.rawValue).value as! String
                let majors = item.childSnapshot(forPath: StringDict.majors.rawValue).value as! String
                team.majors = majors.components(separatedBy: ", ")
                
                if team.teamType == "Undergrad" {
                    self.teamViewModel?.addTeamToProjectTeams(team)
                }
                if team.teamType == "MEng" {
                    self.teamViewModel?.addTeamtoMengTeams(team)
                }
                
                self.teamViewModel?.addTeamToAllTeams(team)
                self.teamViewModel?.addTeamToDisplayedTeams(team)
            }
        })
        databaseHandle_contacts = databaseRef?.child("contacts").observe(.value, with: { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let contact = Contact()
                contact.name = item.childSnapshot(forPath: StringDict.contactName.rawValue).value as! String
                contact.major = item.childSnapshot(forPath: StringDict.major.rawValue).value as! String
                contact.gradYear = item.childSnapshot(forPath: StringDict.gradYear.rawValue).value as! String
                contact.email = item.childSnapshot(forPath: StringDict.email.rawValue).value as! String
                contact.teamName = item.childSnapshot(forPath: StringDict.teamName.rawValue).value as! String
                contact.teamType = item.childSnapshot(forPath: StringDict.teamType.rawValue).value as! String
                
                self.teamViewModel.addContactToTeam(teamName: contact.teamName, teamType: contact.teamType, contact: contact)
            }
            self.teamTableView.reloadData()
        })
        
    }
    
    /*** -------------------- FILTER BUTTON ----------------------***/
    @objc func filterButtonTapped() {
        var filterViewModel: FilterViewModel
        if (self.filterViewModel != nil) {
            filterViewModel = self.filterViewModel!
        }
        else {
            self.filterViewModel = FilterViewModel()
            filterViewModel = self.filterViewModel!
        }
        let filtersVC = FiltersViewController(filterViewModel: filterViewModel)
        filtersVC.filterSelectionDelegate = self
        self.navigationController?.pushViewController(filtersVC, animated: true)
    }
    
    // Set selected filters to filters selected from Filters VC
    func setSelectedFiltersTo(filtersSent: [FilterSection]) {
        self.selectedFilterSects = filtersSent
    }
    
    // Updatedfilter bar button text
    private func toggleFilterBtnText() {
        let btnText = (filterViewModel?.isFiltersOn() ?? false) ? "Filters On" : "Filters Off"
        self.navigationItem.rightBarButtonItem?.title = btnText
    }
    
    private func makeFilterBtn() {
        let btnText = (filterViewModel?.isFiltersOn() ?? false) ? "Filters On" : "Filters Off"
        let filterButton = UIBarButtonItem(title: btnText, style: .plain, target: self, action: #selector(filterButtonTapped))
        self.navigationItem.rightBarButtonItem = filterButton
    }

    
    /*** -------------------- SEARCH BAR -------------------- ***/
    // Called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        teamViewModel?.applySearch(searchText: searchText)
        teamTableView.reloadData()
        
        // If clear button pressed
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
            view.endEditing(true)
            
            teamViewModel?.clearSearchBarTeams()
            teamViewModel?.resetDisplayedTeams()
            teamTableView.reloadData()
        }
    }
    
    // When cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        view.endEditing(true)
        
        teamViewModel?.clearSearchBarTeams()
        teamViewModel?.resetDisplayedTeams()
        teamTableView.reloadData()
    }
    
    // When done button is pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard.
        view.endEditing(true)
    }
    
    // When search bar is pressed
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    // When keyboard return is pressed
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        view.endEditing(true)
    }
    
    private func makeSearchBar() {
        // Make UISearchBar instance
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.frame = CGRect(x: 0, y: 0, width: screenSize.width-12, height: 36)
        
        // Style & color
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.tintColor = UIColor.ecaftRed
        
        // Buttons & text
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.placeholder = "Search"
        searchBar.showsBookmarkButton = false
        searchBar.showsSearchResultsButton = false
        searchBar.showsCancelButton = false
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view).offset(6)
            make.left.equalTo(view).offset(6)
            make.right.equalTo(view).offset(-6)
            make.centerX.equalTo(view)
        }
    }

    /*** -------------------- SEGMENTED CONTROL -------------------- ***/
    private func makeSegControl(){
        segControl = UISegmentedControl(items: segmentTitles)
        segControl.selectedSegmentIndex = 0
        
        segControl.frame = CGRect(x: 0, y:searchBar.frame.maxY, width: screenSize.width-32, height: 29)
        segControl.layer.cornerRadius = 5.0
        segControl.backgroundColor = UIColor.white
        segControl.tintColor = UIColor.ecaftRed
        let segFont = UIFont(name: "Avenir-Book", size: 13) ?? .systemFont(ofSize: 15)
        segControl.setTitleTextAttributes([NSAttributedStringKey.font: segFont],
                                          for: .normal)
        segControl.addTarget(self, action: #selector(BrowseViewController.segmentControlHandler(sender:)), for: .valueChanged)
        
        view.addSubview(segControl)
        segControl.snp.makeConstraints{(make) -> Void in
            make.left.equalTo(searchBar).offset(10)
            make.right.equalTo(searchBar).offset(-10)
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.centerX.equalTo(searchBar)
        }
    }
    
    @IBAction func segmentControlHandler(sender: UISegmentedControl){
        //Handler for when custom Segmented Control changes and will change the content of the following table depending on the value selected
        print("Selected segment index is: \(sender.selectedSegmentIndex)")
        teamTableView.reloadData()
    }
    
    
    /*** -------------------- TABLE VIEW -------------------- ***/
    private func makeTableView() {
        //Total height of nav bar, status bar, tab bar
        //let barHeights = (self.navigationController?.navigationBar.frame.size.height)!+UIApplication.shared.statusBarFrame.height + 100
        
        //edited CGRect to make margins and center it
        teamTableView = UITableView(frame: CGRect(x: 0, y: segControl.frame.maxY+45, width: screenSize.width-28, height: screenSize.height - (segControl.frame.maxY+45)), style: UITableViewStyle.plain) //sets tableview to size of view below status bar and nav bar
        
        // UI
        teamTableView.backgroundColor = UIColor.backgroundGray
        teamTableView.separatorStyle = UITableViewCellSeparatorStyle.none // Removes bottom border for cells
        //teamTableView.contentInset = UIEdgeInsetsMake(-27, 0, 0, 0) // Removes padding above first cell
        
        //Remove vertical scroll bar
        teamTableView.showsVerticalScrollIndicator = false;
        
        teamTableView.dataSource = self
        teamTableView.delegate = self
        
        //Regsiter custom cells and xib files
        teamTableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamTableViewCell")
        
        //layout
        teamTableView.center.x = view.center.x
        
        view.addSubview(teamTableView)
        
        /*
        teamTableView.snp.makeConstraints{(make) -> Void in
            //make.left.equalTo(segControl).offset(8)
            //make.right.equalTo(segControl).offset(-8)
            make.top.equalTo(segControl.snp.bottom).offset(16)
            make.bottom.equalTo(view)
            make.centerX.equalTo(segControl)
        }*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        guard let teamViewModel = teamViewModel else {
            return 0
        }
        var numOfRows = teamViewModel.allTeams.count
        
        switch(segControl.selectedSegmentIndex){
            case 1: //M.Eng Teams
                numOfRows = teamViewModel.mengTeams.count
            
            case 2: //Undergrad Project Teams
                numOfRows = teamViewModel.projectTeams.count
            
            default: //Default: All Teams
                numOfRows = teamViewModel.displayedTeams.count
        }
       return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //set up customCell
        guard let customCell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier) as? TeamTableViewCell else {
            print("BrowseViewController.swift - cellForRowAt method:  Team Table View dequeuing cell error")
            return UITableViewCell()
        }
        customCell.delegate = self
        customCell.backgroundColor = UIColor.white
        customCell.contentView.layer.borderWidth = 2    //set cell borders
        
        let myColor : UIColor = UIColor(red:0.61, green:0.15, blue:0.12, alpha:1.0)
        customCell.contentView.layer.borderColor = myColor.cgColor
        customCell.selectionStyle = .none   //Stops cell turning grey when click on it
        
        //customize font
        customCell.nameLabel.font = UIFont(name: "Avenir-Heavy", size: 24)
        customCell.tableLabel.font = UIFont(name: "Avenir-Light", size: 15)
        
        //make favorites star yellow
        customCell.starButton.tintColor = UIColor.ecaftGold
        customCell.starButton.imageView?.contentMode = .scaleAspectFit
        
        //make contraints
        let padding = 20
        let btwnPadding = 5
        let leftPadding = 60
        customCell.nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(customCell.snp.top).offset(padding)
            make.right.equalTo(customCell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(customCell.snp.left).offset(leftPadding)
            make.width.lessThanOrEqualTo(customCell.frame.width)
        }
        customCell.tableLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(customCell.nameLabel.snp.bottom).offset(btwnPadding)
            make.right.equalTo(customCell.snp.right).offset(-padding).priority(.required)
            make.left.equalTo(customCell.snp.left).offset(leftPadding)
            make.width.lessThanOrEqualTo(customCell.frame.width)
        }
        customCell.starButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(customCell.snp.top).offset(40)
            make.right.equalTo(customCell.nameLabel.snp.left).offset(-padding)
            make.left.equalTo(customCell.snp.left).offset(padding).priority(.required)
    
        }
        
        switch(segControl.selectedSegmentIndex){
            case 1:     //M.Eng Teams
                let team = teamViewModel.mengTeams[indexPath.row]
                customCell.teamForThisCell = team
                customCell.name = team.teamName
                customCell.table = team.table
            
                if (team.isFavorited) {
                    customCell.img = #imageLiteral(resourceName: "starFilled")
                } else {
                    customCell.img = #imageLiteral(resourceName: "starUnfilled")
                }
                return customCell
            case 2:     //Undergrad Project Teams
                let team = teamViewModel.projectTeams[indexPath.row]
                customCell.teamForThisCell = team
                customCell.name = team.teamName
                customCell.table = team.table
            
                if (team.isFavorited) {
                    customCell.img = #imageLiteral(resourceName: "starFilled")
                } else {
                    customCell.img = #imageLiteral(resourceName: "starUnfilled")
                }
                return customCell
        
            default:    //Default: All Teams
                let team = teamViewModel.displayedTeams[indexPath.row]
                customCell.teamForThisCell = team
                customCell.name = team.teamName
                customCell.table = team.table
            
                if (team.isFavorited) {
                    customCell.img = #imageLiteral(resourceName: "starFilled")
                } else {
                    customCell.img = #imageLiteral(resourceName: "starUnfilled")
                }
                return customCell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        let teamDetailVC = TeamDetailViewController()
        switch(segControl.selectedSegmentIndex){
        case 1:     //M.Eng Teams
            let team = teamViewModel.mengTeams[indexPath.row]
            teamDetailVC.team = team
            self.show(teamDetailVC, sender: nil)
            
        case 2:     //Undergrad Project Teams
            let team = teamViewModel.projectTeams[indexPath.row]
            teamDetailVC.team = team
            self.show(teamDetailVC, sender: nil)
            
        default:    //Default: All Teams
            let team = teamViewModel.displayedTeams[indexPath.row]
            teamDetailVC.team = team
            self.show(teamDetailVC, sender: nil)
        }
        
        print("Selected table row \(indexPath.row)")
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
