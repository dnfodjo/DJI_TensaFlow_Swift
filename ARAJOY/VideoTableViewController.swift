//
//  VideoTableViewController.swift
//  ARAJOY
//
//  Created by Daniel Nfodjo on 6/30/17.
//  Copyright © 2017 Daniel Nfodjo. All rights reserved.
//

import UIKit
import YouTubePlayer


class VideoTableViewController: UITableViewController {
    var videoPlayer = YouTubePlayerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoPlayer.frame = self.view.frame
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIViewController()
        let myVideoURL = URL(string: "https://www.youtube.com/watch?v=rI3p3RAtGuE")
        videoPlayer.loadVideoURL(myVideoURL!)
        vc.view = videoPlayer
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
