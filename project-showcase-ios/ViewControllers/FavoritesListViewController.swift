//
//  FavoritesListViewController.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/19/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseDatabase

class FavoritesListViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, AddRemoveDelegate {
    
    func unstar(team: Team) {
        makeFavoriteList()
        teamTableView.reloadData()
    }
    
    //never called
    func star(team: Team) {
        teamTableView.reloadData()
    }

    //variables
    let screenSize : CGRect = UIScreen.main.bounds
    var teamViewModel: TeamViewModel!
    var teamTableView = UITableView()
    var favoriteList: [Team] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Want to Visit"
        self.view.backgroundColor = UIColor.backgroundGray
        makeFavoriteList()
        makeTableView()
    }
    
    func viewLoadSetup() {
        makeFavoriteList()
        makeTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewLoadSetup()
    }
    
    private func makeFavoriteList() {
        favoriteList = []
        for team in teamViewModel.allTeams {
            if team.isFavorited {
                favoriteList.append(team)
            }
        }
        teamViewModel.favoritedTeams = favoriteList
    }
    
    /***------------------------TABLE VIEW---------------------------***/
    private func makeTableView() {
        //Total height of nav bar, status bar, tab bar
        //let barHeights = (self.navigationController?.navigationBar.frame.size.height)!+UIApplication.shared.statusBarFrame.height + 100
        
        //edited CGRect to make margins and center it
        teamTableView = UITableView(frame: CGRect(x: 0, y: 45, width: screenSize.width-28, height: screenSize.height - (45)), style: UITableViewStyle.plain) //sets tableview to size of view below status bar and nav bar
        
        // UI
        teamTableView.backgroundColor = UIColor.backgroundGray
        teamTableView.separatorStyle = UITableViewCellSeparatorStyle.none // Removes bottom border for cells
        //teamTableView.contentInset = UIEdgeInsetsMake(-27, 0, 0, 0) // Removes padding above first cell
        
        //Remove vertical scroll bar
        teamTableView.showsVerticalScrollIndicator = true;
        
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
        return favoriteList.count
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
        customCell.delegate = self
        customCell.selectionStyle = .none
        let team = favoriteList[indexPath.row]
        customCell.teamForThisCell = team
        customCell.name = team.teamName
        customCell.img = #imageLiteral(resourceName: "starFilled")
        
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
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        let teamDetailVC = TeamDetailViewController()
        let claire = Contact(name: "Claire", major: "ORIE", gradYear: "1998", email: "yc2267@cornell.edu", team:" ", teamType: " ")
        teamDetailVC.contact = claire
        teamDetailVC.team = Team(teamName: "ECAFT", type: "Professional", descrip: "blablabla", contacts: [claire])
        self.show(teamDetailVC, sender: nil)
        
        print("Selected table row \(indexPath.row)")
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
