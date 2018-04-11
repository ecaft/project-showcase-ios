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
    
    /*** -------------------- FILTERING -------------------- ***/
    // Assumption: Filter Section ONLY contains selected Filter Option Items
//    func applyFilters(filterSect: FilterSection) {
//        var filteredSet: Set<Team> = Set<Team> (allTeams)
//        
//        //Get interesection of filtered companies from 3 sections
//        let filterItems = filterSect.items
//        //If "All" option selected for majors/positions. Sponsorship's isAllSelected = always false.
//        if(!filterSect.isAllSelected) {
//            let selectedTeams = getTeams(matching: filterSect)
//            let selectedSet = Set(selectedTeams)
//            filteredSet = filteredSet.intersection(selectedSet)
//        }
//        
//        // Update filtered companies
//        filteredTeams = Array(filteredSet)
//        
//        //Return intersectin of companies filtered by filters & companies filtered by search bar
//        if (searchBarTeams.count > 0) {
//            let searchBarSet: Set<Team> = Set(searchBarTeams)
//            displayedTeams = Array(filteredSet.intersection(searchBarSet))
//        } else {
//            displayedTeams = Array(filteredSet)
//        }
//        
//        //Companies displayed in alphabetical order
//        sortDisplayedTeamsAlphabetically()
//    }
    
//    private func getTeams(matching filterSection: FilterSection) -> [Team] {
//        var filteredSet: Set<Team> = Set<Team> ()
//        switch filterSection.type {
//        case .Majors:
//            for filterOptItem in filterSection.items {
//                let searchValue = filterOptItem.searchValue?.lowercased()
//                for team in allTeams {
//                    //Insensitive case search
//                    let isFound = team.majors.contains(where: { $0.caseInsensitiveCompare(searchValue!) == ComparisonResult.orderedSame })
//                    if (isFound) {
//                        filteredTeams.insert(team)
//                    }
//                }
//            }
//        }
//        
//        let alphabeticalFilteredTeams = Array(filteredTeams).sorted {
//            return $0.teamName.lowercased() < $1.teamName.lowercased()
//        }
//        return alphabeticalFilteredTeams
//    }
    
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
