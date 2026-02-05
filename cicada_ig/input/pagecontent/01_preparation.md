### This is only if you're interested in the actual code I've written behind this process

- The full [Github Repo is here](https://github.com/Dokotela/cicada)
- The generator is designed to turn the [Supporting Data](https://www.cdc.gov/vaccines/programs/iis/downloads/supporting-data-4.53-508.zip) from [Clinical Decision Support for Immunization (CDSi)](https://www.cdc.gov/vaccines/programs/iis/cdsi.html) into JSON and Dart Classes.
- You'll notice in those downloaded files, they include both XML and XLSX files. Unfortunately (at least for me) I don't like either of these formats.
- All of the XLSX files I've transferred into Gsheets, [the link can be found here](https://drive.google.com/drive/folders/1NL3xJH2Yl98-IvrWMp-Jf2kxMMiYzehj)
- After converting them all to Gsheets format, I then went through and did a regex replace (`" "` for `"\n"`)
- This is due because the carriage return (`"\n"` in Regex) screw up the Gsheets TSV parser in Dart
- The `api.dart` file are credentials for a service account (let me know if you'd like help to do this on your own)
- You can then run the cicada generator (root directory of the project, and run `./generate.sh`)
- There is a time limit about how often you can request data from spreadsheets, so sometimes you do have to edit the sleep time in [download_sheets](https://github.com/Dokotela/cicada/blob/main/cicada_generator/lib/utils/download_sheets.dart#L16)
- This generator also creates two sets of test cases. One with conditions, observations, etc. and one without
