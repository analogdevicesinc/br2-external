from os import path

# -- Project information -----------------------------------------------------

repository = 'br2-external'
project = 'ADI Buildroot External'
copyright = '2025, Analog Devices, Inc.'
author = 'Analog Devices, Inc.'

locale_dirs = ['locales/']  # path is relative to the source directory
language = 'en'

# -- General configuration ---------------------------------------------------

extensions = [
    'adi_doctools',
    'sphinx.ext.intersphinx',
    'sphinx.ext.todo',
]

needs_extensions = {
    'adi_doctools': '0.4.40'
}

exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']
source_suffix = '.rst'

# -- External docs configuration ----------------------------------------------

interref_repos = [
    'hdl',
    'documentation',
]

intersphinx_mapping = {
    'upstream': ('https://docs.kernel.org', None),
}

# -- Options for HTML output --------------------------------------------------

html_theme = 'harmonic'

html_theme_options = {}

html_favicon = path.join("sources", "icon.svg")
