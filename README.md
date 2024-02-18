My second iOS app, another nights-and-weekends project: a gamified kids' bedtime app released years ago as [Bedtime Balloons](https://www.roundtripsoftware.com/app/bedtime/).

Featured interactive sprite-based animations on top of a UIKit view, custom art, timer logic to handle background mode with local notifications, and CoreData-based user customization.

Demo video:

[![Bedtime Balloons demo video](http://img.youtube.com/vi/2FC9hHkJs5M/0.jpg)](http://www.youtube.com/watch?v=2FC9hHkJs5M)


### This is some old code

This was pre-[Swift](https://developer.apple.com/swift/) and coded entirely in [Objective-C](https://en.wikipedia.org/wiki/Objective-C) 😲.  Heck, even [ARC](https://opensource.apple.com/source/clang/clang-211.10.1/src/tools/clang/docs/AutomaticReferenceCounting.html) was new at the time.

This was pre-[SpriteKit](https://developer.apple.com/spritekit/) 😮, so the animations were in [cocos2d](https://en.wikipedia.org/wiki/Cocos2d), now [Cocos2d-x](https://www.cocos.com/en/cocos2d-x).

Persistence in old-school [CoreData](https://developer.apple.com/documentation/coredata/). 💿  

### With some interesting features

Lots of carefully-timed [audio logic](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTSoundPlayer.m) 🔈 via [AVFoundation](https://developer.apple.com/av-foundation/). 

Some interesting [timer logic](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTTimer.m) that tigger [local notifications](https://github.com/patmcgtx/bedtime-balloons/blob/master/Kid%20on%20Time/KTTaskNotifiication.m) when in the background.


