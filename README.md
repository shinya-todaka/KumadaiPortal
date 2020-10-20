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

## Getting Started

1. Add this to your info.plist

``` 
<key>NSAppTransportSecurity</key>
  <dict>
	  <key>NSExceptionDomains</key>
		<dict>
		  <key>lecregdb.kumamoto-u.ac.jp</key>
		  <dict>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			  <key>NSExceptionMinimumTLSVersion</key>
			  <string>TLSv1.0</string>
			  <key>NSExceptionAllowsInsecureHTTPLoads</key>
			  <true/>
		  </dict>
		  <key>shib.kumamoto-u.ac.jp</key>
		  <dict>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			  <key>NSExceptionMinimumTLSVersion</key>
			  <string>TLSv1.0</string>
			  <key>NSExceptionAllowsInsecureHTTPLoads</key>
			  <true/>
		  </dict>
		  <key>cas.kumamoto-u.ac.jp</key>
		  <dict>
			  <key>NSExceptionRequiresForwardSecrecy</key>
			  <false/>
			  <key>NSExceptionMinimumTLSVersion</key>
			  <string>TLSv1.0</string>
			  <key>NSExceptionAllowsInsecureHTTPLoads</key>
			  <true/>
		  </dict>
	  </dict>
  </dict>
```

2. Login and get some data !

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