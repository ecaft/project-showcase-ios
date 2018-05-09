//
//  BrowseViewController.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit
import SnapKit

class BrowseViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    let screenSize : CGRect = UIScreen.main.bounds
    var teamViewModel: TeamViewModel!
    var searchBar: UISearchBar!
    var teamTableView = UITableView()
    
    //Segmented Control
    let segmentTitles : [String] = ["M.Eng", "Undergrad", "Project Teams"]
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
        makeFilterButton()
        makeSearchBar()
        makeSegControl()
        makeTableView()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Disable top bounce on filterView
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    
    /*** -------------------- FILTER BUTTON ----------------------***/
    func makeFilterButton(){
        let filterBarButton = UIBarButtonItem(title: "Filter", style: UIBarButtonItemStyle.plain, target: self, action: #selector(BrowseViewController.filterButtonTapped(_:)))
        filterBarButton.tintColor = UIColor.white
    
        self.navigationItem.rightBarButtonItem = filterBarButton
    }

    @IBAction func filterButtonTapped(_ sender:UIBarButtonItem!)
    {
        print("filter button tapped")
    }

    
    /*** -------------------- SEARCH BAR -------------------- ***/
    // Called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //TeamViewModel?.applySearch(searchText: searchText)
        //companyTableView.reloadData()
        
        // If clear button pressed
        if searchText.isEmpty {
            searchBar.resignFirstResponder()
            view.endEditing(true)
            
            //teamViewModel?.clearSearchBarCompanies()
            //teamViewModel?.resetDisplayedCompanies()
            //companyTableView.reloadData()
        }
    }
    
    // When cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        view.endEditing(true)
        
        //TeamViewModel?.clearSearchBarCompanies()
        //TeamViewModel?.resetDisplayedCompanies()
        //companyTableView.reloadData()
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
        //tableView.reloadData()
    }
    
    
    /*** -------------------- TABLE VIEW -------------------- ***/
    private func makeTableView() {
        //Total height of nav bar, status bar, tab bar
        let barHeights = (self.navigationController?.navigationBar.frame.size.height)!+UIApplication.shared.statusBarFrame.height + 100
        
        //edited CGRect to make margins and center it
        teamTableView = UITableView(frame: CGRect(x: 0, y: segControl.frame.maxY+45, width: screenSize.width-28, height: screenSize.height - (segControl.frame.maxY+45)), style: UITableViewStyle.plain) //sets tableview to size of view below status bar and nav bar
        
        // UI
        teamTableView.backgroundColor = UIColor.backgroundGray
        teamTableView.separatorStyle = UITableViewCellSeparatorStyle.none // Removes bottom border for cells
        teamTableView.contentInset = UIEdgeInsetsMake(-27, 0, 0, 0) // Removes padding above first cell
        
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
    
    /*
    //Section: Change font color and background color for section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let screenSize : CGRect = UIScreen.main.bounds
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        //headerView.backgroundColor = UIColor.ecaftLightGray
        
        let label = UILabel(frame: CGRect(x: 0.05*screenSize.width, y: 0, width: screenSize.width, height: 0))
        label.center.y = 0.5*headerView.frame.height
        //label.text = teamViewModel?.sectionTitles[section]
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        //label.textColor = UIColor.ecaftBlack
        
        headerView.addSubview(label)
        
        return nil
    }
    */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        /*
        guard let teamViewModel = teamViewModel else {
            return 0
        }
        return teamViewModel.displayedTeams.count
        */
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        /*
        guard let team = teamViewModel?.displayedTeams[indexPath.row],
            let customCell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier) as? TeamTableViewCell else {
                print("BrowseViewController.swift - cellForRowAt method:  Team Table View dequeuing cell error")
                return UITableViewCell()
        }
        */
        
        guard let customCell: TeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: TeamTableViewCell.identifier) as? TeamTableViewCell else {
            print("BrowseViewController.swift - cellForRowAt method:  Team Table View dequeuing cell error")
            return UITableViewCell()
        }
        
        //Stops cell turning grey when click on it
        customCell.selectionStyle = .none
        customCell.name = "Team Name"
        customCell.department = "Department Name"
        customCell.img = #imageLiteral(resourceName: "starUnfilled") //have to figure out how to pass through properly (maybe with boolean?)
        /*
        customCell.name = team.teamName
        customCell.department = team.department
        */
        
        customCell.backgroundColor = UIColor.white
        
        //set cell borders
        customCell.contentView.layer.borderWidth = 2
        
        let myColor : UIColor = UIColor(red:0.61, green:0.15, blue:0.12, alpha:1.0)
        customCell.contentView.layer.borderColor = myColor.cgColor
        
        return customCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        let companyDetailsVC = CompanyDetailsViewController()
        companyDetailsVC.companyViewModel = companyViewModel
        companyDetailsVC.listViewModel = listViewModel
        companyDetailsVC.company = companyViewModel?.displayedCompanies[indexPath.row]
        companyDetailsVC.isFavorite = (companyViewModel?.displayedCompanies[indexPath.row].isFavorite)!
        self.show(companyDetailsVC, sender: nil)
        */
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
