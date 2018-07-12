//
//  SplitController.swift
//  PodPlayer
//
//  Created by Athena on 7/3/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Cocoa

class SplitController: NSSplitViewController {

    
    @IBOutlet var podcastItems: NSSplitViewItem!
    @IBOutlet var episodesItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        if let podcastsVC = podcastItems.viewController as? PodcastsViewController {
            if let episodesVC = episodesItem.viewController as? EpisodeViewController {
                podcastsVC.episodesVC = episodesVC
                episodesVC.podcastsVC = podcastsVC
            }
        }
    }
    
}
