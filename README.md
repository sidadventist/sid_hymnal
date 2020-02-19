# sid_hymnal

SID Seventh-day Adventist Hymnal

## Screenshots

### Android
![Android](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/android_song.png)
<details>
  <summary>
    Click for more screenshots
  </summary>

![Android](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/android_search.png)
  
![Android](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/android_settings.png)

![Android](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/android_dark.png)

</details>


### iOS
![iOS](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/ios_song.png)
<details>
  <summary>
    Click for more screenshots
  </summary>
  
![iOS](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/ios_search.png)
  
![iOS](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/ios_settings.png)

![iOS](https://raw.githubusercontent.com/sidadventist/sid_hymnal/master/screenshots/ios_dark.png)

</details>

## Contributing Hymns

1. Hymns are located in the `assets/hymns/{language}` folder. The language folder must use ISO 639-1 Format

2. In each languange folder, there should be a meta.json, with the following properties
    -title
    -song (an object with the number of hymn matched to the title)

    Example:
```
    {
    "title": "SID Hymnal",
    "songs": {
        "1": "Watchman Blow The Gospel Trumpet.",
        "2": "The Coming King",
        "3": "Face To Face"
        }
    }
```

**All Hymns in the English folder must be accounted for in your translation. Do not skip hymns**

3. Hymn numbering should be `###.md` format, padded by 0s as necessary. i.e. 002.md, 024.md, 121.md

4. Format of the Hymn follows this standard:

  #### Title
  - the First line must be a level 2 heading (starting with a "`## `"). Do not make the heading multiline, only the first line will be parsed as the heading
  - The First line must be followed by 2 new lines (`\n\n`)

  #### Verses
  - Verses must be preceded by exactly 2 new lines (`\n\n`)
  - Verses must be followed by exactly 2 new lins  (`\n\n`)

  #### Chorus
  - Add the word "Chorus", just above the chorus.
  - The word "Chorus" must be preceded by 2 new lines (`\n\n`)
  - The word "Chorus" must be immediately followed by a new line `\n`
  - The last line of the Chorus must be followed by 2 new lines (`\n\n`)

    ### General 
    a. No 3 or more consecutive new lines (`\n\n\n`)
    b. Neither verses nor choruses should start with white-space or indentation



