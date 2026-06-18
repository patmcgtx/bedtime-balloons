My second iOS app: a gamified kids' bedtime app released years ago as [Bedtime Balloons](https://www.roundtripsoftware.com/app/bedtime/).

Featured interactive sprite-based animations on top of a UIKit view, custom art, timer logic to handle background mode with local notifications, and CoreData-based user customization.

### Demo and screenshots

[Marketing demo of the app](https://youtu.be/P_HLeBcKXtE?si=k36kmfskB4IFzfiu)

<img width="320" height="180" alt="bb-screenshot-sleeping" src="https://github.com/user-attachments/assets/16d83a08-4a95-44e4-9ab4-e50fee46ef5b" />
<img width="180" height="320" alt="bbroutines" src="https://github.com/user-attachments/assets/100a9b6b-9ab7-4de9-a8cd-9f1fddf19525" />
<img width="180" height="320" alt="bbeditingtask" src="https://github.com/user-attachments/assets/c25423ed-ad72-448c-a0d1-63893c03efb9" />

### This is some old code

This was pre-[Swift](https://developer.apple.com/swift/) and coded entirely in [Objective-C](https://en.wikipedia.org/wiki/Objective-C) 😲.  Heck, even [ARC](https://opensource.apple.com/source/clang/clang-211.10.1/src/tools/clang/docs/AutomaticReferenceCounting.html) was new at the time.

This was pre-[SpriteKit](https://developer.apple.com/spritekit/) 😮, so the animations were in [cocos2d](https://en.wikipedia.org/wiki/Cocos2d), now [Cocos2d-x](https://www.cocos.com/en/cocos2d-x).

### With some interesting features

Lots of carefully-timed [audio logic](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTSoundPlayer.m) 🔈 via [AVFoundation](https://developer.apple.com/av-foundation/). 

Some interesting [timer logic](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTTimer.m) that tigger [local notifications](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTTaskNotifiication.m) when in the background.

Persistence in old-school [CoreData](https://developer.apple.com/documentation/coredata/) 💿, including saving user-selected images.

