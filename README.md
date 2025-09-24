# Context
We are working on creating a feed of posts in SwiftUI. So far, we have successfully implemented a classic feed that opens from the top, with bottom pagination — a standard use case.

Our goal, however, is to allow the feed to open from *any* post, not just the first one.

For example, we would like to open the feed directly at the 3rd post and then trigger a network call to load elements both above and below it.

Our main focus here is on preserving the scroll position while opening the screen and waiting for the network call to complete.

To illustrate the issue, I created a sample project (attached) with two screens:

- **MainView**, which contains buttons to open the feed in different states.
- **ScrollingView**, which initially shows a single element, simulates a 3-second network call, and then populates with new data depending on which button was tapped.

I am currently using Xcode 26 beta 6, but I can also reproduce this issue on Xcode 16.3.

# Demo

https://github.com/user-attachments/assets/1c0a69a5-ba24-4641-abec-0ae8d7fa1234

# Tests on sample project

I click on a button and just wait the 3 seconds for the call.

In this scenario, I expect that the “focused item” stays at the exact same place on the screen. I also expect to see items below and above being added.

## Simulator iPhone 16 / iOS 18.4 with itemsHeight = 100
`position = 0, 1, 2, 3` ⇒ works as expected

`position = 4, 5, 6, 7, 8, 9` ⇒ scroll is reset to the top and we loose the focused item

## Simulator iPhone 16 / iOS 18.4 with itemsHeight = 500
`position = 0, 1, 2, 3, 4` ⇒ works as expected

`position = 5, 6, 7` ⇒ I have a glitch (the focused element moves on the screen) but the focused element is still visible

`position = 8, 9` ⇒ scroll is reset to the top and we loose the focused item

## Simulator iPhone 16 / iOS 26 with itemsHeight = 100 or 500
`position = 0, 1, 2, 3, 4` ⇒ works as expected

`position = 5, 6, 7, 8, 9` ⇒ I have a glitch (the focused element moves on the screen) but the focused element is still visible

## Device iPhone 15 / iOS 26 with itemsHeight = 100
`position = 0, 1, 2, 3, 4` ⇒ works as expected

`position = 5, 6, 7, 8, 9` ⇒ I have a glitch (the focused element moves on the screen) but the focused element is still visible

## Device iPhone 15 / iOS 26 with itemsHeight = 500
`position = 0, 1, 2, 3` ⇒ works as expected

`position = 4, 5, 6, 7, 8, 9` ⇒ I have a glitch (the focused element moves on the screen) but the focused element is still visible

# Not any user interaction

Moreover, in this scenario, the user does not interact with the screen during the simulated network call. Regardless of the situation, if the ScrollView is in motion, its position always resets to the top. This behavior prevents us from implementing automatic pagination when scrolling upward, which is ultimately our goal.

# My conclusion so far
As far as I know it seems not possible to have both keeping scroll possible and upward automatic pagination using a SwiftUI LazyVStack inside a ScrollView. 

This appears to be standard behavior in messaging apps or other feed-based apps, and I’m wondering if I might be missing something. 

Thank you in advance for any guidance you can provide on this topic.

Cheers
