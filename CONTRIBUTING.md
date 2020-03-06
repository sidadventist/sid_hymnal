#sid_hymnal 

Please remember to go through our [Code of Conduct]() before contributing.

## Steps to Contributing

1. Fork of this repo. 

2. Install the relevant dev tools.
  - [Node.js](https://nodejs.org/en/download/)
  - [Flutter/Dart](https://flutter.dev/docs/get-started/install) (You can skip this step if you are only contributing a translations)

3. Install dependencies on your local machine.
  
  - Node Packages. Run ```npm install```

4. Make your code edit/changes

5. Run tests. ```npm test``` 

6. Open a pull request

7. Wait for the reviewers to review your work

## Contributing Hymn Translations

1. Hymns are located in the `assets/hymns/{language}` folder. The language folder name must use ISO 639-1 Format.

2. In each languange folder, there should be a meta.json, with the following properties
    - title
    - songs (an object with the number of hymn matched to the title)

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
  - No three or more consecutive new lines (`\n\n\n`)
  - Neither verses nor choruses should start with white-space or indentation


## Contributing to the App

  ### Reporting bugs

  ### Fixing bugs

  ### Adding features/functionality