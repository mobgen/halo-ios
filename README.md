![Halo](halo.png)

# HALO iOS SDK

![](https://img.shields.io/badge/Swift-2.0-blue.svg)
![](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)
![](https://img.shields.io/badge/CocoaPods-compatible-brightgreen.svg)

## API documentation

The latest API documentation can be checked [here](http://borjasantos.bitbucket.org/docs/ios/halo-sdk/).

## Contribute

In order to start developing the Halo SDK, there are some required packages/tools to be installed first:

* [Carthage](https://github.com/Carthage/Carthage) to manage third-party libraries/SDKs. It can easily be installed using [Homebrew](http://brew.sh/) with `brew install carthage`
* [Jazzy](https://github.com/Realm/jazzy) a Ruby gem that provides Apple-like documentation. It can be installed using `[sudo] gem install jazzy`.

Once that's done, the initial setup of the project can be done. From the root folder of the project you can run:

* `carthage bootstrap --platform iOS` will set up the project, downloading any extra libraries/SDKs needed.

... and you're done! Enjoy developing this wonderful SDK! :heart: