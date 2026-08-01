# Chat Copy

A World of Warcraft addon that allows you to easily copy chat content from your chat windows into a convenient, resizable window for copying to external applications.

## Features

- Opens a resizable window displaying all visible chat content from all chat frames
- Easy text selection and copying with standard keyboard shortcuts (Ctrl+A, Ctrl+C)
- Preserves message types with prefixes (System, Say, Yell, Party, Raid, Guild, Whisper, Channel)
- Handles up to 500 messages per chat frame
- Cleans up problematic escape sequences and formatting codes
- Simple slash commands: `/chatcopy` or `/cc`
- Resizable window with drag-to-move functionality
- Scrollable content area for long chat histories
- Works with default WoW UI

## Compatibility

- **Designed for default WoW UI**: This addon works best with the standard Blizzard chat interface
- **ElvUI Users**: ElvUI has its own built-in chat copy function. This addon may not work correctly with ElvUI due to how ElvUI handles chat history restoration

## Installation

1. **Download the addon**:
   - Download the latest release from the repository
   - Extract the `ChatCopy` folder

2. **Install to World of Warcraft**:
   - Navigate to your World of Warcraft installation directory
   - Go to `_retail_\Interface\AddOns\` (or `_beta_` for Retail Beta)
   - Copy the `ChatCopy` folder into the `AddOns` directory

3. **Enable the addon**:
   - Launch World of Warcraft
   - Go to the Character Selection screen
   - Click "AddOns" button in the bottom left
   - Find "Chat Copy Addon" in the list and enable it
   - Click "Okay" to save changes

## Usage

1. Type `/chatcopy` or `/cc` in any chat window
2. A resizable window will open displaying your chat content
3. The text will be automatically selected (or press Ctrl+A to select all)
4. Press Ctrl+C to copy the content
5. Paste it anywhere outside the game (notepad, discord, etc.) using Ctrl+V

### Window Controls

- **Move**: Click and drag the window title bar
- **Resize**: Click and drag the resize handle in the bottom-right corner
- **Close**: Click the "Close" button or press Escape
- **Scroll**: Use mouse wheel or scroll bar to navigate through content

## Message Format

Messages are formatted with prefixes indicating their type:

```
[SYSTEM] System message here
[SAY] Player said something
[YELL] Player yelled something
[PARTY] Party member: message
[RAID] Raid member: message
[GUILD] Guild member: message
[WHISPER] Someone whispered to you
[CHANNEL] Channel message
```

## Limitations

- Timestamps are not included
- Limited to the last 500 messages per chat frame
- Only copies from visible chat frames
- May not work correctly with ElvUI or other chat replacement addons

## Troubleshooting

- **Addon doesn't appear**: Make sure it's enabled in the AddOns menu at character selection
- **No content appears**: Ensure you have visible chat frames with messages
- **Can't select text properly**: This is a known issue when using ElvUI. Consider using ElvUI's built-in chat copy feature instead
- **Messages are cut off**: The addon limits to 500 messages per frame to avoid performance issues

## Technical Details

The addon works by:
1. Iterating through all available chat frames (ChatFrame1-10)
2. Collecting messages from visible frames using `GetMessageInfo`
3. Cleaning up escape sequences and formatting codes
4. Adding message type prefixes for context
5. Calculating appropriate EditBox height based on content
6. Displaying content in a scrollable, resizable window for manual copying

## License

This addon is provided as-is for personal use.

## Version History

- **Latest**: Added resizable window functionality, improved message cleanup, optimized for default WoW UI
