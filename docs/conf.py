import os
import themata

project = 'Cronux'
copyright = '2020, Adewale Azeez, MIT License'
author = 'Adewale Azeez'

html_theme_path = [themata.get_html_theme_path()]
html_theme = 'clear'
master_doc = 'index'
html_favicon = 'cronux.png'

html_theme_options = {
    'index_is_single': False,
    'show_navigators_in_index': False,
    'has_left_sidebar': True,
    'has_right_sidebar': True,
    'show_navigators': True,
    'social_icons': [
        ('fab fa-twitter', 'https://twitter.com/iamthecarisma'),
        ('fab fa-github', 'https://github.com/Thecarisma/Cronux')
    ]
}