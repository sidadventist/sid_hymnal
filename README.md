# sid_hymnal

SID Seventh-day Adventist Hymnal

## Getting Started

This project is a starting point for a Flutter application.

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
    ### Title
    a. the First line must be a level 2 heading (starting with a "##"). Do not make the heading multiline, only the first line will be parsed as the heading
    b. The First line must be followed by 2 new lines (`\n\n`)

    ### Verses
    a. Verses must be preceded by exactly 2 new lines (`\n\n`)
    b. Verses must be followed by exactly 2 new lins  (`\n\n`)

    ### Chorus
    a. Add the word "Chorus", just above the chorus.
    b. The word "Chorus" must be preceded by 2 new lines (`\n\n`)
    c. The word "Chorus" must be immediately followed by a new line `\n`
    d. The last line of the Chorus must be followed by 2 new lines (`\n\n`)


Ideas:
1. Key/audio
2. iOS needs quick goto button
