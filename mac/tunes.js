#!/usr/bin/env osascript -l JavaScript

var music_apps = ["Spotify", "Music"];
var output = "";

for (var i = 0; i < music_apps.length; i++) {
  var app = music_apps[i];
  if (Application(app).running()) {
    const track = Application(app).currentTrack;
    const artist = track.artist();
    const title = track.name();
    output = `${title} ⋅ ${artist}`.substr(0, 50);
    break;
  }
}

output;
