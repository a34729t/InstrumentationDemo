# IOS Instrumentation Demo

## Goals

* Attach to root view controller in app delegate with a single line of code, no delegation, notifications, etc.
* Capture basic gestures- tap and double tap (hold for 2+ seconds to get double tap)
* Capture keyboard appearances + typing actions
* Transparently pass input events to subviews without affecting them

## Issues

* Can press button without triggering a tap notification
* Keyboard notifications crash app
* Touch events crash app

See my question: http://stackoverflow.com/questions/20012838/abstracting-uigesturerecognizer-and-nsnotifications-as-helpers-in-app-delegate-w
