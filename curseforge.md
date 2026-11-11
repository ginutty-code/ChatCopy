Chat Copy - Easily copy and share your chat history! Opens a convenient, resizable window where you can select and copy chat messages to share within or outside the game.

## What it does

- Opens a dedicated copy window with all your visible chat content
- Resizable and movable - drag to position, resize to fit your needs
- Handles large chat histories - up to 500 messages per chat frame
- Clean formatting - automatically removes problematic escape codes
- Clear all chat windows at once with /cc clear
- Easy commands: /chatcopy or /cc

## How to use

1. Install like any other addon
2. In-game, type /chatcopy or /cc
3. A window opens with all your chat content already selected (or you can select only the content you want to copy)
4. Press Ctrl+C to copy
5. Paste it anywhere you need

## Commands

- /cc or /chatcopy - open the copy window
- /cc clear - clear the history of all chat windows (cannot be undone)
- /cc help - list the available commands

*Note: /cc clear only clears your chat windows for the current session. Some UI addons (such as ElvUI and EllesmereUI) save your chat history and restore it after a /reload. If that happens, clear the history in that addon's own settings.*

## Quick tips

- The window is resizable - drag the corner to make it bigger or smaller
- Move it anywhere - click and drag the title bar
- Press Escape or click "Close" to dismiss the window
- Works best with default WoW UI
- Only visible chat frames are included

## Important Note

ElvUI users: ElvUI has its own built-in chat copy feature that works better with ElvUI's extended chat history. This addon is optimized for the default Blizzard UI.

## Changelog

### 1.3.0

- Added /cc clear to clear the history of all chat windows at once (thanks to a user for the suggestion)
- Added /cc help; unknown arguments now show the help instead of opening the window
- Updated for the latest game interface versions (120105, 120107)

### 1.2.0

- Fixed the resize handle causing the window to jump in size when clicked
- Removed the non-functional message type prefixes ([SAY], [GUILD], etc.)
- Fixed cleanup of in-game time strings (e.g. "3 days") misfiring on messages containing more than one
- Improved performance when copying frames with many messages

### 1.1.0

- Added window resizing and moving

### 1.0.0

- Initial version with basic copy feature
