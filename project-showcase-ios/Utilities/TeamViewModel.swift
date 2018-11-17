//
//  TeamViewModel.swift
//  project-showcase-ios
//
//  Created by Amanda Ong on 1/29/18.
//  Copyright © 2018 ECAFT. All rights reserved.
//

import Foundation

class TeamViewModel: NSObject {
    private(set) var filteredTeams = [Team]() //for filters
    private(set) var searchBarTeams = [Team]() //for search bar
    
    var displayedTeams = [Team]() // teams to display on table view
    var allTeams = [Team]() // Can be all project teams, all MEng teams, or all research teams
    var projectTeams = [Team]() // All project teams in database
    var mengTeams = [Team]()
    var researchTeams = [Team]()
    var favoritedTeams = [Team]()
    
    // File Path to saved favorites
    var favoritesFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        print("this is the url path in the documentDirectory \(String(describing: url))")
        return (url!.appendingPathComponent("favoritesData").path)
    }
    
    override init() {
        super.init()
        if let favoritedTeams = NSKeyedUnarchiver.unarchiveObject(withFile: favoritesFilePath) as? [Team] {
            self.favoritedTeams = favoritedTeams
        }
    }
    
    func addTeamToAllTeams(_ team: Team) {
        allTeams.append(team)
        //print("added team to allTeams!")
    }
    
    func addTeamToDisplayedTeams(_ team: Team) {
        displayedTeams.append(team)
        //print("added team to displayedTeams!")
    }
    
    func addTeamToProjectTeams(_ team: Team) {
        projectTeams.append(team)
        //print("added team to projectTeams!")
    }
    
    func addTeamtoMengTeams(_ team: Team) {
        mengTeams.append(team)
        //print("added team to MengTeams!")
    }
    
    func addTeamtoResearchTeams(_ team: Team) {
        researchTeams.append(team)
        //print("added team to researchTeams!")
    }
    
    func removeTeam(index: Int) {
        allTeams.remove(at: index)
        //print("removed team!")
    }
    
    func clearTeams() {
        allTeams = []
    }
    
    func addTeamtoFavoriteTeams(_ team: Team) {
        favoritedTeams.append(team)
    }
    
    func addContactToTeam(teamName: String, teamType: String, contact: Contact) {
        if teamType == "Undergrad Project Team" {
            for projectTeam in projectTeams{
                if teamName == projectTeam.teamName {
                    projectTeam.contacts.append(contact)
                }
            }
        } else if(teamType == "M.Eng"){
            for mEngTeam in mengTeams{
                if teamName == mEngTeam.teamName {
                    mEngTeam.contacts.append(contact)
                }
            }
        } else {
            for team in allTeams{
                if teamName == team.teamName {
                    team.contacts.append(contact)
                }
            }
        }
    }
    
    /*** -------------------- FILTERING -------------------- ***/
    // Assumption: Filter Section ONLY contains selected Filter Option Items
    func applyFilters(filterSections: [FilterSection]) {
        var filteredTeamsSet: Set<Team> = Set(allTeams)
        
        //Get interesection of filtered teams
        for filterSect in filterSections {
            
            if(!filterSect.isAllSelected) {
                let selectedTeams = getTeams(matching: filterSect)
                let selectedTeamSet = Set(selectedTeams)
                filteredTeamsSet = filteredTeamsSet.intersection(selectedTeamSet)
            }
        }
        
        // Update filtered companies
        filteredTeams = Array(filteredTeamsSet)
        
        //Return intersectin of companies filtered by filters & companies filtered by search bar
        if (searchBarTeams.count > 0) {
            let searchBarTeamsSet: Set<Team> = Set(searchBarTeams)
            displayedTeams = Array(filteredTeamsSet.intersection(searchBarTeamsSet))
        } else {
            displayedTeams = Array(filteredTeamsSet)
        }
        
        //Companies displayed in alphabetical order
        sortDisplayedTeamsAlphabetically()
    }
    
    private func getTeams(matching filterSection: FilterSection) -> [Team] {
        var filteredTeams: Set<Team> = Set<Team> ()
        switch filterSection.type {
        case .Majors:
            for filterOptItem in filterSection.items {
                let searchValue = filterOptItem.searchValue?.lowercased()
                for team in allTeams {
                    //Insensitive case search
                    let isFound = team.majors.contains{ $0.caseInsensitiveCompare(searchValue!) == ComparisonResult.orderedSame }
                    if (isFound) {
                        filteredTeams.insert(team)
                    }
                }
            }
        }
        
        let alphabeticalFilteredTeams = Array(filteredTeams).sorted {
            return $0.teamName.lowercased() < $1.teamName.lowercased()
        }
        return alphabeticalFilteredTeams
    }
    
    /*** -------------------- SEARCHING -------------------- ***/
    // Update search bar companies & displayed companies to show companies matching search
    func applySearch(searchText: String) {
        clearSearchBarTeams() // Clear previous search
        let text = searchText.lowercased()
        let teamsToSearch = (filteredTeams.count > 0) ? filteredTeams : allTeams
        for team in teamsToSearch {
            if (team.description.lowercased().range(of: text) != nil) {
                searchBarTeams.append(team)
            }
        }
        // Update displayed companies to search bar companies
        displayedTeams = searchBarTeams
        sortDisplayedTeamsAlphabetically()
    }
    
    func clearSearchBarTeams() {
        searchBarTeams = []
    }
    
    func resetDisplayedTeams() {
        displayedTeams = (filteredTeams.count > 0) ? filteredTeams : allTeams
    }
    
    func sortDisplayedTeamsAlphabetically() {
        displayedTeams.sort {
            return $0.teamName.lowercased() < $1.teamName.lowercased()
        }
    }
}
