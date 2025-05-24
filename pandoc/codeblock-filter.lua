function CodeBlock(block)
  -- コードブロックが言語を指定している場合
  if block.classes[1] then
    local lang = block.classes[1]
    
    -- 言語名の表示名をマッピング
    local lang_names = {
      ["javascript"] = "JavaScript",
      ["js"] = "JavaScript", 
      ["typescript"] = "TypeScript",
      ["ts"] = "TypeScript",
      ["python"] = "Python",
      ["py"] = "Python",
      ["ruby"] = "Ruby",
      ["rb"] = "Ruby",
      ["go"] = "Go",
      ["golang"] = "Go",
      ["rust"] = "Rust",
      ["rs"] = "Rust",
      ["java"] = "Java",
      ["c"] = "C",
      ["cpp"] = "C++",
      ["cxx"] = "C++",
      ["c++"] = "C++",
      ["csharp"] = "C#",
      ["cs"] = "C#",
      ["php"] = "PHP",
      ["sql"] = "SQL",
      ["html"] = "HTML",
      ["css"] = "CSS",
      ["scss"] = "SCSS",
      ["sass"] = "Sass",
      ["json"] = "JSON",
      ["xml"] = "XML",
      ["yaml"] = "YAML",
      ["yml"] = "YAML",
      ["bash"] = "Bash",
      ["sh"] = "Shell",
      ["shell"] = "Shell",
      ["zsh"] = "Zsh",
      ["fish"] = "Fish",
      ["powershell"] = "PowerShell",
      ["dockerfile"] = "Dockerfile",
      ["docker"] = "Docker",
      ["makefile"] = "Makefile",
      ["make"] = "Makefile",
      ["markdown"] = "Markdown",
      ["md"] = "Markdown"
    }
    
    -- listingsでサポートされている言語のマッピング
    local listings_supported = {
      ["javascript"] = "Java",
      ["js"] = "Java", 
      ["typescript"] = "Java",
      ["ts"] = "Java",
      ["python"] = "Python",
      ["py"] = "Python",
      ["ruby"] = "Ruby",
      ["rb"] = "Ruby",
      ["java"] = "Java",
      ["c"] = "C",
      ["cpp"] = "C++",
      ["cxx"] = "C++",
      ["c++"] = "C++",
      ["csharp"] = "C",
      ["cs"] = "C",
      ["php"] = "PHP",
      ["sql"] = "SQL",
      ["html"] = "HTML",
      ["css"] = "HTML",
      ["bash"] = "bash",
      ["sh"] = "bash",
      ["shell"] = "bash",
      ["makefile"] = "make",
      ["make"] = "make"
    }
    
    local display_name = lang_names[lang:lower()] or lang:upper()
    local listings_lang = listings_supported[lang:lower()] or ""
    
    -- LaTeX形式でコードブロックを生成
    local latex_code = "\\begin{tcolorbox}[enhanced,breakable,colback=codebg,colframe=codeframe,arc=2pt,boxrule=0.5pt,left=8pt,right=8pt,top=8pt,bottom=8pt,fonttitle=\\small\\bfseries,title=" .. display_name .. "]\n"
    
    if listings_lang ~= "" then
      latex_code = latex_code .. "\\begin{lstlisting}[language=" .. listings_lang .. "]\n"
    else
      latex_code = latex_code .. "\\begin{lstlisting}\n"
    end
    
    latex_code = latex_code .. block.text
    latex_code = latex_code .. "\n\\end{lstlisting}\n"
    latex_code = latex_code .. "\\end{tcolorbox}"
    
    return pandoc.RawBlock('latex', latex_code)
  end
  
  -- 言語指定がない場合はデフォルトの処理
  return block
end 