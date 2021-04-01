import os
import themata

project = 'Cronux'
copyright = '2020, Adewale Azeez, MIT License'
author = 'Adewale Azeez'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'fluid'
master_doc = 'index'
html_favicon = 'cronux.png'

html_theme_options = {
    'index_is_single': False,
    'show_navigators_in_index': False,
    'has_left_sidebar': True,
    'has_right_sidebar': True,
    'collapsible_sidebar': True,
    'collapsible_sidebar_display': 'none',
    'show_navigators': True,
    'social_icons': [
        ('fab fa-dev', 'https://dev.to/iamthecarisma'),
        ('fab fa-twitter', 'https://twitter.com/iamthecarisma'),
        ('fab fa-github', 'https://github.com/Thecarisma/Cronux/')
    ],
    "metadata": {
        "enable": True,
        "url": "https://thecarisma.github.io/Cronux/",
        "type": "website",
        "title": "Handy commands to perform simple and complex tasks with Powershell.",
        "description": "Cronux contains Super useful handy commands to perform simple and complex task on the command line. Powershell has powerful command line functionality due to it interopability with visual basic script, the .NET sdk and installed apps. This project also exports over 100 built in commands in powershell to be used from the Windows Command prompt.",
        "image": "https://raw.githubusercontent.com/Thecarisma/Cronux/main/docs/cronux.png",
        "keywords": "thecarisma, powershell, windows, linux, mac, commands, script, batch",
        "author": "Adewale Azeez"
    },
    "twitter_metadata": {
        "enable": True,
        "card": "summary",
        "site": "@iamthecarisma",
        "creator": "@iamthecarisma",
        "title": "Handy commands to perform simple and complex tasks with Powershell.",
        "description": "Cronux contains Super useful handy commands to perform simple and complex task on the command line. Powershell has powerful command line functionality due to it interopability with visual basic script, the .NET sdk and installed apps. This project also exports over 100 built in commands in powershell to be used from the Windows Command prompt.",
        "image": "https://raw.githubusercontent.com/Thecarisma/Cronux/main/docs/cronux.png",
    }
}