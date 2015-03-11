Grope
=====

Some Amazon albums have very high-resolution album art locked away as a
collection of tiles accessible only through a pan-and-zoom interface in a popup
window (for example,
[Hannah Georgas - Hannah Georgas](http://www.amazon.com/Hannah-Georgas/dp/B009GQ2ML4)).
**Grope** leverages the “crop 'n' drop” functionality of
[`jpegtran`](http://jpegclub.org/jpegtran/) to losslessly stitch the tiles back
together into a single, high-resolution image.

Installation
------------

Grope is just a simple shell script, so it is sufficient to grab the newest
version from this repository, `chmod` it to be executable, and put it somewhere
on your path.

Grope also has two dependencies:

* [ImageMagick](http://www.imagemagick.org/), probably available through your
  package manager.
* [`jpegtran`](http://jpegclub.org/jpegtran/): download `droppatch.v9a.tar.gz`
  from the project page, extract it, and put the `jpegtran` binary somewhere on
  your path.

Usage
-----

(These instructions are particular to Firefox, but the same principles will
apply to other browsers.)

1. Open the zooming popup window for the album.
2. Zoom in all the way and wait for the high-resolution tiles to
   “snap” into place.
3. Right-click on the window margin and click **View Page Info**.
4. On the **Media** tab, locate one of the visible tiles.
5. Right-click on the entry for the tile in the media list, and click **Copy**.
6. In your favourite terminal emulator, run:

        grope.sh url output

   ...where `url` is the URL you just copied, and `output` is the name of the
   JPEG image to be created.