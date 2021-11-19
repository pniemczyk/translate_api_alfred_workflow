# Translate API Alfred workflow

If you need to quickly translate text this workflow may be useful. 

You need to create a Google Translate API access token to be able to use this workflow check [instructions](https://cloud.google.com/translate/docs/quickstarts?hl=en)

[Check it out](https://v.usetapes.com/B8R9VzzS86) this is a small presentation

![Preview](https://github.com/pniemczyk/translate_api_alfred_workflow/blob/main/assets/images/preview.gif)

[Download workflow](https://github.com/pniemczyk/translate_api_alfred_workflow/raw/main/Translate%20API.alfredworkflow)

## Requirements

- ruby (checked on version 3.0.2)
- [Alfred](https://www.alfredapp.com/) with [Powerpack](https://www.alfredapp.com/powerpack/)
- Google Translation API key

## Setup

- [Global variables setup](https://v.usetapes.com/UyKRABRtC9)

### Global variables

* GT_API_KEY={your_google_translate_key}
* TARGETS={languages}
* SUBTITLE_ENABLED={when_contain_value_is_true}

> Example
> ```
> GT_API_KEY='122'
> TARGETS='pl,en,ru'
> SUBTITLE_ENABLED=yes
> ```
> Subtitle will be disabled when `SUBTITLE_ENABLED` key or value is missing.
> ```
> GT_API_KEY='122'
> TARGETS='en'
> SUBTITLE_ENABLED=
> ```

### Side notes
The code is written in ruby. Feel free to change the code!
