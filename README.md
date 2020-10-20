# KumadaiPortal

swift based [熊大ポータル](http://uportal.kumamoto-u.ac.jp/uPortal/render.userLayoutRootNode.uP) client

## Features 

- [x] Login using your username and password 
- [x] Get your timetable 
- [x] Get your grades

## Installation 

sorry but only for spm at the moment.

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/shinya-todaka/KumadaiPortal.git", from: "0.0.1"),
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: ["KumadaiPortal"]),
    ]
)
```

## Usage 

```swift 
KumadaiPortal.shared.login(username: YOURUSERNAME, password: YOURPASSWORD) { (error) in
    if let error = error {
        print(error)
        return
    }
            
    KumadaiPortal.shared.getSeiseki { (grades, error) in
        if let error = error {
            print(error)
            return
        }
                
        if let grades = grades {
            print(grades)
        }
    }
}