# sid_hymnal 

Please remember to go through our [Code of Conduct](https://github.com/sidadventist/sid_hymnal/blob/master/CODE_OF_CONDUCT.md) before contributing. 

## What you need to know

#### To contribute a translation. You can learn as you go.
1. Git *(Minimal)* [Tutorial](https://guides.github.com/introduction/git-handbook/)
2. Markdown *(Minimal)* [Tutorial](https://guides.github.com/features/mastering-markdown/)
3. JSON *(Minimal)* [Tutorial](https://www.w3schools.com/js/js_json_intro.asp)

#### To contribute to the app code and/or unit tests:
1. Git *(Proficient)* [Tutorial](https://guides.github.com/introduction/git-handbook/)
2. Markdown *(Minimal)* [Tutorial](https://guides.github.com/features/mastering-markdown/)
3. JSON *(Proficient)* [Tutorial](https://www.w3schools.com/js/js_json_intro.asp)
4. Dart/Flutter. *(Proficient or Expert)* [Tutorial](https://flutter.dev/docs/reference/tutorials)
5. Node.js *(Proficient)* [Tutorial](https://www.w3schools.com/nodejs/)
6. Be familiar with [Android Studio](https://developer.android.com/studio)
7. Be familiar with [XCode](https://developer.apple.com/xcode/)

Good to also know:

8. [Java](https://www.java.com/)
9. [Kotlin](https://kotlinlang.org/)
10. [Objective-C](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)
11. [Swift](https://developer.apple.com/swift/)

#### To contribute to unit tests (for the repo)
1. Git *(Proficient)* [Tutorial](https://guides.github.com/introduction/git-handbook/)
2. Markdown *(Minimal)* [Tutorial](https://guides.github.com/features/mastering-markdown/)
3. JSON *(Proficient)* [Tutorial](https://www.w3schools.com/js/js_json_intro.asp)
4. YAML *(Minimal)* [Tutorial](https://yaml.org/)
5. Node.js *(Proficient)* [Tutorial](https://www.w3schools.com/nodejs/)
5. Jasmine *(Proficient)* [Link](https://jasmine.github.io/pages/getting_started.html)

## Steps to Contributing

1. Fork of this repo. [How?](https://guides.github.com/activities/forking/). 

2. Clone/download your fork to your machine. [How?](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository).

3. Download and install the following Dev Tools.
  - [Git](https://git-scm.com/downloads) *(Required)*
  - [Node.js](https://nodejs.org/en/download/) *(Required)*
  - [Flutter/Dart](https://flutter.dev/docs/get-started/install) (You can skip this step if you are only contributing a translation)

4. Install Dev Dependencies on your local machine by navigating to the folder where you cloned the repo, and running the following command (in Terminal/Command Prompt):

```
npm install
```

5. Make your code edit/changes using an IDE of your choice. For Flutter/Dart, we recommend [Visual Studio Code](https://code.visualstudio.com/)

6. Run tests by navigating to the folder where you cloned the repo, and running the following command  (in Terminal/Command Prompt): 

```
npm test
``` 
7. Push you changes to your fork [How?](https://help.github.com/en/github/using-git/pushing-commits-to-a-remote-repository).

8. Create a pull request. [How?](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork).

9. Wait for the reviewers to review your work.

## Contributing Hymn Translations

1. Hymns are located in the `assets/hymns/{language}` folder. The language folder name must use ISO 639-1 Format.

2. In each languange folder, there should be a `meta.json` file, with the following properties
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
  - Verses must be followed by exactly 2 new lines (`\n\n`)

  #### Chorus
  - Add the word "Chorus", just above the chorus.
  - The word "Chorus" must be preceded by 2 new lines (`\n\n`)
  - The word "Chorus" must be immediately followed by a new line (`\n`)
  - The last line of the Chorus must be followed by 2 new lines (`\n\n`)

  ### General 
  - No three or more consecutive new lines (`\n\n\n`)
  - Neither verses nor choruses should start with white-space or indentation


## Contributing to the App

### Reporting bugs
To report a bug, [Create a new Issue here](https://github.com/sidadventist/sid_hymnal/issues/new?assignees=&labels=&template=bug_report.md&title=).

### Fixing bugs
To fix a bug in the app, follow the steps below. This will save you from fixing something that has already been fixed or is in the process of getting fixed.

1. Visit the [issues section](https://github.com/sidadventist/sid_hymnal/issues) of this repo. 

2. Check to see if the bug has already been reported. (If the bug has not been reported, [Create a new issue](https://github.com/sidadventist/sid_hymnal/issues/new?assignees=&labels=&template=bug_report.md&title=) and report the bug).

3. Open the issue and check to see if no one has already been assigned to work on the issue (bug).

4. If no one is assigned, use the comment section of the issue to inform the maintainers that you wish to work on the issue. 

5. Once you get the go ahead from the maintainers, follow the **Steps to Contributing** (right at the top of this page)

### Adding features/functionality
To add a feature, follow the steps below.

1. Visit the [issues section](https://github.com/sidadventist/sid_hymnal/issues) of this repo. 

2. Locate the issue that describes the new feature you would like to implement. (If no issue about the feature exists, [Create a new issue](https://github.com/sidadventist/sid_hymnal/issues/new?assignees=&labels=&template=feature_request.md&title=) and describe the feature you would like).

3. Open the issue and check to see if no one has already been assigned to work on the issue (new feature).

4. If no one is assigned, use the comment section of the issue to inform the maintainers that you wish to work on the issue. 

5. Once you get the go ahead from the maintainers, follow the **Steps to Contributing** (right at the top of this page).
