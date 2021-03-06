![Halo](halo.png)

# HALO iOS SDK

![](https://img.shields.io/badge/Swift-4.0-blue.svg) ![](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg) ![](https://img.shields.io/badge/CocoaPods-compatible-brightgreen.svg)

## Getting started

A getting started guide and some other information related to integrating and setting up the SDK can be found in the [wiki](https://mobgen.github.io/halo-documentation/ios_getting_started.html).

## API documentation

The latest API documentation (Swift oriented) can be checked [here](https://mobgen.github.io/halo-documentation/ios_home.html).

## Contribute

In order to start developing the Halo SDK, there are some required packages/tools to be installed first:

* [Carthage](https://github.com/Carthage/Carthage) to manage third-party libraries/SDKs. It can easily be installed using [Homebrew](http://brew.sh/) with `brew install carthage`
* [Jazzy](https://github.com/Realm/jazzy) a Ruby gem that provides Apple-like documentation. It can be installed using `[sudo] gem install jazzy`.

Once that's done, the initial setup of the project can be done. From the root folder of the project you can run:

* `carthage bootstrap --platform iOS` will set up the project, downloading any extra libraries/SDKs needed.

... and you're done! Enjoy developing this wonderful SDK! :heart:

## LICENSE ##
---------------
```
Open Source 2016-2017 MOBGEN

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
