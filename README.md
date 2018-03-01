# Hash Icons

![](https://github.com/Zinggi/elm-hash-icon/raw/master/examples/imgs/hashOfElm.svg?sanitize=true)

**[Demo](https://zinggi.github.io/randomDemos/other/elmHashIcon.html)** / [Source](https://github.com/Zinggi/elm-hash-icon/blob/master/examples/Main.elm)

This implements a sort of **visual hash** function.  
E.g, the icons above were generated using `iconsFromString 120 3.0 5 "Elm"`.  
The idea is to create a unique icon for every possible input.  
This can for instance be used as an avatar for anonymous users in a forum.  
It might also be used to quickly confirm if two files are different.  



## Features

From a visual hash function, we want a few different features:
  
  * Every possible value should be **easy to remember**
  * **No** two values should be too easy to **confuse**
  * Every icon should look 'good' or at least **not ugly**
  * There should be a high number of possible icons, such that **collisions** are **rare**
  * These properties should also hold for **colorblind** people

These goals are conflicting, but I think this library (and the idea in general) provides a nice trade-off.


## Collision resistance

Compared to other well known hash functions like SHA-256 (256 bit) or MD5 (128 bits),
this visual hash function has a much much worse collision resistance.
The hash icon provides roughly **20 bits** of entropy, so it shouldn't be used for anything critical.

The trade-off between collision resistance and good looking icons is adjustable with a cut-off ratio.
Color combinations with a contrast ratio below the cut-off ratio are discarded.

To increase the collision resistance, you might want to use multiple icons in a row.
E.g. with a ratio of 3.4 a row of 7 icons provides as many bytes as MD5.
Or with a ratio of 8.4 we would need 8 icons, but it would look much nicer.

## Customize
Want to use another set of colors? Another set of icons?  
**Create a fork!**  

I didn't make these things adjustable, because I thought most people don't want to make any adjustments.  
Also, having a few forks around that take the same idea but with different trade-offs sounds exciting to me.  

If you do end up forking this library, please **let me know** so that I can provide a link here.  

## Bugs
Some icons are chopped off.
The problem has already been noted [here](https://github.com/jystic/elm-font-awesome/issues/1) and is hopefully fixed soon.

## Update Log
**Note**: I will bump the major version every time there are some visual changes.
Even if it would technically not be a major change,
it would break the implicit contract that the same string always hashes to the same icon.

  * 2.0.0 -> Removed brands by default, but they can be enabled if desired.
  * 1.0.0 -> First version

## Prior art

  * Probably the [original "identicon"](https://web.archive.org/web/20080703155519/http://www.docuverse.com/blog/donpark/2007/01/18/visual-security-9-block-ip-identification)
  * Github's version, e.g. as implemented [here](https://github.com/pukkamustard/elm-identicon)

## Credits
Icons from [Font Awesome](https://fontawesome.com/)


