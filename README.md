HeySwift
========

A simple project to learn Swift


I created this project with the intention to learn the new Swift language, as I find the best approach to learning any new language is to have a project to build. 

In this project, I am trying to avoid writing any Objective-C to stick to the goal of learning Swift and uncover any issues with building a pure Swift based app. I also avoided using any third party libraries, sticking to Apple frameworks.

What's it do?
--
The app is very simple. It accepts a seach query and displays results from Google's image search API in a UICollectionView. 

As I developed the app I realized that without authenticating as a Google developer, the API would only return a maximum of 8 images. To work around this limitation, I implemented a pseudo-endless scroller. This loaded 8 more images when you reached the end of the list. I also found that after the 64th item, the response also stopped ( probably also a limitation of not authenticating ), so I capped it at 64 images per search.

How's it do it?
--
In the project I'm leveraging a few different Cocoa (and Swift) technologies:
- Storyboards and Interface Builder: to configure the app's UI
- NSURLConnection: to fetch the search results 
- NSJSONSerialization: to parse the search results
- @lazy properties (Swift-only): to lazily instantiate properties


Note: this is just an educational experiment and not desiged to be a full-blown app for AppStore submission. I plan to continue updating the project as I explore usage of Swift.

