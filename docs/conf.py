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
        ('fab fa-github', 'https://github.com/Thecarisma/themata/')
    ]
}