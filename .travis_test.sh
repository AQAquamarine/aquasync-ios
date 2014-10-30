#!/bin/bash

xcodebuild -workspace Aquasync.xcworkspace -scheme Aquasync -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.0' test | xcpretty
