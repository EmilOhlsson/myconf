vim.o.inccommand = 'split'          -- Use Neovim search/replace

vim.o.termguicolors = true          -- Enable RGB based colors, using f ex `guibg=#0123456`
vim.o.autoread = true               -- Don't remember what this does
vim.o.backspace = 'indent,eol,start' -- Don't remember what this does...
vim.o.clipboard = 'unnamedplus'     -- Use the system clipboard
vim.o.completeopt = 'menuone,noselect' -- Only complete common match, display extra information
vim.o.encoding = 'utf-8'            -- Assume utf-8 support of terminal
vim.o.signcolumn = 'yes'
vim.o.hlsearch = true               -- Highlight search results
vim.o.incsearch = true              -- Search as you type
vim.o.modeline = true               -- Read the mode line at the beginning of the file
vim.o.mouse = 'a'                   -- Activate mouse support
vim.o.swapfile = false              -- Don't create swap files
vim.o.shortmess = 'ltToOCFc'          -- Silence a bunch of stuff, mostly default
vim.o.number = true                 -- Show line numbers
vim.o.relativenumber = true         -- Show relative numbers
vim.o.showcmd = true                -- Let last executed command linger for reference
vim.o.showmatch = true              -- Show matching <([{
vim.o.ignorecase = true             -- Ignore casing when searching
vim.o.smartcase = true              -- Do not ignore case if upper case is used
vim.o.wildmenu = true                -- Show possible matches
vim.o.wildmode = 'longest,list,full' -- Order of matching
vim.o.hidden = true                  -- Buffers are hidden instead of closed
vim.o.switchbuf = 'usetab,newtab'    -- use new tab to open files from quickfix
vim.o.splitbelow = true              -- Open splits below
vim.o.splitright = true              -- Open splits to the right
vim.o.cursorline = true              -- Highlight current line
vim.o.fillchars = 'diff: '           -- Indicate missing code
vim.o.cindent = false                -- Disable C indentation

vim.o.wrap = true                        -- Wrap long lines
vim.o.linebreak = true                   -- break long lines at words
vim.o.showbreak = '>>'                   -- Prefix wrapped lines with >>
vim.o.breakindent = true                 -- Indent wrapped lines
vim.o.breakindentopt = 'shift:20,sbr'    -- indent wrapped lines, ShowBReak before indent
vim.o.updatetime = 300                   -- How often to check file, affects autoread, cursorhold etc
vim.o.statusline = [[%<%f%h%m%r%=%b 0x%B  %l,%c%V %P]]
vim.o.laststatus = 2
vim.o.exrc = true                    -- Load local vimrc

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldcolumn = 'auto'
vim.o.foldnestmax = 4
vim.o.foldlevelstart = 99
vim.o.foldtext = ''

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
