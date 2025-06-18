-- WSL での clipboard の設定を行う
--
-- WSL で実行された際に Powershell を呼び出して Windows のクリップボードと同期する
-- Get-Clipboard と Set-Clipboard を使用するようにしているが、
-- 書き込みに関しては clip.exe を呼び出すほうが速いかもしれない
-- しかし常に Windows のクリップボードを使っているわけではないので別にいいかな
-- (詳細はファイルの最後あたり)

if vim.fn.has("wsl") ~= 1 then
    return
end

local powershell_exe = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"

---iconv を呼び出して文字コードを変換する
---呼び出し結果に含まれる末尾の改行は取り除かれる
---@param input string | string[]
---@param fromCode string
---@param toCode string
---@returns string
local function convert_code_iconv(input, fromCode, toCode)
    local job = vim.system({
        "iconv",
        "--from-code", fromCode,
        "--to-code", toCode
    }, { text = true, stdin = input }):wait()

    if job.code ~= 0 then
        vim.notify(string.format(
            "Failed to convert text from %s to %s: %s\n%s",
            fromCode, toCode, input,
            job.stderr or "No error output"
        ), vim.log.levels.ERROR)
        return ""
    end

    if type(job.stdout) ~= "string" or #job.stdout <= 1 then
        return ""
    else
        -- 末尾の改行を削除
        return job.stdout:sub(1, -2)
    end
end

---@param input string
---@returns string
local function utf8_to_sjis(input)
    return convert_code_iconv(input, "utf-8", "shift_jis")
end

---@param input string
---@returns string
local function sjis_to_utf8(input)
    return convert_code_iconv(input, "shift_jis", "utf-8")
end

---Powershell コマンドを実行する job を召喚する
---@param cmd string
---@param opts vim.SystemOpts | nil
---@param on_exit function | nil
---@returns string
local function call_powershell(cmd, opts, on_exit)
    -- -NoLogo を指定して Powershell 起動時の権利表示をオフにする
    -- そうしないと paste 時に権利表示も含まれてしまう
    -- -NoProfile を指定して Powershell のプロファイルを読み込まないことにより
    -- 起動を高速化し、プロファイルによる振る舞いの変更も避ける
    return vim.system({
        powershell_exe,
        "-NoLogo",
        "-NoProfile",
        "-Command",
        cmd,
    }, opts, on_exit)
end

---Powershell 経由で Windows のクリップボードに内容を格納する
---召喚された job は裏で実行されるので重くならない
---@param contents string[]
---@return nil
local function copy_to_clipboard(contents)
    ---@type string[]
    local lines = {}

    -- 行ごとに分割された文字列を文字配列リテラルに変換する
    -- 例: @('line1', 'line2', 'line3')
    -- なぜか入力は Shift_JIS に変換しなくてもうまくいく
    lines[#contents] = ""
    for i, line in ipairs(contents) do
        lines[i] = line:gsub("'", "''''")
    end
    local contentArg = string.format("@('%s')", table.concat(lines, "', '"))

    call_powershell(
        string.format("Set-Clipboard -Value %s", contentArg),
        { text = true },
        function(job)
            if job.code ~= 0 then
                vim.notify(string.format(
                    "Failed to copy to clipboard.\n%s",
                    utf8_to_sjis(job.stderr) or "No error output"
                ), vim.log.levels.ERROR)
                return
            end

            print(string.format("Copied %d line(s) to clipboard!", #contents))
        end
    )
end

---Powershell 経由で Windows のクリップボードから内容を取得する
---@return { [0]: string[], [1]: string }
local function paste_from_clipboard()
    local job = call_powershell(
        "Get-Clipboard -Format Text -Raw",
        { text = true }
    ):wait()
    if job.code ~= 0 then
        vim.notify(string.format(
            "Failed to paste from clipboard.\n%s",
            utf8_to_sjis(job.stderr) or "No error output"
        ), vim.log.levels.ERROR)
        return { {}, vim.fn.getregtype("") }
    end

    -- 得られた文字列は Shift_JIS なので UTF-8 に変換する
    -- TextFormatType を UnicodeText にしても UTF-8 では取得できない
    -- 多分 Powershell の外部とのインターフェースが Shift-JIS になっているから
    -- 直接バイナリを渡す方法があれば iconv 使わないで済みそう
    return {
        vim.fn.split(sjis_to_utf8(job.stdout), "\n"),
        vim.fn.getregtype(""),
    }
end

local function default_paste()
    return {
        vim.fn.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
    }
end

-- 通常の使用では Windows のクリップボードは使用しない
-- g:clipboard = unnamedplus であることを想定している
-- `*` レジスタを使用するときのみ Windows のクリップボードを使用する
-- `+` レジスタにも設定すれば完全に Windows のクリップボードとも同期されるが
-- 編集操作で Windows 側のクリップボードを頻繁に書き換えたくないのと
-- Powershell の呼び出しが遅くて delete とかの編集がおそくなってしまう
-- あとなんかたまにうまくコピーできないことがあるので編集に支障をきたすので
-- `*` レジスタだけがクリップボードと同期されるようにする
vim.g.clipboard = {
    name = "WSL Clipboard",
    copy = {
        ["+"] = function() end,
        ["*"] = copy_to_clipboard,
    },
    paste = {
        ["+"] = default_paste,
        ["*"] = paste_from_clipboard,
    },
}
