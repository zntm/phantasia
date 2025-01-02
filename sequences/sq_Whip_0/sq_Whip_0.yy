{
  // The "sequence" object
  "$GMSequence": "",
  "%Name": "sq_Whip_0",
  "autoRecord": true,
  "backdropHeight": 768,
  "backdropWidth": 1366,
  "events": {...},
  "length": 30.0,             // The total length in "timeUnits"
  "timeUnits": 1,             // Usually means 'frames' or 'seconds' depending on the mode
  "tracks": [...],            // The heart of the sequence: array of tracks
  "playbackSpeed": 60.0,
  ...
}
{
  "$GMInstanceTrack": "",
  "%Name": "obj_Whip",
  "keyframes": {
    "Keyframes": [
      {
        "$Keyframe<AssetInstanceKeyframe>": "",
        "Channels": {
          "0": {
            // references the object: "obj_Whip"
          }
        },
        "Key": 0.0,
        "Length": 60.0
      }
    ]
  },
  // Sub-tracks
  "tracks": [
    {
      "$GMRealTrack": "",
      "%Name": "image_index",
      "keyframes": { "Keyframes": [...] },
      ...
    },
    {
      "$GMRealTrack": "",
      "%Name": "position",
      "keyframes": { "Keyframes": [...] },
    },
    ...
  ]
}
"RealValue": 0.0,
"EmbeddedAnimCurve": {
  "$GMAnimCurve": "",
  ...
}
// parse-sequence.js
const fs = require("fs");

// 1. Read the JSON from a file
let data = JSON.parse(fs.readFileSync("sq_Whip_0.json", "utf8"));

// 2. Find all "rotation" tracks in the data
function modifyRotationTracks(tracks) {
  for (let t of tracks) {
    // If it's an instance track with child tracks
    if (t.tracks) {
      modifyRotationTracks(t.tracks);
    }
    // If it's a rotation track
    if (t["%Name"] === "rotation") {
      // For each keyframe
      for (let kf of t.keyframes.Keyframes) {
        // If there's a RealValue, add 10 degrees
        if (kf.Channels["0"]?.RealValue != null) {
          kf.Channels["0"].RealValue += 10;
        }
      }
    }
  }
}
modifyRotationTracks(data.tracks);

// 3. Write out the modified JSON
fs.writeFileSync("sq_Whip_0_modified.json", JSON.stringify(data, null, 2));
console.log("Modified rotation by +10 degrees for each keyframe.");
