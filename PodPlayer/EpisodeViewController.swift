//
//  EpisodeViewController.swift
//  PodPlayer
//
//  Created by Athena on 7/3/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Cocoa
import AVFoundation

class EpisodeViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var imageView: NSImageView!
    @IBOutlet var pausePlayButton: NSButton!
    @IBOutlet var deleteButton: NSButton!
    @IBOutlet var tableView: NSTableView!
    
    var podcast : Podcast? = nil
    var podcastsVC: PodcastsViewController? = nil
    var episodes : [Episode] = []
    var player : AVPlayer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
    }
    
    func updateView() {
        if podcast?.title != nil {
            titleLabel.stringValue = podcast!.title!
            print(titleLabel.fittingSize)
            print(titleLabel.fittingSize.height)
            
        } else {
            titleLabel.stringValue = ""
        }
        
        if podcast?.imageURL != nil {
            let image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            imageView.image = image
        } else {
            imageView.image = nil
        }
        
        if podcast != nil {
            tableView.isHidden = false
            deleteButton.isHidden = false
        } else {
            tableView.isHidden = true
            deleteButton.isHidden = true
        }
        
        pausePlayButton.isHidden = true
        
        getEpisodes()
        
    }
    
    
    func getEpisodes() {
        
        if podcast?.rssURL != nil {
            if let url = URL(string: podcast!.rssURL!) {
                
                URLSession.shared.dataTask(with: url) {
                    (data: Data?, response: URLResponse?, error: Error?) in
                    
                    if error != nil {
                        print(error)
                    } else {
                        
                        if data != nil {
                            let parser = Parser()
                            self.episodes = parser.getEpisodes(data: data!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }.resume()
            }
        }
    }
    
    
    
    
    @IBAction func deleteClicked(_ sender: Any) {
        if podcast != nil {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(podcast!)
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                podcastsVC?.getPodcasts()
                podcast = nil
                updateView()
            }
            
        }
    }
    
    @IBAction func pausePlayClicked(_ sender: Any) {
        if pausePlayButton.title == "Pause" {
            player?.pause()
            pausePlayButton.title = "Play"
        } else {
            player?.play()
            pausePlayButton.title = "Pause"
        }
    }
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let episode = self.episodes[row]
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "episodeCell"), owner: self) as? EpisodeCell
        
        cell?.titleLabel.stringValue = episode.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell?.pubDateLabel.stringValue = dateFormatter.string(from: episode.pubDate)
        
        cell?.descriptionWebView.loadHTMLString(episode.htmlDescription, baseURL: nil)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 150
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        //episode has been selected
        if tableView.selectedRow >= 0 {
            let episode = episodes[tableView.selectedRow]
            print(episode.title)
            print(episode.audioUrl)
            if let url = URL(string: episode.audioUrl) {
                player?.pause()
                player = nil
                
                player = AVPlayer(url: url)
                player?.play()
            }
            pausePlayButton.isHidden = false
            pausePlayButton.title = "Pause"
            
        }
    }
}
