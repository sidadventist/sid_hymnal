/* eslint-disable max-len */
const fs = require('fs');
const path = require('path');
const YAML = require('yaml');
const pubFile = fs.readFileSync(`${__dirname}/../pubspec.yaml`, 'utf8');
const pubspecContents = YAML.parse(pubFile);
const appAssets = pubspecContents['flutter']['assets'];
const rawLanguagesListFile = fs.readFileSync(`${__dirname}/../assets/translations.json`);
const languagesListFile = JSON.parse(rawLanguagesListFile);

describe('SID_Hymnal', () => {
  const assetDirectories = [];
  const assetsDirPath = `${__dirname}/../assets`;

  // assets folder must contain only Audio and Hymns Folder at root level
  describe('Assets Folder', () => {
    it('Should contain "audio" and "hymns" folder(s), "iso_639_1.json" and "cis-ah.json" file(s))', () => {
      const folderContents = fs.readdirSync(assetsDirPath);
      folderContents.forEach((file) => {
        if (fs.lstatSync(`${assetsDirPath}/${file}`).isDirectory()) {
          assetDirectories.push(file);
        }
      });
      expect(assetDirectories.length).toEqual(2);
      expect(assetDirectories).toContain('audio');
      expect(assetDirectories).toContain('hymns');
      expect(folderContents).toContain('iso_639_1.json');
      expect(folderContents).toContain('cis-ah.json');
    });
  });

  // audio folder
  describe('Audio folder', () => {
    const folderContents = fs.readdirSync(`${assetsDirPath}/audio`);

    // must contain only midi files
    it('Should contain only MIDI files', () => {
      folderContents.forEach((file) => {
        if (!(file.toLowerCase() == '.ds_store') && !(file.toLowerCase() == 'thumbs.db')) {
          expect(path.extname(file).toLowerCase()).toEqual('.midi');
        }
      });
    });


    // files must follow ###.midi format
    it('MIDI files must be named in  ###.midi format', () => {
      folderContents.forEach((file) => {
        if (!(file.toLowerCase() == '.ds_store') && !(file.toLowerCase() == 'thumbs.db')) {
          regex = new RegExp(/\b\d\d\d.midi\b/gi);
          const res = regex.test(file);
          if (!res) {
            console.error(`${file} is not named according to the standard`);
          }
          expect(res).toEqual(true);
        }
      });
    });
  });


  // hymns folder
  describe('Hymns folder', () => {
    const folderContents = fs.readdirSync(`${assetsDirPath}/hymns`);

    it('must contain only folders named in ISO 639-1 Format', () => {
      const rawdata = fs.readFileSync(`${assetsDirPath}/iso_639_1.json`);
      const languages = JSON.parse(rawdata);

      folderContents.forEach((file) => {
        if (!(file.toLowerCase() == '.ds_store') && !(file.toLowerCase() == 'thumbs.db')) {
          expect(fs.lstatSync(`${assetsDirPath}/hymns/${file}`).isDirectory()).toEqual(true);
          expect(file.length).toEqual(2);
          expect(Object.keys(languages)).toContain(file);
        }
      });
    });

    it('must always contain the English (en) folder', () => {
      expect(folderContents).toContain('en');
    });

    describe(`cis-ah.json song entries`, () => {
      const rawdata = fs.readFileSync(`${assetsDirPath}/cis-ah.json`);
      const metaData = JSON.parse(rawdata);
      Object.keys(metaData).forEach((entry) => {
        describe(`key pair "${entry}":"${metaData[entry]}"`, () => {
          it(`must be NUMBERS paired to NUMBER. eg "3":"206" `, () => {
            regex = new RegExp(/^[0-9]*$/gm);
            res = regex.test(entry);
            expect(res).toEqual(true);
            regex = new RegExp(/^[0-9]*$/gm);
            res = regex.test(metaData[entry]);
            expect(res).toEqual(true);
          });
        });
      });
    });

    folderContents.forEach((file) => {
      describe(`(${file})`, () => {
        const subFolderContents = fs.readdirSync(`${assetsDirPath}/hymns/${file}`);
        // folder must contain a "meta.json" file
        if (!(file.toLowerCase() == '.ds_store') && !(file.toLowerCase() == 'thumbs.db')) {
          it(`must contain a "meta.json"  (CASE-SENSITIVE) file`, () => {
            expect(subFolderContents).toContain('meta.json');
          });

          it(`must be registered under assets in the pubspec.yaml file in the following format "- assets/hymns/${file}/"`, () => {
            expect(appAssets).toContain(`assets/hymns/${file}/`);
          });

          it(`ISO 639-1 code (${file}) must be listed in "assets/translations.json"`, () => {
            if (file != 'en') {
              expect(languagesListFile).toContain(`${file}`);
            }
          });

          // let songListLength = 0;
          // the meta.json must contain a "title" and "songs" key
          it(`must have  "title" and "songs" keys (CASE-SENSITIVE) defined in "meta.json"`, () => {
            const rawdata = fs.readFileSync(`${assetsDirPath}/hymns/${file}/meta.json`);
            const metaData = JSON.parse(rawdata);
            expect(metaData).toBeDefined();
            // songListLength = metaData.length;
            expect(Object.keys(metaData)).toContain('title');
            expect(Object.keys(metaData)).toContain('songs');
          });
          describe(`meta.json song entries`, () => {
            const rawdata = fs.readFileSync(`${assetsDirPath}/hymns/${file}/meta.json`);
            const metaData = JSON.parse(rawdata);
            Object.keys(metaData['songs']).forEach((entry) => {
              describe(`key "${entry}"`, () => {
                it(`must be NUMBERS paired to SONG TITLE. eg "2":"The Coming King" `, () => {
                  regex = new RegExp(/^[0-9]*$/gm);
                  const res = regex.test(entry);
                  expect(res).toEqual(true);
                });
              });
              describe(`title: "${metaData['songs'][entry]}"`, () => {
                it(`must not contain any numbers`, () => {
                  regex = new RegExp(/[0-9]/gm);
                  const res = regex.test(metaData['songs'][entry]);
                  expect(res).toEqual(false);
                });
              });
            });
          });
          it(`must have at least 300 songs in "meta.json" songs key`, () => {
            const rawdata = fs.readFileSync(`${assetsDirPath}/hymns/${file}/meta.json`);
            const metaData = JSON.parse(rawdata);
            expect(metaData).toBeDefined();
            expect(Object.keys(metaData['songs']).length).toBeGreaterThanOrEqual(300);
          });

          subFolderContents.forEach((subfile) => {
            // files must follow ###.md format
            it(`Markdown file ${subfile} must be named in  ###.md format`, () => {
              if (!(subfile.toLowerCase() == '.ds_store') && !(subfile.toLowerCase() == 'thumbs.db') && !(subfile.toLowerCase() == 'meta.json')) {
                regex = new RegExp(/\b\d\d\d.md\b/gi);
                const res = regex.test(subfile);
                if (!res) {
                  console.error(`${subfile} is not named according to the standard`);
                }
                expect(res).toEqual(true);
              }
            });

            if (!(subfile.toLowerCase() == '.ds_store') && !(subfile.toLowerCase() == 'thumbs.db') && !(subfile.toLowerCase() == 'meta.json')) {
              describe(`Markdown file (${subfile})`, () => {
                const rawdata = fs.readFileSync(`${assetsDirPath}/hymns/${file}/${subfile}`).toString();
                const windowsNewLines = new RegExp('\r\n');

                rawdata.replace(windowsNewLines, new RegExp('\n'));
                const fileLines = rawdata.split(new RegExp('\n'));

                it(`must contain at least 3 lines`, () => {
                  expect(fileLines.length).toBeGreaterThan(2);
                });

                it(`must begin with level 2 heading (## Your_Song_Title)`, () => {
                  expect(fileLines[0].substring(0, 3)).toEqual('## ');
                });

                it(`must must not include numbers. Song Numbers will be determined by the filename`, () => {
                  regex = new RegExp(/\d/gi);
                  const res = regex.test(fileLines[0]);
                  expect(res).toEqual(false);
                });

                // TODO: write test to ban characters after /\nChorus/gi

                it(`must have a blank line before Chorus`, () => {
                  regex = new RegExp(/.\nchorus\n/gi);
                  const res = regex.test(rawdata);
                  expect(res).toEqual(false);
                });

                it(`must must not have any characters after "\\nChorus"<--No characters allowed after this. Use (newline)Chorus(newline).`, () => {
                  regex = new RegExp(/\nchorus./gi);
                  const res = regex.test(rawdata);
                  expect(res).toEqual(false);
                });

                it(`must must not double line spacing`, () => {
                  regex = new RegExp(/\n\n\n/gi);
                  const res = regex.test(rawdata);
                  expect(res).toEqual(false);
                });

                describe(`Song title ${fileLines[0]}`, () => {
                  it(`must immediately be followed by a new empty line (NO SPACE/CHARACTERS) before the verse`, () => {
                    expect(fileLines[1]).toEqual('');
                  });
                });
              });
            }
          });
          it(`must contain lyric markdown files for each entry in "meta.json" `, () => {
            const lyricFileList = [];
            subFolderContents.forEach((subfile) => {
              if (!(subfile.toLowerCase() == '.ds_store') && !(subfile.toLowerCase() == 'thumbs.db') && !(subfile.toLowerCase() == 'meta.json')) {
                regex = new RegExp(/\b\d\d\d.md\b/gi);
                const res = regex.test(subfile);
                if (res) {
                  lyricFileList.push(file);
                }
              }
            });
            const rawdata = fs.readFileSync(`${assetsDirPath}/hymns/${file}/meta.json`);
            const metaData = JSON.parse(rawdata);
            expect(metaData).toBeDefined();
            expect(lyricFileList.length).toEqual(Object.keys(metaData['songs']).length);
          });
        }
      });
    });
  });
  //
});
