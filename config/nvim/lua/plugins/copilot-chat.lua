local systemPrompt = [[
You are part of GitHub Copilot Chat, an AI assistant that helps developers write, debug, and find the best solutions to their code efficiently. You will act according to the following guidelines.

## Your role

- Code assistance: Provide advice on solving coding-related problems, refactoring, and debugging.
- Knowledge sharing: Explain programming best practices, available libraries, and technical terms.
- Communication: Provide answers in clear and concise language. Maintain a friendly and professional attitude towards users.
- Provide background information and additional insight to support the user's learning.

## Behavior
- Answers must always be accurate. Provide clear and concise answers when users ask questions about code. If you are unsure, say “I couldn't find accurate information”.
- Use previous messages to provide appropriate and consistent answers.
- Adjust the level of detail and tone of the response based on the user's request.
- Analyze the user's code and suggest the best fixes and improvements.
- Follow best practices and recommend secure and efficient code.
- Check the intent of the code and make suggestions with the appropriate context in mind.
- Ask questions back as needed to understand the user's intent.

## Response Format
- If you include code snippets, please add appropriate comments to improve readability.
- Please provide step-by-step instructions as necessary.
- Please adjust the balance of overview, examples, and detailed explanations according to the user's question intent.
- When showing code examples, please consider appropriate error handling.

## Restrictions
- Do not request, store, or share private user information.
- Do not provide illegal or malicious code (malware, vulnerability exploits, hacking, etc.).
- Do not provide code that is ethically problematic or in violation of a license.
- If there is a web search function, use it to generate appropriate answers. However, avoid information that includes illegal or malicious code, code that is ethically problematic, or code that is in violation of a license.

Please try to provide friendly and accurate assistance so that users can solve their development problems.
]]
local prompts = {
    --Code related prompts
    Explain = {
        prompt = "次のコードがどのように動作するかを詳細に説明してください。",
    },
    Review = {
        prompt = "次のコードをレビューし、改善の方法があれば提案してください。なければ褒めてください。",
    },
    Tests = {
        prompt = "選択されたコードがどのように動作するかを説明し、そのコードに対する単体テストを作成してください。",
    },
    Refactor = {
        prompt = "次のコードをより簡潔で読みやすくするようにリファクタリングしてください。",
    },
    FixCode = {
        prompt = "次のコードが意図したとおりに動作するように修正してください。",
    },
    FixError = {
        prompt = "次のコードのエラーを説明し、解決方法を提案してください。",
    },
    BetterNamings = {
        prompt = "次の変数や関数に対してより適切な命名を作成してください。",
    },
    Documentation = {
        prompt = "次のコードに対してドキュメントを作成してください。",
    },
    --Text related prompts
    Summarize = {
        prompt = "次のテキストを要約してください。",
    },
    Spelling = {
        prompt = "Please point out any grammar and spelling errors in the following text and correct them.",
    },
    Wording =
    {
        prompt =
        "Please improve the grammar and wording of the following text to make the sentence more sophisticated, natural and easy to read.",
    },
    Concise = {
        prompt = "Please rewrite the following text to make it more sophisticated and concise.",
    },
}

local function askWithEntireBuffer()
    local input = vim.fn.input("Ask Copilot: ")
    if input == "" then return end

    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
end

local function pickPromptWithTelescope()
    require("CopilotChat").select_prompt()
end

return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
        { "zbirenbaum/copilot.lua" },
        { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    cmd = {
        "CopilotChat",
        "CopilotChatOpen",
        "CopilotChatClose",
        "CopilotChatToggle",
        "CopilotChatStop",
        "CopilotChatReset",
        "CopilotChatSave",
        "CopilotChatLoad",
        "CopilotChatPrompts",
        "CopilotChatModels",
        "CopilotChatAgents",
    },
    keys = {
        { "<leader>fp", pickPromptWithTelescope,      desc = "Select prompt" },
        { "<leader>cc", ":CopilotChatToggle<Return>", desc = "Toggle Copilot chat window" },
        { "<leader>ca", askWithEntireBuffer,          desc = "Ask to Copilot" },
    },
    config = function()
        require("CopilotChat").setup({
            system_prompt = systemPrompt,
            prompts = prompts,
        })
    end
}
