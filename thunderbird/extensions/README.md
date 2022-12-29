reference:
https://webextension-api.thunderbird.net/en/latest/theme.html#theme-themetype

To build this extension, simply run `zip steve.xpi manifest.json` from this directory.

An annotated  manifest file follows:
```
{
  "manifest_version": 2,
  "name": "Steve Theme", 
  "version": "1.0", 
  "applications": {
    "gecko": {
      "strict_min_version": "60.0",
      "id": "{300f47a8-d4bb-0666-8d94-192e8dcdda23}"
    }
  }, 
  "theme": {
    # We don't really want an image because it makes the text blurry.
    "images": {
      "theme_frame": "Header.jpg"
    },
    "colors": {
      "frame": "#006060", # our standard blue-green panel color
      "tab_selected": "#267777" # The selected tab and the toolbar below it"
      "tab_loading": "#1f9afd", # I don't think we ever see thisone.
      "toolbar": "#006060", # The panel above the message body
      "toolbar_text": "black", The text for toolbars, tabs, and icons.
      "toolbar_field": "#f2f2f2", # search box in the toolbar, when not focussed
      "toolbar_field_highlight": "#184880", # Highlight in search field, our dark blue.
      "toolbar_field_highlight_text": "white", # text color for highlight in search field
      "toolbar_field_border": "black",
      "toolbar_field_focus": "white", # The color of the toolbar fields when in focus.
      "toolbar_field_border_focus": "#1f9afd", # border of the currently active field
      "toolbar_top_separator": "#004242", # Goes around the active tab & between inactive tabs and the toolbar.  Our dark panel color.
      "toolbar_bottom_separator": "#004242", # Below the toolbar.
      "toolbar_vertical_separator": "#004242", # Between sections of the toolbar.
      "sidebar": "white", # Folder pane and subject pane
      "sidebar_text": "black", # text of the folder and subject panes
      "sidebar_highlight": "#184880", # focussed selected item, dark blue.
      "sidebar_highlight_text": "white", # focussed selected item text
      "sidebar_border": "#616569", # border between folder and subject panes.
      # Popups include the application menus.
      "popup": "#006060",
      "popup_text": "black",
      "popup_border": "#666",
      "popup_highlight": "#184880",
      "popup_highlight_text": "white"
      "tab_line": "#184880", # a line across the top of the active tab, our dark blue.
    }
  }
}
```
