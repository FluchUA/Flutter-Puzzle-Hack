# Flutter Puzzle Hack

A new Flutter project.

Participating in the contest created a flutter header. The game uses only standard tools, most of it is Canvas.

Style:
Implemented as steampunk, pipes, seven-segment indication, sparks. More steam implementation was planned, but there was not enough time for obvious reasons. 

Everything in the game is tied to the so-called energy. When you move the game object, the energy decreases and at the same time gradually fades indication of the moving object. When moving quickly, sparks may appear. 

On the sides of the playing field are flasks that are filled with energy by scrolling the crane underneath it. Each flask is signed and implements the described action. Thus, when filling the Exit flask, the player will return to the main menu, also shuffle works.

The flask is filled while the crane is turning. As soon as it is full, the tap control is blocked until the energy drops (as if overheating). 

Shuffle looks like the field is de-energized (control will be blocked) and gradually resuming. You can clearly see by the chaotic accelerating activation of the seven-segment indicators.

Looks more interesting on devices with a big screen, as the game scales the interface and looks nicer and more pleasant :)

![gallery](https://user-images.githubusercontent.com/62064623/158751136-4cf7f6ba-b6b2-4c0c-99fd-27f2da58a066.jpg)
![gallery 1](https://user-images.githubusercontent.com/62064623/158751137-5fff90df-f5f9-47d9-ab4a-7bb47b7be99d.jpg)
![gallery 3](https://user-images.githubusercontent.com/62064623/158751138-49497ccd-c49b-40dd-8658-6d1b3aeb80f5.jpg)

![g1](https://user-images.githubusercontent.com/62064623/158753099-41ecc5da-d739-4e04-859a-7f74792f86b3.gif)
![g2](https://user-images.githubusercontent.com/62064623/158753092-2f09131d-6781-41e3-bf6c-5764e7c7a507.gif)

Development steps<br/>
![Steps](https://user-images.githubusercontent.com/62064623/158751130-42757104-62ca-4714-993f-295e317a6120.gif)

Most of the focus is on the playing field because button styles, dialog boxes, and themes have not been set up properly.







Difficulties encountered:
At the moment there is a problem with optimization (multiplication of transformation matrices) and scaling.

Also on the mobile platform, you can observe a strange effect in the form of randomly appearing green pixels. Apparently some errors on the side of the engine, did not have time to figure it out

Due to the tense situation in the country, it is not possible to continue working on the game.
No war!
