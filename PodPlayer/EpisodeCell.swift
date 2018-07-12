//
//  EpisodeCell.swift
//  PodPlayer
//
//  Created by Athena on 7/12/18.
//  Copyright © 2018 Sheena Elveus. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet var titleLabel: NSTextField!
    @IBOutlet var pubDateLabel: NSTextField!
    @IBOutlet var descriptionWebView: WKWebView!
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
} 
