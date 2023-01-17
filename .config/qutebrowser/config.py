import dracula.draw

c.scrolling.smooth = True

c.editor.command = ["alacritty", "-e", "nvim", "{file}", "-c", "normal {line}G{column0}l"]

c.qt.highdpi = True

c.search.incremental = False

c.session.lazy_restore = True
c.auto_save.session = False

c.spellcheck.languages = ["en-US", "es-ES"]

c.statusbar.widgets = ["keypress", "url", "scroll", "history", "progress"]

c.tabs.tabs_are_windows = True
c.tabs.show = "multiple"

c.url.default_page = "https://search.brave.com"
c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}"
}
c.url.start_pages = c.url.default_page

c.window.title_format = "{perc}{current_title}"

c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.bg = "black"

config.load_autoconfig(False)

config.bind('u', 'undo --window')
config.unbind('d')
config.bind('dd', 'tab-close')

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})
