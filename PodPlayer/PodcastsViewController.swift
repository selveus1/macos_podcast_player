//
//  PodcastsViewController.swift
//  PodPlayer
//
//  Created by Athena on 3/21/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Cocoa

class PodcastsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    //variables
    @IBOutlet var urlTextField: NSTextField!
    @IBOutlet var tableView: NSTableView!
    var podcasts : [Podcast] = []
    var episodesVC : EpisodeViewController? = nil

    //functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        getPodcasts()
    }
    
    
    func getPodcasts(){
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            do {
                podcasts = try context.fetch(fetchy)
                print(podcasts)
            } catch {}
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    @IBAction func addPodcastButtonClicked(_ sender: Any) {
        print(urlTextField.stringValue)
        let urlString = urlTextField.stringValue
        
        if let url = URL(string: urlTextField.stringValue) {
            
            print("url is found!")
            
            URLSession.shared.dataTask(with: url) {
                (data: Data?, response: URLResponse?, error: Error?) in
            
                if error != nil {
                    print(error)
                } else {
                    
                    if data != nil {
                        let parser = Parser()
                        let info = parser.getPodcastMetadata(data: data!)
                        
                        //if podcast hasn't alredy been added, add it
                        if self.doesPodcastExist(rssURL: urlString) == false {
                        
                            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                                let podcast = Podcast(context: context)
                                
                                podcast.rssURL = urlString
                                podcast.imageURL = info.imageURL
                                podcast.title = info.title
                                
                                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                                self.getPodcasts()
                                
                                DispatchQueue.main.async {
                                    self.urlTextField.stringValue = ""
                                }
                                
                            }
                            
                        } else {
                            print("podcast already exists!")
                        }
                    } else{
                        print("data is nil!")
                    }
                }
            }.resume()
            
            
            
        }
        
    }
    
    func doesPodcastExist(rssURL: String) -> Bool {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            
            let fetchy = Podcast.fetchRequest() as NSFetchRequest<Podcast>
            fetchy.predicate = NSPredicate(format: "rssURL == %@", rssURL)
            
            do {
                let matchingPodcasts = try context.fetch(fetchy)
                if matchingPodcasts.count >= 1 {
                    return true
                } else {
                    return false
                }
            } catch {}

        }
        
        return true
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "podcastcell"), owner: self) as? NSTableCellView
        
        let podcast = podcasts[row]
        if podcast.title != nil {
            cell?.textField?.stringValue = podcast.title!
        } else {
            cell?.textField?.stringValue = "UNKNOWN TITLE"
        }
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            let podcast = podcasts[tableView.selectedRow]
            episodesVC?.podcast = podcast
            episodesVC?.updateView()
        }
    }
    
}
