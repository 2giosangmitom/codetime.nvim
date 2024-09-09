# codetime.nvim

> [!CAUTION]  
> This plugin is still in development and **not stable**. Expect API changes without prior notice.

`codetime.nvim` is a lightweight plugin for tracking your coding time directly inside Neovim. It automatically tracks the time you spend coding, allowing you to view individual session times and accumulate time across multiple sessions. This is perfect for developers looking to monitor productivity or gain insight into their coding habits.

## 🚀 Installation

### Using `lazy.nvim`

To install `codetime.nvim` with `lazy.nvim`, add the following configuration to your plugin list:

```lua
{
  "2giosangmitom/codetime.nvim",
  lazy = false,
  opts = {},
}
```

Ensure that your plugin manager is properly configured to load `codetime.nvim` on Neovim startup.

## ⚙️ Configuration

By default, `codetime.nvim` works out-of-the-box without any additional configuration. However, you can provide options via the `opts` table during setup to customize settings such as the cache path or notification messages.

Example of configuring `codetime.nvim`:

```lua
{
  "2giosangmitom/codetime.nvim",
  lazy = false,
  opts = {
    cache_path = vim.fn.stdpath("cache") .. "/my_custom_codetime.json",
  },
}
```

## 📚 API

`codetime.nvim` exposes a simple API that allows you to integrate coding time data into your Neovim setup, whether in status lines, dashboards, or custom plugins.

### `get_session_time()`

- **Description**: Returns the current coding session's time in a human-readable format (`Xh Ym Zs`).

#### Example usage with `lualine.nvim`

You can display the current session's coding time in your statusline with `lualine.nvim`:

```lua
require("lualine").setup({
  sections = {
    lualine_z = {
      function()
        local api = require("codetime.api")
        return api.get_session_time()
      end
    },
  },
})
```

### `get_total_codetime_today()`

- **Description**: Retrieves the total coding time for the current day, accumulated across all sessions.

#### Example usage

You can print today's total coding time using the API:

```lua
local api = require("codetime.api")
print("Today's total coding time: " .. api.get_total_codetime_today())
```

You can also use the `CodeTime today` command to see today's total coding time directly inside Neovim.

```lua
:CodeTime today
```

## 🔧 Future Features (Planned)

`codetime.nvim` is actively evolving! Here are some features planned for future versions:

- **Project-Based Tracking**: Automatically group coding time based on Git repositories or project directories.
- **File and Language-Specific Tracking**: Track time spent on specific file types or programming languages.

Stay tuned for future updates and features!

## 📄 License

This project is licensed under the MIT License.
