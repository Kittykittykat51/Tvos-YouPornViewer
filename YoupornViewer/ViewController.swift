//
//  ViewController.swift
//  YoupornViewer
//
//  Created by kimiko88 on 04/10/15.
//  Copyright © 2015 kimiko88. All rights reserved.
//

import UIKit
import Foundation



class Video{
    var Link: String
    var ImageLink: String
    var Title: String
    init(link: String, imageLink: String, title: String)
    {
        Link = link
        ImageLink = imageLink
        Title = title
    }
}


class ViewController: UIViewController {
    var videos = [Video]()
    var actualPage = 1;
    var bounds = UIScreen.mainScreen().bounds
    var scroll = UIScrollView()
    var field = UITextField()
    var isSearch: Bool = false
    var isSorted: Bool = false
    var selectedSort: String = "rating"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.scroll;
        self.scroll.backgroundColor = UIColor.blackColor()
        showPage(actualPage)
        
    }
    
    
    
    func showPage(actualPage: Int){
        videos = [Video]()
        self.isSearch = false
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/?page=\(actualPage)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("\n")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "")
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                        print(img)
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
//                
//                self.sortButton(i,text: "relevance:")
//                i++
                self.sortButton(i,text: "views:")
                 i++
                self.sortButton(i,text: "rating:")
                 i++
                self.sortButton(i,text: "duration:")
                 i++
                self.sortButton(i,text: "date:")
                 i += 2
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i++;
                }
                
                
                self.nextButton(i)
                i++;
                if(actualPage > 1){
                    self.previousButton(i)
                    i++
                }
                
                self.homeButton(i)
                i++
                
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    func searchText(textToSearch: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        self.isSearch = true
        self.selectedSort = "relevance"
        let url = NSURL(string: "http://www.youporn.com/search/?query=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("\n")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "")
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3

                self.sortButton(i,text: "relevance:")
                i++
                self.sortButton(i,text: "views:")
                i++
                self.sortButton(i,text: "rating:")
                i++
                self.sortButton(i,text: "duration:")
                i++
                self.sortButton(i,text: "date:")
                i++
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i++;
                }
                
                self.nextButton(i)
                i++;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i++
                }
                self.homeButton(i)
                i++
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
    
    
    func SortByHome(howSort: String){
        videos = [Video]()
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/browse/\(howSort)/?page=\(actualPage)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("\n")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "")
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
                
                self.sortButton(i,text: "views:")
                i++
                self.sortButton(i,text: "rating:")
                i++
                self.sortButton(i,text: "duration:")
                i++
                self.sortButton(i,text: "date:")
                i += 2
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i++;
                }
                
                self.nextButton(i)
                i++;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i++
                }
                self.homeButton(i)
                i++
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }
    
 
    
    func SortBySearch(howSort: String,textToSearch: String){
        videos = [Video]()
         self.isSearch = true
        let subViews = self.scroll.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        let url = NSURL(string: "http://www.youporn.com/search/\(howSort)/?query=\(textToSearch.stringByReplacingOccurrencesOfString(" ", withString: "+"))&page=\(actualPage)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            let stringa = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let strin = String(stringa)
            let splitted = strin.characters.split{$0 == " "}.map(String.init)
            
            for (var i = 0; i < splitted.count; i++)
            {
                let oo = splitted[i]
                if (oo.rangeOfString("href=\"/watch/") != nil && splitted[i + 1].rangeOfString("class='video-box-image'") != nil){
                    let link = oo.stringByReplacingOccurrencesOfString("href=\"",withString: "http://www.youporn.com").stringByReplacingOccurrencesOfString("\"", withString: "").stringByReplacingOccurrencesOfString("\">", withString: "")
                    var tempTitle = ""
                    var start = false
                    i++
                    while((splitted[i].rangeOfString("\n")) == nil)
                    {
                        i++
                        if(splitted[i].rangeOfString("title=\"") != nil){
                            start = true
                        }
                        if(start){
                            tempTitle += " " + splitted[i]
                        }
                    }
                    let title = tempTitle.stringByReplacingOccurrencesOfString(" title=\"", withString: "").stringByReplacingOccurrencesOfString("\">\n<img", withString: "")
                    let img = splitted[i+1].stringByReplacingOccurrencesOfString("src=\"", withString: "").stringByReplacingOccurrencesOfString("\"", withString: "")
                    let video = Video(link: link, imageLink: img, title: title)
                    self.videos.append(video)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                var i = 1;
                self.TextField(i)
                i += 3
                self.searchButton(i)
                i += 3
                self.sortButton(i,text: "relevance:")
                i++
                self.sortButton(i,text: "views:")
                i++
                self.sortButton(i,text: "rating:")
                i++
                self.sortButton(i,text: "duration:")
                i++
                self.sortButton(i,text: "date:")
                i++
                for video in self.videos{
                    self.chargeImageAsync(video.ImageLink,index :i, video: video)
                    i++;
                }
                
                self.nextButton(i)
                i++;
                if(self.actualPage > 1){
                    self.previousButton(i)
                    i++
                }
                self.homeButton(i)
                i++
                self.scroll.contentSize = CGSize(width: self.bounds.width, height: CGFloat(self.calculatePosition(i).maxY + 180))
                self.scroll.scrollEnabled = true
            }
        }
        task.resume()
    }

    
    
    
    func TextField(index: Int)
    {
        field.frame =  calculatePositionLarger(index)
        field.backgroundColor = UIColor.whiteColor()
        scroll.addSubview(field)
        
    }
    
    func searchButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Search", forState: .Normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: "search:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func homeButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Home", forState: .Normal)
        //        button.tag = index + 1)
        button.addTarget(self, action: "home:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    
    func sortButton(index: Int,text: Selector){
        let button = UIButton(type: UIButtonType.System)
        let title = text.description.stringByReplacingOccurrencesOfString(":", withString: "")
        if(selectedSort == title)
        {
            button.backgroundColor = UIColor.grayColor()
        }else{
        button.backgroundColor = UIColor.blackColor()
        }
        button.frame =  calculatePosition(index)
        button.setTitle(title,forState: .Normal)
            //        button.tag = index + 1)
        button.addTarget(self, action: text, forControlEvents: .PrimaryActionTriggered)
        
        button.clipsToBounds = true
        scroll.addSubview(button)
    }
    
    func views(sender: UIButton){
        self.actualPage = 1
        selectedSort = "views"
        if(!isSearch)
        {
        self.SortByHome("views")
        }else{
          self.SortBySearch("views", textToSearch: field.text!)
        }
    }
    
    func rating(sender: UIButton){
        self.actualPage = 1
        selectedSort = "rating"
        if(!isSearch)
        {
            self.SortByHome("rating")
        }else{
            self.SortBySearch("rating", textToSearch: field.text!)
        }
    }
    
    func duration(sender: UIButton){
        self.actualPage = 1
        selectedSort = "duration"
        if(!isSearch)
        {
            self.SortByHome("duration")
        }else{
            self.SortBySearch("duration", textToSearch: field.text!)
        }
    }
    
    func date(sender: UIButton){
        self.actualPage = 1
        selectedSort = "date"
        if(!isSearch)
        {
            self.SortByHome("time")
        }else{
            self.SortBySearch("time", textToSearch: field.text!)
        }
    }
    
    func relevance(sender: UIButton){
        self.actualPage = 1
        selectedSort = "relevance"
        self.SortBySearch("relevance", textToSearch: field.text!)
    }
    
    
    func nextButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.backgroundColor = UIColor.blackColor()
        button.frame =  calculatePosition(index)
        button.setTitle("Next Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: "next:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        
        //        scroll.contentSize = CGSize(width: bounds.width, height: CGFloat(y + 180))
        //        scroll.scrollEnabled = true
    }
    
    
    func previousButton(index: Int){
        let button = UIButton(type: UIButtonType.System)
        button.frame =  calculatePosition(index)
        button.setTitle("Previous Page", forState: .Normal)
        button.tag = index
        button.addTarget(self, action: "previous:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        //        scroll.clipsToBounds = true
    }
    
    func tapped(sender: UIButton) {
        let object = self.videos[sender.tag]
        self.performSegueWithIdentifier("Video", sender: object)
    }
    
    func next(sender: UIButton) {
        actualPage++
        //TODO ADD SORT PAGINATION
        if(!isSearch){
            if(!isSorted)
            {
            self.showPage(actualPage)
            }else
            {
                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
            self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    
    func previous(sender: UIButton) {
        actualPage--
        if(!isSearch){
            if(!isSorted)
            {
                self.showPage(actualPage)
            }else
            {
                self.SortByHome(selectedSort)
            }
        }
        else{
            if(!isSorted){
                self.searchText(field.text!)
            }else{
                self.SortBySearch(selectedSort, textToSearch: field.text!)
            }
        }
    }
    
    func home(sender: UIButton){
        self.actualPage = 1
        self.showPage(actualPage)
    }
    
    
    func search(sender: UIButton){
        self.actualPage = 1
        self.searchText(field.text!)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let video = sender as! Video
        if segue.identifier == "Video"{
            let vc = segue.destinationViewController as! VideoController
            vc.video = video
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func calculatePosition(index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(300)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func calculatePositionLarger(index: Int) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(300) + 20)
        let width = CGFloat(600)
        let height =  CGFloat(169)
        let x = ((index) % numImagePerRow) * Int(width) + 20 * ((index) % numImagePerRow + 1)
        let y = (index) / numImagePerRow * Int(height) + 20 * ((index) / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func calculatePosition(index: Int, image: UIImage) -> CGRect
    {
        let numImagePerRow = Int(bounds.width) / (Int(image.size.width) + 20)
        let width = image.size.width
        let height = image.size.height
        let x = (index % numImagePerRow) * Int(width) + 20 * (index % numImagePerRow + 1)
        let y = index / numImagePerRow * Int(height) + 20 * (index / numImagePerRow + 1)
        return CGRectMake(CGFloat(x), CGFloat(y), width, height)
    }
    
    func createButton(image: UIImage, index: Int,video: Video){
        let button = UIButton(type: UIButtonType.System)
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
        button.titleLabel?.lineBreakMode = .ByTruncatingTail
        button.titleLabel?.backgroundColor = UIColor.blackColor()
        button.setTitleColor(UIColor(red: 236.0/255.0, green: 86.0/255.0, blue: 124.0/255.0, alpha: 1.0), forState: .Normal)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 25)
        button.setTitle(String(htmlEncodedString: video.Title), forState: .Normal)
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        button.frame =  calculatePosition(index, image: image)
        button.setBackgroundImage(image, forState: .Normal)
        button.tag = index - 12
        button.addTarget(self, action: "tapped:", forControlEvents: .PrimaryActionTriggered)
        button.clipsToBounds = true
        scroll.addSubview(button)
        scroll.clipsToBounds = true
    }
    
    func chargeImageAsync(image: String, index: Int, video: Video){
        let url = NSURL(string: image)
        if((url == nil || (url?.hashValue) == nil)){
            let image = UIImage(named: "ImageNotfound.png")
            dispatch_async(dispatch_get_main_queue()){
                self.createButton(image!,index: index,video: video)
            }
        }else{
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()){
                    self.createButton(image!,index: index,video: video)
                    }
            }
            task.resume()
        }
    }
    
    
}

